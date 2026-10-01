# app/models/concerns/krn_denuncia/anonimizador_expediente.rb
#
# Limpieza aplicada:
# - Eliminado todo el flujo de declaraciones (construir_html_declaraciones y
#   helpers): las declaraciones ahora pasan por dos pasos —
#   paso 1: Annm::AnonimizarDclrcnsJob → txt_dclrcn_annmzd por participante
#   paso 2: PdfGeneratable#generar_expediente_anonimizado_dclrcns! → PDF combinado
# - Eliminado generar_expediente_anonimizado_async! (sin uso; el controlador
#   ya no encola Annm::GenerarExpedienteJob).
# - Eliminado construir_html_notificaciones (txt_annm_ntfccns ya es PDF
#   combinado vía PdfGeneratable, no HTML).
# - construir_bloque_upload actualizado al modelo nuevo: el TxtEditable
#   anonimizado de un upload tiene ownr = el ActArchivo y se crea desde la
#   vista (link), no al vuelo.
module KrnDenuncia::AnonimizadorExpediente
  extend ActiveSupport::Concern

  def generar_expediente_anonimizado!(grupo)
    config = ClssAnnmInvstgcns.configuracion(grupo)
    raise ArgumentError, "Grupo '#{grupo}' no configurado" unless config

    Rails.logger.info "[AnonimizadorExpediente] Iniciando '#{grupo}' para Denuncia #{id}"

    html = case ClssAnnmInvstgcns.tipo_grupo(grupo)
           when :coleccion_participantes
             construir_html_coleccion_participantes(config)
           else
             fragmentos = recolectar_fragmentos(config[:archivos] || [])
             fragmentos_to_html(fragmentos)
           end

    if html.blank?
      Rails.logger.warn "[AnonimizadorExpediente] Sin contenido para '#{grupo}'"
      return nil
    end

    guardar_txt_editable(grupo, html)
  end

  def expediente_anonimizado?(grupo)
    txt_editables.exists?(codigo: ClssAnnmInvstgcns.codigo_destino(grupo))
  end

  def expediente_anonimizado(grupo)
    txt_editables.find_by(codigo: ClssAnnmInvstgcns.codigo_destino(grupo))
  end

  private

  # ================================================================
  # COLECCIÓN PARTICIPANTES (PDFs / antecedentes) — txt_annm_medios_de_prueba
  # ================================================================

  def construir_html_coleccion_participantes(config)
    codigo_busqueda = config[:codigo_act_archivo]
    origenes        = config[:origenes] || []
    mensaje_vacio   = config[:mensaje_vacio] || "Sin registros."

    anonimizador = Annm::AnonimizadorContenido.new(self)
    secciones    = []

    origenes.each do |origen|
      participantes = send(origen)
      next if participantes.none?

      participantes.each do |prtcpnt|
        nombre = prtcpnt.respond_to?(:kywrd) ? prtcpnt.kywrd[:krn] : "Participante ##{prtcpnt.id}"
        titulo = "Anonimización de los medios de prueba presentados por #{nombre}"

        archivos = prtcpnt.act_archivos
                          .where(act_archivo: codigo_busqueda)
                          .where(no_annm: [false, nil])
                          .order(:created_at)

        html_archivos = if archivos.any?
                          archivos.map { |act| construir_bloque_archivo(act, anonimizador) }.join("\n")
                        else
                          "<p class='annm-vacio'>#{mensaje_vacio}</p>"
                        end

        secciones << <<~HTML
          <section class="annm-participante" data-participante-id="#{prtcpnt.id}" data-participante-type="#{prtcpnt.class.name}">
            <h2 class="annm-titulo-participante">#{titulo}</h2>
            <div class="annm-archivos">
              #{html_archivos}
            </div>
          </section>
        HTML
      end
    end

    secciones.join("\n")
  end

  # --------------------------------------------------------------
  # Procesa un PDF con el modelo de anonimización
  # --------------------------------------------------------------
  def construir_bloque_archivo(act, anonimizador)
    if act.crtn_mode == 'upload'
      return construir_bloque_upload(act)
    end

    return "" unless act.pdf.attached?

    if act.pdf.byte_size > 10.megabytes
      return <<~HTML
        <div class="annm-archivo" data-act-archivo-id="#{act.id}">
          <h3 class="annm-nombre-archivo">#{act.nombre}</h3>
          <p class="annm-aviso">Archivo muy grande para procesamiento automático (#{number_to_human_size(act.pdf.byte_size)}). Revisión manual requerida.</p>
        </div>
      HTML
    end

    texto = Annm::ExtractorPdf.extract(act.pdf)
    if texto.blank?
      return <<~HTML
        <div class="annm-archivo" data-act-archivo-id="#{act.id}">
          <h3 class="annm-nombre-archivo">#{act.nombre}</h3>
          <p class="annm-error">No fue posible extraer el contenido de este archivo.</p>
        </div>
      HTML
    end

    contenido_anon = anonimizador.anonimizar(texto)

    <<~HTML
      <div class="annm-archivo" data-act-archivo-id="#{act.id}">
        <h3 class="annm-nombre-archivo">#{act.nombre}</h3>
        <div class="annm-contenido">
          #{simple_format_html(contenido_anon)}
        </div>
      </div>
    HTML
  end

  # --------------------------------------------------------------
  # Upload (crtn_mode == 'upload'):
  # El TxtEditable 'annm_<code>' tiene ownr = el ActArchivo y se crea
  # desde la vista (link "Crear versión anonimizada"). Si no existe,
  # se informa como pendiente — ya no se genera al vuelo.
  # --------------------------------------------------------------
  def construir_bloque_upload(act)
    txt       = act.txt_anonimizado_upload
    contenido = txt&.contenido.to_s

    if contenido.blank?
      return <<~HTML
        <div class="annm-archivo" data-act-archivo-id="#{act.id}">
          <h3 class="annm-nombre-archivo">#{act.nombre}</h3>
          <p class="annm-error">Archivo subido por el cliente: versión anonimizada pendiente de redacción.</p>
        </div>
      HTML
    end

    <<~HTML
      <div class="annm-archivo annm-upload" data-act-archivo-id="#{act.id}">
        <h3 class="annm-nombre-archivo">#{act.nombre}</h3>
        <div class="annm-contenido">#{contenido}</div>
      </div>
    HTML
  end

  # ================================================================
  # PERSISTENCIA
  # ================================================================

  def guardar_txt_editable(grupo, html)
    codigo = ClssAnnmInvstgcns.codigo_destino(grupo)

    txt = txt_editables.find_or_initialize_by(codigo: codigo)
    txt.assign_attributes(
      contenido:  html.to_s,
      titulo:     ClssAnnmInvstgcns.titulo(grupo),
      cntxt_clss: ClssAnnmInvstgcns
    )

    if txt.save
      Rails.logger.info "[AnonimizadorExpediente] Guardado TxtEditable '#{codigo}' (id: #{txt.id})"
      txt
    else
      Rails.logger.error "[AnonimizadorExpediente] Error: #{txt.errors.full_messages.to_sentence}"
      nil
    end
  end

  # ================================================================
  # UTILIDADES
  # ================================================================

  def simple_format_html(texto)
    return "" if texto.blank?

    parrafos = texto.split(/\n\s*\n/).map(&:strip).reject(&:blank?)
    parrafos.map { |p| "<p>#{escape_html(p)}</p>" }.join("\n")
  end

  def escape_html(texto)
    texto.to_s.gsub('&', '&amp;')
              .gsub('<', '&lt;')
              .gsub('>', '&gt;')
  end

  def fragmentos_to_html(fragmentos)
    fragmentos.map.with_index do |f, idx|
      <<~HTML
        <section class="annm-seccion" data-codigo="#{f[:codigo]}" data-orden="#{idx + 1}">
          <header class="annm-header"><strong>#{f[:codigo]}</strong></header>
          <div class="annm-contenido">#{f[:contenido]}</div>
        </section>
      HTML
    end.join("\n<hr class='annm-separador' />\n")
  end

  def recolectar_fragmentos(archivos)
    archivos.map do |archivo|
      texto = extraer_texto(archivo)
      { codigo: archivo[:codigo], contenido: texto }
    end
  end

  def extraer_texto(archivo)
    case archivo[:tipo]
    when :mixto
      objeto = archivo[:objeto]
      objeto&.public_send(archivo[:campo_contenido] || :contenido).to_s
    when :pdf_upload, :template
      act = archivo[:act_archivo]
      act&.pdf&.attached? ? Annm::ExtractorPdf.extract(act.pdf) : ""
    else
      ""
    end
  end
end