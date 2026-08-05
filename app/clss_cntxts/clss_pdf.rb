# app/models/clss_pdf.rb
class ClssPdf
  # Mapa de reportes a contextos
  # Cada reporte pertenece a un único contexto
  CONTEXT_MAP = {
    # === PLATAFORMA (pltfrm) ===
    'demanda'                   => :pltfrm,
    'estadisticas_generales'    => :pltfrm,
    
    # === INVESTIGACIONES (invstgcns) ===
    'crdncn_apt'                => :invstgcns,    # ← COORDINACIÓN DE APT
    'dts_prncpls'               => :invstgcns,    # ← DATOS DE LOS PARTICIPANTES PRINCIPALES
    'dts_tstgs'                 => :invstgcns,    # ← DATOS DE LOS TESTIGOS
    'denuncia'                  => :invstgcns,    # ← DENUNCIA
    'dnnc_annmzd'               => :invstgcns,    # ← DENUNCIA ANONIMIZADA
    'dnnc_rsmn'                 => :invstgcns,    # ← DENUNCIA RESUMEN DE HECHOS
    'dnncnt_info_oblgtr'        => :invstgcns,    # ← INFORMACIÓN OBLIGATORIA PARA LAS PERSONAS DENUNCIANTES
    'comprobante'               => :invstgcns,    # ← COMPROBANTE DE RECEPCIÓN DE DENUNCIA
    'invstgcn'                  => :invstgcns,    # ← NOTIFICACIÓN DEL INICIO DE LA INVESTIGACIÓN
    'drchs'                     => :invstgcns,    # ← DERECHOS Y OBLIGACIONES DE LOS PARTICIPANTES
    'apt'                       => :invstgcns,    # ← EVIDENCIAS DE ATENCIÓN PSICOLÓGICA TEMPRANA
    'txt_mdds_rsgrd'            => :invstgcns,    # ← MEDIDAS DE RESGUARDO
    'antecedentes'              => :invstgcns,    # ← DOCUMENTOS PRESENTADOS POR EL PARTICIPANTE
    'invstgdr'                  => :invstgcns,    # ← NOTIFICACIÓN DEL INVESTIGADOR ASIGNADO
    'invstgdr_titulo_prfsnl'    => :invstgcns,    # ← TÍTULO PROFESIONAL DEL INVESTIGADOR
    'txt_invstgdr_dsgncn'       => :invstgcns,    # ← DECLARACIÓN DE LA DESIGNACIÓN DEL INVESTIGADOR
    'dsgncn_invstgdr'           => :invstgcns, #Temporal
    'declaracion'               => :invstgcns,    # ← DECLARACIÓN FIRMADA
    'dnnc'                      => :invstgcns,
    'st_dclrcns'                => :invstgcns,
    'dclrcn'                    => :invstgcns,
    'txt_dclrcn'                => :invstgcns,    # ← DECLARACIÓN (texto para firma)
    'txt_infrm'                 => :invstgcns,
    'texto_anonimizado'         => :invstgcns,
    'resumen_cronologico'       => :invstgcns,
    'txt_mdds_crrctvs_sncns'    => :invstgcns,    # ← MEDIDAS CORRECTIVAS Y SANCIONES
    'txt_dnnc_annmzd'           => :invstgcns,    # ← DENUNCIA ANONIMIZADA
    'txt_dclrcn_annmzd'         => :invstgcns,    # ← DECLARACIÓN ANONIMIZADA
    'txt_dclrcn_rsmn'           => :invstgcns,    # ← HECHOS DE LA DECLARACIÓN
    'expdnt_annmzd_crtl'        => :invstgcns,    # ← CARÁTULA DEL EXPEDIENTE ANONIMIZADO
    'expdnt_annmzd_pruebas'     => :invstgcns,    # ← SECCIÓN MEDIOS DE PRUEBA DEL EXPEDIENTE ANONIMIZADO
    
    # === FINANZAS (fnnzs) ===
    'aprobacion'                => :fnnzs,    # ← APROBACIÓNES DE CAUSAS
    'estado_resultados'         => :fnnzs,
    'flujo_efectivo'            => :fnnzs,
    'honorarios'                => :fnnzs,
    'doc_honorario'             => :fnnzs,
    
    # === SERVICIOS (srvcs) ===
    'ordenes_trabajo'           => :srvcs,
    'reporte_servicios'         => :srvcs,
    'clientes_activos'          => :srvcs,
  }.freeze

  # Clases de contexto asociadas
  CONTEXT_CLASSES = {
    pltfrm:     'ClssPdfPltfrm',
    invstgcns:  'ClssPdfInvstgcns',
    fnnzs:      'ClssPdfFnnzs',
    srvcs:      'ClssPdfSrvcs',
  }.freeze

  # Directorios de templates por contexto
  CONTEXT_DIRS = {
    pltfrm:     'pltfrm',
    invstgcns:  'invstgcns',
    fnnzs:      'fnnzs',
    srvcs:      'srvcs',
  }.freeze

  class << self

    def txt_code?(code)
      code.start_with?('txt_')
    end

    # Obtiene el contexto de un reporte
    def context_for(reporte)
      CONTEXT_MAP[reporte.to_s] || raise("Reporte '#{reporte}' no está mapeado en ClssPdf")
    end

    # Verifica si el reporte existe
    def valid_report?(reporte)
      CONTEXT_MAP.key?(reporte.to_s)
    end

    # Obtiene la clase de contexto
    def context_class(reporte)
      context = context_for(reporte)
      CONTEXT_CLASSES[context].constantize
    end

    # Obtiene el directorio de templates
    def context_dir(reporte)
      context = context_for(reporte)
      CONTEXT_DIRS[context]
    end

    # Lista de reportes por contexto
    def reportes_por_contexto(ctx)
      CONTEXT_MAP.select { |_, v| v == ctx.to_sym }.keys
    end

    # Todos los reportes
    def todos_los_reportes
      CONTEXT_MAP.keys
    end
  end
end