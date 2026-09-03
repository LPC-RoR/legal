# app/models/concerns/krn_denuncia/anonimizador_expediente.rb
module KrnDenuncia::AnonimizadorExpediente
  extend ActiveSupport::Concern

  def generar_expediente_anonimizado!(grupo)
    config = ClssAnnmInvstgcns.configuracion(grupo)
    raise ArgumentError, "Grupo '#{grupo}' no configurado" unless config

    Rails.logger.info "[AnonimizadorExpediente] Iniciando '#{grupo}' para Denuncia #{id}"

    html = case ClssAnnmInvstgcns.tipo_grupo(grupo)
           when :coleccion_participantes
             construir_html_coleccion_participantes(config)
           when :declaraciones
             construir_html_declaraciones(config)
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
  # DECLARACIONES
  # ================================================================

  def construir_html_declaraciones(config)
    codigo_busqueda = config[:codigo_txt_editable]
    origenes        = config[:origenes] || []

    anonimizador = Annm::AnonimizadorDeclaraciones.new(self)
    secciones    = []

    origenes.each do |origen|
      participantes = send(origen)
      next if participantes.none?

      participantes.each do |prtcpnt|
        txt = prtcpnt.txt_editables
                     .where(codigo: codigo_busqueda)
                     .order(created_at: :desc)
                     .first

        # CRÍTICO: Extraer HTML como String desde ActionText::RichText
        html_raw = txt&.contenido&.to_s

        if html_raw.blank?
          secciones << construir_seccion_declaracion_vacia(prtcpnt)
          next
        end

        Rails.logger.info "[AnonimizadorExpediente] Anonimizando declaración de #{prtcpnt.class.name}##{prtcpnt.id}"
        contenido_anon = anonimizador.anonimizar(html_raw)

        secciones << <<~HTML
          <section class="annm-declaracion" data-participante-id="#{prtcpnt.id}" data-participante-type="#{prtcpnt.class.name}" data-abrev="#{prtcpnt.kywrd[:abrev]}">
            #{encabezado_declaracion(prtcpnt)}
            <div class="annm-contenido-declaracion">
              #{contenido_anon}
            </div>
          </section>
        HTML
      end
    end

    secciones.join("\n<hr class='annm-separador' style='margin:24px 0;border:none;border-top:2px solid #ddd;' />\n")
  end

  def encabezado_declaracion(prtcpnt)
    abrev = prtcpnt.respond_to?(:kywrd) ? prtcpnt.kywrd[:abrev] : "P#{prtcpnt.id}"

    fecha_declaracion = if prtcpnt.respond_to?(:dnnc) && prtcpnt.dnnc.respond_to?(:krn_declaraciones)
                          ultima = prtcpnt.dnnc.krn_declaraciones.last
                          ultima&.fecha ? formatear_fecha_hora(ultima.fecha) : "fecha no registrada"
                        else
                          "fecha no registrada"
                        end

    linea_interrumpida = if prtcpnt.respond_to?(:dclrcn_intrrmpd) && prtcpnt.dclrcn_intrrmpd.present?
                           <<~HTML
                             <p class="annm-meta-interrumpido" style="color:#b45309;background:#fffbeb;padding:6px 10px;border-radius:4px;margin:6px 0 0 0;">
                               <strong>Declaración interrumpida:</strong> #{escape_html(prtcpnt.dclrcn_intrrmpd)}
                             </p>
                           HTML
                         else
                           ""
                         end

    <<~HTML
      <div class="annm-encabezado-declaracion" style="margin-bottom:16px;padding:12px 16px;background:#f8fafc;border-left:4px solid #334155;border-radius:0 6px 6px 0;">
        <h2 class="annm-titulo-principal" style="margin:0 0 8px 0;font-size:1.1em;color:#0f172a;">
          Anonimización de declaración — #{abrev}
        </h2>
        <p class="annm-meta-fecha" style="margin:0 0 4px 0;font-size:0.85em;color:#475569;">
          El texto presentado a continuación corresponde a la declaración tomada con fecha #{fecha_declaracion}
        </p>
        <p class="annm-meta-disclaimer" style="margin:0;font-size:0.8em;color:#64748b;font-style:italic;">
          La procedimiento de anonimización ha sido realizado por un agente de inteligencia artificial y revisado por el investigador asignado a la denuncia.
        </p>
        #{linea_interrumpida}
      </div>
    HTML
  end

  def construir_seccion_declaracion_vacia(prtcpnt)
    abrev = prtcpnt.respond_to?(:kywrd) ? prtcpnt.kywrd[:abrev] : "P#{prtcpnt.id}"

    <<~HTML
      <section class="annm-declaracion annm-vacia" data-participante-id="#{prtcpnt.id}" data-participante-type="#{prtcpnt.class.name}" data-abrev="#{abrev}">
        <div class="annm-encabezado-declaracion" style="margin-bottom:16px;padding:12px 16px;background:#f8fafc;border-left:4px solid #334155;border-radius:0 6px 6px 0;">
          <h2 class="annm-titulo-principal" style="margin:0 0 8px 0;font-size:1.1em;color:#0f172a;">
            Anonimización de declaración — #{abrev}
          </h2>
        </div>
        <p class="annm-mensaje-vacio">El participante no registró declaración.</p>
      </section>
    HTML
  end

  # ================================================================
  # COLECCIÓN PARTICIPANTES (PDFs / antecedentes)
  # ================================================================

  def construir_html_coleccion_participantes(config)
    codigo_busqueda = config[:codigo_act_archivo]
    origenes        = config[:origenes] || []
    mensaje_vacio   = config[:mensaje_vacio] || "Sin registros."
    encabezado_fn   = config[:encabezado_participante]

    secciones = []

    origenes.each do |origen|
      participantes = send(origen)
      next if participantes.none?

      participantes.each do |prtcpnt|
        titulo = encabezado_fn ? encabezado_fn.call(prtcpnt) : "Participante ##{prtcpnt.id}"
        archivos = prtcpnt.act_archivos.where(act_archivo: codigo_busqueda).order(:created_at)

        html_archivos = if archivos.any?
                          archivos.map { |act| construir_bloque_archivo(act) }.join("\n")
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

  def construir_bloque_archivo(act)
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
  # PERSISTENCIA
  # ================================================================

  def guardar_txt_editable(grupo, html)
    codigo = ClssAnnmInvstgcns.codigo_destino(grupo)

    txt = txt_editables.find_or_initialize_by(codigo: codigo)
    txt.assign_attributes(
      contenido: html.to_s,
      titulo: ClssAnnmInvstgcns.titulo(grupo),
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

  def formatear_fecha_hora(fecha)
    return "fecha no registrada" unless fecha.respond_to?(:strftime)

    if respond_to?(:dma_hm)
      dma_hm(fecha)
    else
      fecha.strftime("%d/%m/%Y %H:%M")
    end
  rescue => e
    Rails.logger.warn "[AnonimizadorExpediente] Error formateando fecha: #{e.message}"
    "fecha no registrada"
  end

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
end