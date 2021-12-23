Rails.application.routes.draw do

  resources :consultorias do
    match :cambio_estado, via: :get, on: :member
  end
  resources :causas do
    match :cambio_estado, via: :get, on: :member
  end
  resources :clientes do
    match :cambio_estado, via: :get, on: :member
    match :crea_factura, via: :get, on: :member
  end
  scope module: 'aplicacion' do
    resources :app_administradores
    resources :app_nominas
    resources :app_perfiles do
      # recurso SOLO si hay manejo de ESTADOS
      resources :st_perfil_modelos
      match :desvincular, via: :get, on: :member
    end
    resources :app_observaciones
    resources :app_mejoras

    resources :app_recursos do
      collection do
        match :ayuda, via: :get
        match :home, via: :get
        match :administracion, via: :get
        match :procesos, via: :get
      end
    end

    resources :app_imagenes
    resources :app_contactos
    resources :app_mensajes do
      match :respuesta, via: :post, on: :collection
      match :estado, via: :get, on: :member
    end
    resources :app_msg_msgs

    resources :app_documentos
    resources :app_dir_dires
    resources :app_directorios do
      match :nuevo, via: :post, on: :collection
    end
    resources :app_repos do
      match :publico, via: :get, on: :collection
      match :perfil, via: :get, on: :collection
    end
    resources :app_archivos

    resources :app_enlaces
  end

  scope module: 'home' do
    resources :h_imagenes
    resources :h_links
    resources :h_temas
  end
  
  scope module: 'sidebar' do
    resources :sb_elementos
    resources :sb_listas do
      resources :sb_elementos
    end
  end

  scope module: 'help' do
    resources :hlp_pasos
    resources :hlp_tutoriales do
      resources :hlp_pasos
    end
  end

  scope module: 'estados' do
    resources :st_estados do
      match :asigna, via: :get, on: :member
    end
    resources :st_modelos do 
      resources :st_estados
      match :asigna, via: :get, on: :member
    end
    resources :st_perfil_estados do
      match :desasignar, via: :get, on: :member
      match :cambia_rol, via: :get, on: :member
    end
    resources :st_perfil_modelos do
      resources :st_perfil_estados
      match :desasignar, via: :get, on: :member
      match :cambia_rol, via: :get, on: :member
      match :cambia_ingreso, via: :get, on: :member
    end
    resources :st_bandejas
  end

  scope module: 'tarifas' do
    resources :tar_elementos
    resources :tar_tarifas do 
      resources :tar_detalles
      match :asigna, via: :get, on: :member
      match :desasigna, via: :get, on: :member
    end
    resources :tar_detalles
    resources :tar_valores
    resources :tar_facturaciones do
      match :crea_facturacion, via: :get, on: :collection
      match :elimina, via: :get, on: :member
      match :facturable, via: :get, on: :member
    end
    resources :tar_servicios

    resources :tar_convenios
    resources :tar_facturas do 
      match :set_documento, via: :post, on: :member
      match :elimina, via: :get, on: :member
      match :back_estado, via: :get, on: :member
      match :set_pago, via: :post, on: :member
      match :set_facturada, via: :get, on: :member
    end

    resources :tar_variables
    resources :tar_bases
    resources :tar_liquidaciones
  end

  devise_for :usuarios
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'aplicacion/app_recursos#home'

end
