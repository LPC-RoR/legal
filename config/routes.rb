Rails.application.routes.draw do

  resources :app_control_documentos
  resources :tribunal_cortes
  resources :juzgados
  resources :reg_reportes do
    match :cambia_estado, via: :get, on: :member
  end
  resources :registros do
    match :reporta_registro, via: :get, on: :member
    match :excluye_registro, via: :get, on: :member
  end
  resources :tipo_causas
  resources :consultorias do
    match :cambio_estado, via: :get, on: :member
    match :procesa_registros, via: :get, on: :member
  end
  resources :causas do
    resources :antecedentes
    match :cambio_estado, via: :get, on: :member
    match :procesa_registros, via: :get, on: :member
    match :actualiza_pago, via: :post, on: :member
    match :actualiza_antecedente, via: :post, on: :member
  end
  resources :antecedentes
  resources :clientes do
    match :cambio_estado, via: :get, on: :member
    match :crea_factura, via: :get, on: :member
    match :aprueba_factura, via: :get, on: :member
  end

# SCOPES *********************************************************
  scope module: 'autenticacion' do
    resources :app_administradores
    resources :app_nominas
    resources :app_perfiles do
      # recurso SOLO si hay manejo de ESTADOS
      resources :st_perfil_modelos
    end
  end

  scope module: 'recursos' do
    resources :app_contactos
    resources :app_enlaces
    resources :app_mejoras
    resources :app_mensajes do
      match :respuesta, via: :post, on: :collection
      match :estado, via: :get, on: :member
    end
    resources :app_msg_msgs
    resources :app_observaciones
  end

  scope module: 'repositorios' do
    resources :app_repositorios
    # DEPECATED : reemplazado por app_repositorios
    resources :app_repos do
      match :publico, via: :get, on: :collection
      match :perfil, via: :get, on: :collection
    end
    resources :app_directorios do
      match :nuevo, via: :post, on: :collection
    end
    resources :app_dir_dires
    resources :app_documentos
    resources :app_archivos
    resources :app_imagenes
    resources :app_escaneos do
      match :crea_escaneo, via: :get, on: :collection
    end
  end

  scope module: 'aplicacion' do
    resources :publicos do
      match :home, via: :get, on: :collection
    end
    resources :app_recursos do
      collection do
        match :ayuda, via: :get
        match :administracion, via: :get
        match :procesos, via: :get
        match :tablas, via: :get
      end
    end
    resources :servicios do
      match :aprobacion, via: :get, on: :collection
    end
  end

  scope module: 'home' do
    resources :h_imagenes
    resources :h_links
    resources :h_temas
  end
  
  scope module: 'sidebar' do
    resources :sb_elementos do
      match :arriba, via: :get, on: :member
      match :abajo, via: :get, on: :member
    end
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
      match :arriba, via: :get, on: :member
      match :abajo, via: :get, on: :member
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
    resources :tar_uf_facturaciones
    resources :tar_valor_cuantias
    resources :tar_detalle_cuantias
    resources :tar_uf_sistemas
    resources :tar_elementos
    resources :tar_tarifas do 
      resources :tar_pagos
      resources :tar_formulas
      resources :tar_detalles
      match :asigna, via: :get, on: :member
      match :desasigna, via: :get, on: :member
    end
    resources :tar_comentarios do
      match :arriba, via: :get, on: :member
      match :abajo, via: :get, on: :member
    end
    resources :tar_pagos do
      resources :tar_comentarios
      match :arriba, via: :get, on: :member
      match :abajo, via: :get, on: :member
    end
    resources :tar_formulas do
      match :arriba, via: :get, on: :member
      match :abajo, via: :get, on: :member
    end
    resources :tar_horas do
      match :asigna, via: :get, on: :member
      match :desasigna, via: :get, on: :member
    end
    resources :tar_detalles
    resources :tar_valores
    resources :tar_facturaciones do
      match :crea_facturacion, via: :get, on: :collection
      match :facturable, via: :get, on: :member
      match :facturar, via: :get, on: :member
      # nueva lógica
      match :elimina, via: :get, on: :member
      match :crea_aprobacion, via: :get, on: :member
      match :a_aprobacion, via: :get, on: :member
      match :a_pendiente, via: :get, on: :member
    end
    resources :tar_servicios

    resources :tar_convenios
    resources :tar_facturas do 
      resources :tar_facturaciones
      match :set_documento, via: :post, on: :member
      match :elimina, via: :get, on: :member
      match :back_estado, via: :get, on: :member
      match :set_pago, via: :post, on: :member
      match :set_facturada, via: :get, on: :member
      match :crea_factura, via: :get, on: :collection
      match :cambio_estado, via: :get, on: :member
    end

    resources :tar_aprobaciones do
      match :facturar, via: :get, on: :member
    end

    resources :tar_variables
    resources :tar_bases
    resources :tar_liquidaciones
  end

  scope module: 'modelos' do
    resources :m_modelos
    resources :m_periodos
    resources :m_conceptos do
      match :arriba, via: :get, on: :member
      match :abajo, via: :get, on: :member
    end
    resources :m_items do
      match :arriba, via: :get, on: :member
      match :abajo, via: :get, on: :member
    end

    resources :m_bancos do
      resources :m_cuentas
      resources :m_formatos
    end
    resources :m_cuentas do
      resources :m_conciliaciones
    end
    resources :m_formatos do
      resources :m_elementos
      resources :m_datos
    end
    resources :m_elementos do
      match :arriba, via: :get, on: :member
      match :abajo, via: :get, on: :member
    end
    resources :m_datos do
      match :arriba, via: :get, on: :member
      match :abajo, via: :get, on: :member
    end
    resources :m_conciliaciones do
      match :conciliacion, via: :get, on: :member
    end
    resources :m_valores
    resources :m_registros
    resources :m_campos
    resources :m_movimientos

  end

  scope module: 'blog' do
    resources :blg_articulos
    resources :blg_temas
    resources :blg_imagenes
  end

  scope module: 'dt' do
    resources :dt_multas
    resources :dt_infracciones
    resources :dt_materias
  end

  devise_for :usuarios
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'aplicacion/publicos#home'

end
