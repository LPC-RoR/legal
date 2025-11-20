module CptnHelper

# O mejor, usa la zona horaria explícitamente:
def ajustar_fecha_santiago(fecha)
  return nil if fecha.blank?
  
  # Si la fecha viene del LATERAL JOIN (sin zona), forzala a Santiago
  Time.use_zone('America/Santiago') do
    Time.zone.parse(fecha.to_s)
  end
end

	# Permite personalizar los PDF con el logo de la empresa
	# app/helpers/application_helper.rb
	def pdf_image_base64(source)
	  if source.respond_to?(:attached?) && source.attached?
	    # Para Active Storage
	    "data:#{source.content_type};base64,#{Base64.strict_encode64(source.download)}"
	  else
	    # Para archivos en app/assets/images
	    path = Rails.root.join('app/assets/images', source.to_s)
	    "data:image/png;base64,#{Base64.strict_encode64(File.read(path))}"
	  end
	rescue
	  # Imagen por defecto si algo falla
	  "data:image/png;base64,#{Base64.strict_encode64(File.read(Rails.root.join('app/assets/images/logo/logo_60.png')))}"
	end

# ******************************************************************** CONSTANTES 

	#Cambiar paulatinamente por cfg_color
	def color(ref)
		cfg_color[ref]
	end

# ******************************************************************** HELPERS DE USO GENERAL

	def nombre(objeto)
		objeto.send(objeto.class.name.tableize.singularize)
	end

	def perfiles_operativos
		AppNomina.all.map {|nomina| nomina.nombre}.compact
	end

	# Manejo de options para selectors múltiples (VERSION PARA MULTI TABS SIN CAMBIOS)
	def get_html_opts(options, label, value)
		opts = options.clone
		opts[label] = value
		opts
	end

	def h_tipos_usuario(app_nmn)
		['Empresa', 'Cliente'].include?(app_nmn.ownr_type) ? ['admin', 'recepción', 'investigador', 'auditor'] : ['operación', 'finanzas', 'general', 'admin']
	end


# ******************************************************************** DESPLIEGUE DE CAMPOS

	def s_moneda(moneda, valor)
		valor.blank? ? 'vacío' : moneda == 'Pesos' ? s_pesos(valor) : s_uf(valor)
	end

	def s_pesos(valor)
		valor.blank? ? 'vacío' : number_to_currency(valor, locale: :en, precision: cfg_defaults[:pesos])
	end

	def s_pesos2(valor)
		valor.blank? ? 'vacío' : number_to_currency(valor, locale: :en, precision: 2)
	end

	def s_uf(valor)
		valor.blank? ? 'vacío' : number_to_currency(valor, unit: 'UF', precision: cfg_defaults[:uf])
	end

	def s_uf5(valor)
		valor.blank? ? 'vacío' : number_to_currency(valor, unit: 'UF', precision: cfg_defaults[:uf_calculo])
	end

	def s_p100(valor, decimales)
		valor.blank? ? 'vacío' : number_to_currency(valor, unit: '%', precision: decimales)
	end

	def dma(date)
		date.blank? ? '__-__-__' : date.strftime("%d-%m-%Y")
	end

	def rprt_dma(date)
		date.blank? ? '-' : date.strftime("%d-%m-%Y")
	end

	def hm(datetime)
		datetime.blank? ? '__:__' : datetime.strftime("%I:%M%p")
	end

	def dma_hm(date)
		date.blank? ? '__-__-__ __:__' : date.strftime("%d-%m-%Y  %H:%M")
	end

	def hm(date)
		date.blank? ? '__:__' : date.strftime("%I:%M%p")
	end

	def s_mes(datetime)
		"#{datetime.year} #{nombre_mes[datetime.month]}"
	end

	def s_rut(rut)
		rut.blank? ? '__.___.___-_' : rut.gsub(' ', '').insert(-8, '.').insert(-5, '.').insert(-2, '-')
	end

end
