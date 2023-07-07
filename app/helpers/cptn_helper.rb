module CptnHelper

# ******************************************************************** CONSTANTES 

	# DEPRECATED
	# ctes[:image][:centrada]
#	def ctes
#		{
#			image: {
#				centrada: 'mx-auto d-block'
#			}
#		}
#	end

	# opcion elegida poor ser de escritura mas simple
	def image_sizes
		['entire', 'half', 'quarter', 'thumb']
	end

	def colors
		['primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark', 'muted', 'white']
	end

	def color(ref)
		if [:app, :navbar].include?(ref)
			config[:color][ref]
		elsif ['hlp_tutoriales', 'hlp_pasos'].include?(ref)
			config[:color][:help]
		else
			config[:color][:app]
		end
	end

	def table_types_base
		{
			simple: '',
			striped: 'table-striped',
			bordered: 'table-bordered',
			borderless: 'table-borderless',
			hover: 'table-hover',
			small: 'table-small'
		}
	end

# ******************************************************************** HELPERS DE USO GENERAL

	def nombre(objeto)
		objeto.send(objeto.class.name.tableize.singularize)
	end

	def perfiles_operativos
		AppNomina.all.map {|nomina| nomina.nombre}.union(AppAdministrador.all.map {|admin| admin.administrador unless admin.email == 'hugo.chinga.g@gmail.com'}.compact)
	end

	# Manejode options para selectors múltiples (VERSION PARA MULTI TABS SIN CAMBIOS)
	def get_html_opts(options, label, value)
		opts = options.clone
		opts[label] = value
		opts
	end

def controller_icon
		{
			'sb_listas' => 'list-nested',
			'app_empresas' => 'buildings',
			'app_administradores' => 'person-square',
			'app_nominas' => 'person-vcard',
			'app_repos' => 'archive',
			'app_directorios' => 'folder',
			'app_documentos' => 'journal',
			'app_escaneos' => 'images',
			'm_modelos' => 'piggy-bank',
			'm_bancos' => 'bank',
			'm_periodos' => 'calendar3',
			'causas' => 'file-text',
			'tar_facturas' => 'receipt',
			'tar_facturaciones' => 'coin',
			'clientes' => 'building',
#			'ld_parrafos' => 'blockquote-left'
		}
	end

# ******************************************************************** DESPLIEGUE DE CAMPOS

	def s_moneda(moneda, valor)
		moneda == 'Pesos' ? s_pesos(valor) : s_uf(valor)
	end

	def s_pesos(valor)
		number_to_currency(valor, locale: :en, precision: config[:decimales]['Pesos'])
	end

	def s_pesos2(valor)
		number_to_currency(valor, locale: :en, precision: 2)
	end

	def s_uf(valor)
		number_to_currency(valor, unit: 'UF', precision: config[:decimales]['UF'])
	end

	def dma(date)
		date.blank? ? '' : date.strftime("%d-%m-%Y")
	end

# ******************************************************************** HOME

	def foot?
		h_imagen = HImagen.find_by(nombre: 'Foot')
		h_imagen.blank? ? false : (h_imagen.imagenes.empty? ? false : h_imagen.imagenes.first.present?)
	end

end
