# app/models/clss_txt.rb
# Gestión de KrnTexto en sus distintos usos
# Esta clase distribuye a las diferentes clases
class ClssTxt

	CONTEXT_MAP = {
	    # === PLATAFORMA (pltfrm) ===
	    'actividad_plataforma'      => :pltfrm,
	    'estadisticas_generales'    => :pltfrm,
	    
	    # === INVESTIGACIONES (invstgcns) ===
	    'txt_mdds_rsgrd'			=> :invstgcns,
	    'txt_objcn_rslcn'			=> :invstgcns,
	    'txt_anlss'					=> :invstgcns,
	    'txt_infrm'					=> :invstgcns,
	    'txt_emprs_dnnc'			=> :invstgcns,
	    'dnnc_annmzd'				=> :invstgcns,
	    'dnnc_rsmn'					=> :invstgcns,
	    'txt_rprsntcn'				=> :invstgcns,
	    'txt_slctd_516'				=> :invstgcns,
	    'txt_acta'					=> :invstgcns,
	    'txt_dclrcn'				=> :invstgcns,
	    'texto_anonimizado'			=> :invstgcns,
	    'resumen_cronologico'		=> :invstgcns,
	    'confirmacion_hechos'		=> :invstgcns,
	    'txt_firma'					=> :invstgcns,
	    'txt_invstgdr'				=> :invstgcns,
	    'txt_dsgncn'				=> :invstgcns,
	    'txt_firma_rcpcn'			=> :invstgcns,
	    'txt_emprs'					=> :invstgcns,
	    'txt_mdds_crrctvs_sncns'	=> :invstgcns,
	    'firma_mdds'				=> :invstgcns,
	    
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
	    pltfrm:     'ClssTxtPltfrm',
	    invstgcns:  'ClssTxtInvstgcns',
	    fnnzs:      'ClssTxtFnnzs',
	    srvcs:      'ClssTxtSrvcs',
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
	    def list_for(reporte)
	      CONTEXT_MAP[reporte.to_s] || raise("Reporte '#{reporte}' no está mapeado en ClssPdf")
	    end

	    # Verifica si el reporte existe
	    def valid_report?(reporte)
	      CONTEXT_MAP.key?(reporte.to_s)
	    end

	    # Obtiene la clase de contexto
	    def context_class(reporte)
	      context = CONTEXT_MAP[reporte]
	      CONTEXT_CLASSES[context].constantize
	    end

	    # Obtiene el directorio de templates
	    def context_dir(reporte)
	      context = CONTEXT_MAP[reporte]
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


	# DEPRECATED
	CAUSA_TXTS = ['causa_cuantia']	

	def self.causa_txt?(code)
		ClssTxt::CAUSA_TXTS.include?(code)
	end

	def self.txt_clss?(code)
		ClssTxt::CAUSA_TXTS.include?(code) ? ClssTxtCausa : ClssPdfRprt
	end

	def self.txt_name_clss?(code)
		ClssTxt::CAUSA_TXTS.include?(code) ? ClssTxtCausa : ClssPrcdmnt
	end

end