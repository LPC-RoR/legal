module CptnMapHelper

	def url_params(url, params = {}, action = :show)
		# Convertir objeto a URL con la acción especificada
		target_url = convert_to_url(url, action)
		return target_url unless target_url.is_a?(String)

		uri = URI(target_url)
		existing_params = Rack::Utils.parse_query(uri.query)

		# Transformar y filtrar parámetros
		new_params = transform_special_params(params.to_h)

		merged_params = existing_params.merge(new_params)
		uri.query = Rack::Utils.build_query(merged_params) unless merged_params.empty?
		uri.to_s
	rescue URI::InvalidURIError
		target_url
	end

	#------------------------------------------------------------------ PARTIALS

	# Obtiene el cntrllr cuando tiene prefijo
	def prfx_cntrllr(cntrllr)
		cntrllr.match(/\-/) ? cntrllr.split('-').first : nil
	end

	# Mantiene el prefijo si o tiene
	def str_cntrllr(source)
		source.class.name == 'String' ? source : source.class.name.tableize
	end

	# source = {controller, objeto}
	def cntrllr(source)
		cntrllr = str_cntrllr(source).split('-').last
		app_alias[cntrllr].blank? ? cntrllr : app_alias[cntrllr]
	end

	## Manejo de SCOPE de archivos
	def pick_scope(v_scope)
		if v_scope.blank?
			nil
		else
			case v_scope.length
			when 0
				nil
			when 1
				v_scope[0]
			else
				v_scope[0].split('/').length == 2 ? v_scope[0] : v_scope[1]
			end
		end
	end

	def with_scope(controller)
		if ['layouts', '0capitan', '0p', 'repositorios', 'karin'].include?(controller)
			controller
		else
			rutas = Rails.application.routes.routes.map {|route| route.defaults[:controller]}.uniq.compact
			scopes = rutas.map {|scope| scope if scope.split('/').include?(controller)}.compact
			pick_scope(scopes)
		end
	end

	# Actualizado para manejar controladores con prefijo
	# El prefijo se transforma en un subdir de 'subdir'
	def prtl_dir(controller, subdir)
		prfx = !!(controller =~ /\-/) ? controller.split('-')[0] : nil
		cntrllr = !!(controller =~ /\-/) ? controller.split('-')[1] : controller.split('-')[0]
		"#{with_scope(cntrllr)}#{"/"+subdir unless subdir.blank?}/#{prfx+"/" unless prfx.blank?}"
	end

	# DEPRECATED
	def prtl_name(source, subdir, partial)
		"#{prtl_dir(str_cntrllr(source), subdir)}#{partial}"
	end

	def prtl_to_file(prtl_nm)
		v_prtl = prtl_nm.split('/')
		v_prtl[v_prtl.length - 1] = "_#{v_prtl.last}"
		"app/views/#{v_prtl.join('/')}.html.erb"
	end

	# str_cntrllr resuelve el source
	def prtl?(source, subdir, partial)
		File.exist?("app/views/#{prtl_dir(str_cntrllr(source), subdir)}_#{partial}.html.erb")
	end

	# Copia de prtl_name
	def prtl(source, subdir, partial)
		"#{prtl_dir(str_cntrllr(source), subdir)}#{partial}"
	end

	def prtl_file?(file)
		File.exist?(file)
	end

	# ----------------------------------------------------------------- SCOPE PARTIALS

	def scp_prtl(scp, dir, prtl)
		"#{scp}/#{dir+'/' unless dir.blank?}#{prtl}"
	end

	def scp_prtl?(scp, dir, prtl)
		prtl_file?(prtl_to_file(scp_prtl(scp, dir, prtl)))
	end

	# ----------------------------------------------------------------- TABLE PARTIALS

	def ownr_prms(objeto, frst = true)
		"#{frst ? '?' : '&'}oclss=#{objeto.class.name}&oid=#{objeto.id}"
	end

	def blngs_prms(objeto, frst = true)
		"#{frst ? '?' : '&'}oid=#{objeto.id}"
	end

	# source = {controller, objeto}
	def objt_prtl(source)
		c = cntrllr(source)
		prtl?(c, 'list', 'lobjeto') ? 'lobjeto' : ( prtl?(c, 'list', 'objeto') ? 'objeto' : nil )
	end

	def objt_prtl_name(source)
		src_prtl = objt_prtl(source)
		c = cntrllr(source)
		src_prtl.blank? ? nil : prtl_name(c, 'list', src_prtl)
	end

	# ----------------------------------------------------------------- 

	## -------------------------------------------------------- BANDEJAS
	## EN REVISIÓN, se eliminó el uso de layouts, hay que revisar manejo de estados

	def primer_estado(controller)
		st_modelo = StModelo.find_by(st_modelo: controller.classify)
		st_modelo.blank? ? nil : st_modelo.primer_estado.st_estado
	end

	def count_modelo_estado(modelo, estado)0
		modelo.constantize.where(estado: estado).count == 0 ? '' : "(#{modelo.constantize.where(estado: estado).count})"
	end

	## -------------------------------------------------------- TABLAS ORDENADAS

	def ordered_controllers
		['st_estados', 'tar_pagos', 'tar_formulas', 'tar_comentarios']
	end

	def ordered_controller?(controller)
		ordered_controllers.include?(controller)
	end

  private

  # Se usa para  url_params
  def convert_to_url(value, action)
    return value if value.is_a?(String)
    
    # Verificar si es un modelo o una clase
    if (value.respond_to?(:to_param) && value.respond_to?(:model_name)) || 
       (value.is_a?(Class) && value.respond_to?(:model_name))
      
      case action
      when :edit
        polymorphic_url([:edit, value])
      when :new
        # Para :new, necesitamos la clase del modelo
        model_class = value.is_a?(Class) ? value : value.class
        polymorphic_url(model_class, action: :new)
      when :destroy, :show
        polymorphic_url(value)
      else
        polymorphic_url(value)
      end
    else
      value.to_s
    end
  rescue StandardError
    value.to_s
  end

  def transform_special_params(params)
    return {} unless params.is_a?(Hash)
    
    result = params.stringify_keys.compact
    
    # Transformar ownr
    if result.key?('ownr')
      ownr = result.delete('ownr')
      if ownr.present?
        result['oclss'] = ownr.class.name
        result['oid'] = ownr.id if ownr.respond_to?(:id)
      end
    end
    
    # Transformar blngs
    if result.key?('blngs')
      blngs = result.delete('blngs')
      result['bid'] = blngs.id if blngs.present? && blngs.respond_to?(:id)
    end
    
    result.compact
  end

end