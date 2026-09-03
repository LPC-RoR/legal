# app/models/clss_annm_invstgcns.rb
class ClssAnnmInvstgcns

  ANNM_CDGS     = ['txt_annm_medios_de_prueba', 'txt_annm_declaraciones']

  OPTNL_CDGS    = []
  NO_TMPLT_CDGS = []

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
    # ------------------------------------------------------------
    # GRUPO: Declaraciones (TxtEditable 'txt_dclrcn' de participantes)
    # ------------------------------------------------------------
    txt_annm_declaraciones: {
      titulo: "Declaraciones anonimizadas",
      descripcion: 'Expediente anonimizado — Declaraciones de los participantes',
      tipo_grupo: :declaraciones,
      codigo_txt_editable: 'txt_dclrcn',
      origenes: [:krn_denunciantes, :krn_denunciados, :krn_testigos]
    },

    # ------------------------------------------------------------
    # GRUPO: Medios de prueba (PDF 'antecedentes' de participantes)
    # ------------------------------------------------------------
    txt_annm_medios_de_prueba: {
      titulo: "Medios de prueba anonimizados",
      descripcion: 'Expediente anonimizado — Medios de prueba presentados por los participantes',
      tipo_grupo: :coleccion_participantes,
      codigo_act_archivo: 'antecedentes',
      origenes: [:krn_denunciantes, :krn_denunciados, :krn_testigos],
      encabezado_participante: ->(prtcpnt) {
        nombre = prtcpnt.respond_to?(:kywrd) ? prtcpnt.kywrd[:krn] : "Participante ##{prtcpnt.id}"
        "Anonimización de los medios de prueba presentados por #{nombre}"
      },
      mensaje_vacio: "El participante no presentó medios de prueba."
    }
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

    def titulo(grupo)
      configuracion(grupo)&.dig(:titulo) || "Expediente anonimizado"
    end

    def descripcion(grupo)
      configuracion(grupo)&.dig(:descripcion) || ""
    end

    def tipo_grupo(grupo)
      configuracion(grupo)&.dig(:tipo_grupo) || :fragmentos
    end

    # ******************************** HCH
    def nombre
      {
        'txt_annm_medios_de_prueba'     => 'Medios de prueba',
        'txt_annm_declaraciones'        => 'Declaraciones de los participantes'
      }.freeze
    end

    def optnl_code?(code)
      OPTNL_CDGS.include?(code)
    end

    def no_tmplt?(code)
      NO_TMPLT_CDGS.include?(code)
    end

    def rdrccn_path(txt_objt)
      "/krn_denuncias/#{txt_objt.ownr.id}_4"
    end

    def dsply_codes_for(ownr)
      ANNM_CDGS
    end

  end
end