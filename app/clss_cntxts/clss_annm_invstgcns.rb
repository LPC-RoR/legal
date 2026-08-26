# app/models/clss_annm_invstgcns.rb
class ClssAnnmInvstgcns
  # ================================================================
  # CONFIGURACIÓN DE GRUPOS DE ANONIMIZACIÓN
  # ================================================================
  # Cada grupo se mapea a UN TxtEditable destino.
  #
  # :archivos → Array de definiciones. Cada una indica:
  #   :codigo  → Código del ActArchivo o TxtEditable a buscar
  #   :tipo    → :mixto (TxtEditable), :pdf_upload, :template
  #   :origen  → :directo, :krn_denunciantes, :krn_denunciados, :krn_testigos
  #   :scope   → Lambda opcional para filtrar la relación
  #   :campo_contenido → Para :mixto, campo del TxtEditable (default: :contenido)
  # ================================================================

  CONFIGURACION = {
  CONFIGURACION = {
    # ------------------------------------------------------------
    # GRUPO: Medios de prueba (antecedentes de todos los participantes)
    # ------------------------------------------------------------
    txt_annm_medios_de_prueba: {
      descripcion: 'Expediente anonimizado — Medios de prueba presentados por los participantes',
      tipo_grupo: :coleccion_participantes,
      codigo_act_archivo: 'antecedentes',
      origenes: [:krn_denunciantes, :krn_denunciados, :krn_testigos],
      encabezado_participante: ->(prtcpnt) {
        nombre = prtcpnt.respond_to?(:kywrd) ? prtcpnt.kywrd[:krn] : "Participante ##{prtcpnt.id}"
        "Anonimización de los medios de prueba presentados por #{nombre}"
      },
      mensaje_vacio: "El participante no presentó medios de prueba."
    },

  }.freeze

  class << self
    def configuracion(grupo)
      CONFIGURACION[grupo.to_sym]
    end

    def grupos_disponibles
      CONFIGURACION.keys
    end

    def codigo_destino(grupo)
      grupo.to_sym
    end

    def descripcion(grupo)
      configuracion(grupo)&.dig(:descripcion)
    end

    def archivos_para(grupo)
      configuracion(grupo)&.dig(:archivos) || []
    end

    # --------------------------------------------------------------
    # Inferencia por convención (fallback si no se declara :tipo)
    # --------------------------------------------------------------
    def tipo_para(codigo)
      codigo_str = codigo.to_s

      if codigo_str.start_with?('txt_')
        :mixto
      elsif template_conocido?(codigo_str)
        :template
      else
        :pdf_upload
      end
    end

    def template_conocido?(codigo)
      %w[
        denuncia carta notificacion memorandum
        crdncn_apt dts_prncpls dts_tstgs
        dnncnt_info_oblgtr comprobante
      ].include?(codigo.to_s)
    end
  end
end