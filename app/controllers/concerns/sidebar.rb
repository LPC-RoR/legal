module Sidebar
	extend ActiveSupport::Concern

	# SIDEBAR

	def get_lista(nombre)
		lista = SbLista.find_by(lista: nombre)
	end

	def get_elementos(lista)
		lista.blank? ? nil : lista.sb_elementos.order(:orden)
	end

	def first_elemento(elementos)
		unless elementos.blank?
			lista_item = elementos.where(tipo: 'item')
			(lista_item.blank? ? nil : lista_item.order(:orden).first)
		else
			nil
		end
	end

	def carga_sidebar_base(nombre, param_id)
	    @sb_name = nombre

	    @lista = get_lista(nombre)
	    @tipo_lista = (@lista.lista == 'Ayuda' ? 'ayuda' : 'item')

    	@sb_link = (@lista.blank? ? nil : @lista.link)
	    @sb_elementos = get_elementos(@lista)

	    unless ['new', 'edit', 'create', 'show', 'update'].include?(action_name)
	    	@id = get_id(@sb_elementos, param_id)
		    @elemento = SbElemento.find(@id)

	    	@controlador = get_controller(@sb_elementos, @id)
	    end
	end

	def get_id(elementos, param_id)
		if param_id.blank?
			first_elemento(elementos).blank? ? nil : first_elemento(elementos).id
		else
			param_id
		end
	end

	def get_controller(elementos, param_id)
		if param_id.blank?
			first_elemento(elementos).blank? ? nil : first_elemento(elementos).controlador
		else
			elementos.find(param_id).controlador
		end
	end

	def carga_sidebar(nombre, param_id)

		carga_sidebar_base(nombre, param_id)

	    unless ['new', 'edit', 'create', 'show', 'update'].include?(action_name)

		    if @elemento.despliegue == 'show'
	    		@objeto = @elemento.controlador.classify.constantize.first
		    elsif @elemento.despliegue == 'ayuda'
			    @objeto = HlpTutorial.find_by(clave: @elemento.controlador)
#			    @coleccion = {}
#			    @coleccion['hlp_pasos'] = @objeto.hlp_pasos.order(:orden) unless @objeto.blank?
			    init_tabla('hlp_pasos', @objeto.hlp_pasos.order(:orden), false) unless @objeto.blank?
		    elsif ['list', 'ulist'].include?(@elemento.despliegue)
#		    	@coleccion = {}

#				if @controlador.classify.constantize.all.count < 26 or @elemento.despliegue == 'ulist'
#					@coleccion[@elemento.controlador] = @elemento.controlador.classify.constantize.all.order(:created_at)
#					@paginate = false
#					init_tabla(@elemento.controlador, @elemento.controlador.classify.constantize.all.order(:created_at), false)
#				else
#					@coleccion[@elemento.controlador] = @elemento.controlador.classify.constantize.all.order(:created_at).page(params[:page])
#					@paginate = true
#					init_tabla(@elemento.controlador, @elemento.controlador.classify.constantize.all.order(:created_at).page(params[:page]), true)
#				end
				init_tabla(@elemento.controlador, @elemento.controlador.classify.constantize.all.order(:created_at), (not (@controlador.classify.constantize.all.count < 26 or @elemento.despliegue == 'ulist')))

		    end
		end
	end

	# ************************************************************************** SIDEBAR

	def carga_solo_sidebar
      carga_sidebar(nombre_sidebar(controller_name), nil)
    end

	def nombre_sidebar(controller)
		case controller
		when 'controlador'
			'Nombre Sidebar'
		else
			'Administración'
		end
	end

	def get_elemento_id(controlador, nombre_elemento)
		SbElemento.where(despliegue: 'list').where(controlador: controlador).find_by(elemento: nombre_elemento).id
	end
end
