# app/models/concerns/krn_denuncia/anonimizador_expediente.rb
module KrnDenuncia::AnonimizadorExpediente
  extend ActiveSupport::Concern

  # ================================================================
  # API PÚBLICA
  # ================================================================

  def generar_expediente_anonimizado!(grupo)
    config = ClssAnnmInvstgcns.configuracion(grupo)
    raise ArgumentError, "Grupo '#{grupo}' no configurado" unless config

    Rails.logger.info "[AnonimizadorExpediente] Iniciando '#{grupo}' para Denuncia #{id}"

    html = case ClssAnnmInvstgcns.tipo_grupo(grupo)
           when :coleccion_participantes
             construir_html_coleccion_participantes(config)
           else
             # Fallback al patrón fragmentos (por si agregas otros grupos luego)
             fragmentos = recolectar_fragmentos(config[:archivos] || [])
             fragmentos_to_html(fragmentos)
           end

    if html.blank?
      Rails.logger.warn "[AnonimizadorExpediente] Sin contenido para '#{grupo}'"
      return nil
    end

    guardar_txt_editable(grupo, config[:descripcion], html)
  end

  def generar_expediente_anonimizado_async!(grupo)
    Annm::GenerarExpedienteJob.perform_later(id, grupo)
  end

  def expediente_anonimizado?(grupo)
    txt_editables.exists?(codigo: ClssAnnmInvstgcns.codigo_destino(grupo))
  end

  def expediente_anonimizado(grupo)
    txt_editables.find_by(codigo: ClssAnnmInvstgcns.codigo_destino(grupo))
  end

  private

  # ================================================================
  # COLECCIÓN POR PARTICIPANTE
  # (caso txt_annm_medios_de_prueba)
  # ================================================================

  def construir_html_coleccion_participantes(config)
    origenes = config[:origenes] || []
    codigo_busqueda = config[:codigo_act_archivo]
    mensaje_vacio = config[:mensaje_vacio] || "Sin registros."
    encabezado_fn = config[:encabezado_participante]

    secciones = []

    origenes.each do |origen|
      participantes = send(origen) # krn_denunciantes, krn_denunciados, krn_testigos
      next if participantes.none?

      participantes.each do |prtcpnt|
        secciones << construir_seccion_participante(
          prtcpnt,
          codigo_busqueda,
          encabezado_fn,
          mensaje_vacio
        )
      end
    end

    secciones.join("\n")
  end

  def construir_seccion_participante(prtcpnt, codigo, encabezado_fn, mensaje_vacio)
    titulo = encabezado_fn ? encabezado_fn.call(prtcpnt) : "Participante ##{prtcpnt.id}"
    archivos = prtcpnt.act_archivos.where(act_archivo: codigo).order(:created_at)

    html_archivos = if archivos.any?
                      archivos.map { |act| construir_bloque_archivo(act) }.join("\n")
                    else
                      "<p class='annm-vacio'>#{mensaje_vacio}</p>"
                    end

    <<~HTML
      <section class="annm-participante" data-participante-id="#{prtcpnt.id}" data-participante-type="#{prtcpnt.class.name}">
        <h2 class="annm-titulo-participante">#{titulo}</h2>
        <div class="annm-archivos">
          #{html_archivos}
        </div>
      </section>
    HTML
  end

  def construir_bloque_archivo(act)
    return "" unless act.pdf.attached?

    texto = Annm::ExtractorPdf.extract(act.pdf)
    if texto.blank?
      Rails.logger.warn "[AnonimizadorExpediente] PDF #{act.id} sin texto extraíble"
      return <<~HTML
        <div class="annm-archivo" data-act-archivo-id="#{act.id}">
          <h3 class="annm-nombre-archivo">#{act.nombre}</h3>
          <p class="annm-error">No fue posible extraer el contenido de este archivo.</p>
        </div>
      HTML
    end

    contenido_anon = act.anonimizar_inteligente(texto, cdgs_prtcpnts)

    <<~HTML
      <div class="annm-archivo" data-act-archivo-id="#{act.id}">
        <h3 class="annm-nombre-archivo">#{act.nombre}</h3>
        <div class="annm-contenido">
          #{simple_format_html(contenido_anon)}
        </div>
      </div>
    HTML
  end

  # ================================================================
  # PATRÓN FRAGMENTOS (fallback / otros grupos)
  # ================================================================

  def recolectar_fragmentos(archivos_config)
    # ... (mismo código que en la versión anterior, omitido por brevedad)
    # Retorna un Array de Hashes { codigo:, tipo:, contenido: }
    []
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

  # ================================================================
  # PERSISTENCIA
  # ================================================================

  def guardar_txt_editable(grupo, descripcion, html)
    codigo = ClssAnnmInvstgcns.codigo_destino(grupo)

    txt = txt_editables.find_or_initialize_by(codigo: codigo)
    txt.assign_attributes(contenido: html, descripcion: descripcion)

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

  # Convierte texto plano extraído de PDF a HTML básico respetando párrafos
  def simple_format_html(texto)
    return "" if texto.blank?

    parrafos = texto.split(/\n\s*\n/).map(&:strip).reject(&:blank?)
    parrafos.map { |p| "<p>#{escape_html(p)}</p>" }.join("\n")
  end

  def escape_html(texto)
    texto.gsub('&', '&amp;')
         .gsub('<', '&lt;')
         .gsub('>', '&gt;')
  end
end