# app/models/clss_pdf.rb
class ClssPdf
  # Mapa de reportes a contextos
  # Cada reporte pertenece a un único contexto
  CONTEXT_MAP = {
    # === PLATAFORMA (pltfrm) ===
    'actividad_plataforma'      => :pltfrm,
    'estadisticas_generales'    => :pltfrm,
    
    # === INVESTIGACIONES (invstgcns) ===
    'dnnc'                      => :invstgcns,
    'st_dclrcns'                => :invstgcns,
    'dclrcn'                    => :invstgcns,
    'txt_dclrcn'                => :invstgcns,
    'crdncn_apt'                => :invstgcns,
    'infrmcn'                   => :invstgcns,
    'txt_infrm'                 => :invstgcns,
    'texto_anonimizado'         => :invstgcns,
    'resumen_cronologico'       => :invstgcns,
    'txt_mdds_crrctvs_sncns'    => :invstgcns,   # ← NUEVO
    
    # === FINANZAS (fnnzs) ===
    'aprobacion'                => :fnnzs,
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