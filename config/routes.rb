Rails.application.routes.draw do
  # Verificación de correos electrónicos de participantes
  # Nuevas rutas para la verificación

  get '/verify_custom_email', to: 'email_verifications#verify', as: :verify_custom_email
  post '/send_verification_email', to: 'email_verifications#send_verification', as: :send_verification_email

  resources :cuentas do
    match :dnncs, via: :get, on: :member
    match :invstgdrs, via: :get, on: :member
    match :extrns, via: :get, on: :member
    match :nmn, via: :get, on: :member
    match :ctp_mdds, via: :get, on: :member
    match :etp_mdds, via: :get, on: :member
  end
  resources :parrafos
  resources :notas do
    match :agrega_nota, via: :post, on: :collection
    match :swtch, via: :post, on: :member
    match :dssgn_usr, via: :post, on: :member
    match :assgn_usr, via: :post, on: :member
    match :swtch_clr, via: :post, on: :member
  end

#  get 'dwnldwrd' => 'causas/dwnldwrd', format: :docx

  resources :causas do
#    resources :temas
#    resources :hechos
    match :swtch, via: :post, on: :member
    match :cambio_estado, via: :get, on: :member
    match :procesa_registros, via: :get, on: :member
    match :cuantia_to_xlsx, via: :get, on: :member
    match :hchstowrd, via: :get, on: :member, format: 'docx'
    match :ntcdntstowrd, via: :get, on: :member, format: 'docx'
    match :asigna_tarifa, via: :post, on: :member
    match :chck_estds, via: :post, on: :member
    # ultima version
    match :add_uf_facturacion, via: :post, on: :member
    match :del_uf_facturacion, via: :get, on: :member
    match :rsltd, via: :post, on: :member
    match :estmcn, via: :post, on: :member
  end
  resources :clientes do
    match :cambio_estado, via: :get, on: :member
    match :swtch_pendiente, via: :post, on: :member
    match :swtch_urgencia, via: :post, on: :member
  end

  resources :empresas do
    match :swtch, via: :post, on: :member
    match :prg, via: :get, on: :member
  end

# SCOPES *********************************************************
  scope module: 'pdf' do
    resources :pdf_registros
    resources :pdf_archivos
  end
  scope module: 'rprts' do
    resources :krn_reportes do
      match :dnnc, via: :get, on: :collection
      match :drchs, via: :get, on: :collection
      match :infrmcn, via: :get, on: :collection
      match :invstgcn, via: :get, on: :collection
      match :invstgdr, via: :get, on: :collection
      match :dclrcn, via: :get, on: :collection
      match :drvcn, via: :get, on: :collection
      match :generate_and_send_report, via: :get, on: :collection
    end
  end

  scope module: 'producto' do
    resources :productos do
      match :agrega_producto, via: :get, on: :member
      match :elimina_producto, via: :get, on: :member
    end
    resources :pro_dtll_ventas
  end

  scope module: 'lgl' do
    resources :lgl_entidades
    resources :lgl_recursos
    resources :lgl_temas
    resources :lgl_citas do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :lgl_parrafos do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
      match :swtch, via: :post, on: :member
      match :padd, via: :get, on: :member
      match :chk_tgs, via: :get, on: :member
      match :prnt, via: :get, on: :member
    end
    resources :lgl_documentos
    resources :lgl_datos
    resources :lgl_parra_parras
    resources :lgl_puntos do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :lgl_tipo_entidades
    resources :lgl_tramo_empresas
  end 

  scope module: 'control' do
    resources :tipo_procedimientos
    resources :procedimientos
    resources :ctr_etapas do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :tareas do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
  end

  scope module: 'karin' do
    resources :respuestas do
      match :nueva, via: :post, on: :collection
    end
    resources :k_sesiones do 
      match :borrar_encuesta, via: :get, on: :member
    end
    resources :cuestionarios
    resources :preguntas
    resources :pautas
    resources :receptor_denuncias
    resources :motivo_denuncias

    resources :krn_empresa_externas
    resources :krn_denunciados do
      match :swtch, via: :post, on: :member
      match :set_fld, via: :post, on: :member
      match :clear_fld, via: :get, on: :member
    end
    resources :krn_denunciantes do
      match :swtch, via: :post, on: :member
      match :set_fld, via: :post, on: :member
      match :clear_fld, via: :get, on: :member
    end
    resources :krn_denuncias do
      match :swtch, via: :post, on: :member
      match :niler, via: :post, on: :member
      match :set_fld, via: :post, on: :member
      match :clear_fld, via: :get, on: :member
      match :prg, via: :post, on: :member
      # ruta para manejo de panels
      match :cndtnl_via_declaracion, via: :get, on: :collection
      match :tipo_declaracion_field, via: :get, on: :collection
    end

    resources :krn_derivaciones
    resources :krn_investigadores
    resources :krn_declaraciones do
      match :swtch, via: :post, on: :member
      match :migrar, via: :get, on: :member
    end
    resources :krn_testigos do
      match :swtch, via: :post, on: :member
      match :set_fld, via: :post, on: :member
      match :clear_fld, via: :get, on: :member
    end
    resources :krn_inv_denuncias do
      match :swtch, via: :post, on: :member
    end
  end

  scope module: 'srvcs' do
    resources :tipo_asesorias
    resources :asesorias do
      match :swtch, via: :post, on: :member
      match :set_tar_servicio, via: :post, on: :member
      match :generar_cobro, via: :get, on: :member
      match :elimina_cobro, via: :get, on: :member
      match :facturar, via: :get, on: :member
      match :liberar_factura, via: :get, on: :member
    end

    resources :tipo_cargos
    resources :cargos
  end

  # Usado para poner las entidades necesarias para mantener Causa
  scope module: 'csc' do
    resources :tipo_causas do
      resources :audiencias
      match :add_rcrd, via: :get, on: :member
    end
    resources :temas do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :hechos do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
      match :nuevo_archivo, via: :post, on: :member
      match :sel_archivo, via: :get, on: :member
      match :set_evaluacion, via: :get, on: :member
      match :nuevo_antecedente, via: :post, on: :member
    end
    resources :hecho_archivos do 
      match :eliminar, via: :get, on: :member
      match :set_establece, via: :get, on: :member
    end
    resources :audiencias do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :causa_archivos do 
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
      match :eliminar, via: :get, on: :member
      match :set_seleccionado, via: :get, on: :member
    end 
    # se reutlizó tabla para almacenar los antecedentes de un hecho
    resources :antecedentes do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    # Para almacenar los pedazos de Demanda de la Causa
    resources :secciones

    resources :demandantes
    resources :monto_conciliaciones
    resources :estados
    resources :tribunal_cortes
  end

  # Usado para poner las entidades necesarias para mantener Variables y su relación con causas y clientes
  scope module: 'dts' do
    resources :variables do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :valores do
      match :nuevo, via: :get, on: :collection
    end
    resources :var_tp_causas
    resources :var_clis
  end

  scope module: 'calendario' do
    resources :cal_feriados
  end
  scope module: 'actividades' do 
    resources :age_actividades do
      match :swtch, via: :post, on: :member
      match :dssgn_usr, via: :post, on: :member
      match :assgn_usr, via: :post, on: :member
      match :cambio_fecha, via: :post, on: :member
      # desde aqui revisar
      # -----------------------
      match :cu_actividad, via: :post, on: :collection
      match :cambia_estado, via: :get, on: :member
    end
    resources :age_pendientes do
      match :realizado_pendiente, via: :get, on: :member
      match :cambia_prioridad, via: :get, on: :member
    end
    resources :age_logs
    
    resources :age_usu_acts
    resources :age_usuarios do
      match :personaliza, via: :post, on: :member
      match :asigna_usuario, via: :get, on: :member
      match :desasigna_usuario, via: :get, on: :member
    end
    resources :age_usu_notas
  end
  scope module: 'autenticacion' do
    resources :app_nominas
    resources :app_perfiles
    resources :app_versiones
    resources :cfg_valores
  end

  scope module: 'recursos' do
    resources :app_contactos
    resources :app_enlaces
    resources :app_mensajes do
      match :respuesta, via: :post, on: :collection
      match :estado, via: :get, on: :member
    end
    resources :app_msg_msgs

    resources :regiones do
      resources :comunas
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :comunas
    resources :rcrs_logos
  end

  scope module: 'repositorios' do
    resources :app_directorios do
      match :nuevo, via: :post, on: :collection
    end
    resources :app_dir_dires
    resources :app_archivos
    resources :app_imagenes
    resources :app_escaneos do
      match :crea_escaneo, via: :get, on: :collection
    end
    resources :control_documentos do
      match :crea_documento_controlado, via: :get, on: :member
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :rep_doc_controlados do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :rep_archivos
  end

  scope module: 'aplicacion' do
    resources :publicos do
      match :home, via: :get, on: :collection
      match :home_prueba, via: :get, on: :collection
      match :encuesta, via: :get, on: :collection
      match :preguntas, via: :get, on: :collection
      match :ayuda, via: :get, on: :collection
    end
    resources :app_recursos do
      collection do
        match :ayuda, via: :get
        match :administracion, via: :get
        match :procesos, via: :get
        match :usuarios, via: :get
        match :password_recovery, via: :get
      end
    end
    resources :tablas do
      match :tribunal_corte, via: :get, on: :collection
      match :uf_regiones, via: :get, on: :collection
      match :enlaces, via: :get, on: :collection
      match :calendario, via: :get, on: :collection
      match :agenda, via: :get, on: :collection
      match :tipos, via: :get, on: :collection
      match :cuantias_tribunales, via: :get, on: :collection
      match :tarifas_generales, via: :get, on: :collection
      match :modelo, via: :get, on: :collection
      match :periodos_bancos, via: :get, on: :collection
    end
    resources :hlp_ayudas
  end

  scope module: 'organizacion' do
    resources :servicios do
      match :aprobacion, via: :get, on: :collection
      match :documentos, via: :get, on: :collection
      match :auditoria, via: :get, on: :collection
      match :adncs, via: :get, on: :collection
      match :antecedentes, via: :get, on: :collection
      match :organizacion, via: :get, on: :collection
      match :sucursales, via: :get, on: :collection
      match :empleados, via: :get, on: :collection
      match :multas, via: :get, on: :collection
    end
    resources :org_areas do
      match :nuevo_hijo, via: :post, on: :member
    end
    resources :org_area_areas
    resources :org_cargos
    resources :org_empleados

    resources :org_regiones do 
      resources :org_sucursales
    end
    resources :org_sucursales
  end
  
  scope module: 'st_estados' do
    resources :st_estados do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :st_modelos do 
      resources :st_estados
    end
    resources :st_bandejas
  end

  scope module: 'tarifas' do
    resources :tar_tarifas do 
      resources :tar_pagos
      resources :tar_formulas
    end
    resources :tar_tipo_variables
    resources :tar_pagos do
      resources :tar_comentarios
      resources :tar_cuotas
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :tar_formulas do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :tar_calculos do
      match :crea_calculo, via: :post, on: :collection
      match :elimina_calculo, via: :post, on: :member
      match :crea_pago_asesoria, via: :post, on: :collection
      match :elimina_pago_asesoria, via: :post, on: :collection
      # revisar desde aqui
      match :liberar_calculo, via: :get, on: :member
      match :crea_aprobacion, via: :get, on: :member
    end
    resources :tar_uf_facturaciones do 
      match :crea_uf_facturacion, via: :get, on: :collection
      match :elimina_uf_facturacion, via: :get, on: :member
    end
    resources :tar_detalle_cuantias do
      match :agrega_control_documento, via: :get, on: :member
      match :elimina_control_documento, via: :get, on: :member
    end
    resources :tar_valor_cuantias
    # REVISAR de aquí en adelante
    resources :tar_formula_cuantias
    resources :tar_uf_sistemas
    resources :tar_comentarios do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :tar_detalles
    resources :tar_facturaciones do
      match :facturable, via: :get, on: :member
      match :facturar, via: :get, on: :member
      # nueva lógica
      match :crea_aprobacion, via: :get, on: :member
      match :a_aprobacion, via: :get, on: :member
      match :libera_facturacion, via: :get, on: :member
    end
    resources :tar_servicios

    resources :tar_facturas do 
      resources :tar_facturaciones
      match :set_documento, via: :post, on: :member
      match :elimina, via: :get, on: :member
      match :back_estado, via: :get, on: :member
      match :set_pago, via: :post, on: :member
      match :set_facturada, via: :get, on: :member
      match :crea_factura, via: :get, on: :collection
      match :cambio_estado, via: :get, on: :member
      # nueva lógica
      match :libera_factura, via: :get, on: :member
      match :crea_nota_credito, via: :post, on: :member
      match :elimina_nota_credito, via: :get, on: :member
      match :a_facturada, via: :get, on: :member
    end
    resources :tar_nota_creditos

    resources :tar_aprobaciones
    resources :tar_cuotas

    # agregada para diferenciar porcentajes de tarifa según tipo de causa

    resources :reg_reportes do
      match :cambia_estado, via: :get, on: :member
    end
    resources :registros do
      match :reporta_registro, via: :get, on: :member
      match :excluye_registro, via: :get, on: :member
    end
  end

  scope module: 'modelos' do
    resources :modelos
    resources :m_modelos
    resources :m_periodos
    resources :m_conceptos do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :m_items do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end

    resources :m_bancos do
      resources :m_cuentas
      resources :m_formatos
    end
    resources :m_cuentas do
      resources :m_conciliaciones
      match :set_formato, via: :post, on: :member
    end
    resources :m_formatos do
      resources :m_elementos
      resources :m_datos
    end
    resources :m_elementos do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :m_datos do
      match :arriba, via: :post, on: :member
      match :abajo, via: :post, on: :member
    end
    resources :m_conciliaciones do
      match :conciliacion, via: :get, on: :member
    end
    resources :m_valores
    resources :m_registros do
      match :asigna, via: :get, on: :member
      match :asigna_factura, via: :post, on: :member
      match :libera_factura, via: :get, on: :member
    end
    resources :m_campos
    resources :m_movimientos

    # tabla de relación para resolver pagos
    resources :m_reg_facts
  end

  scope module: 'dt' do
    resources :dt_tabla_multas do
      resources :dt_multas
    end
    resources :dt_multas
    resources :dt_infracciones do
    end
    resources :dt_materias do
      resources :dt_infracciones
    end
    resources :dt_tramos
  end

#  devise_for :usuarios
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :usuarios, controllers: {
    confirmations: 'usuarios/confirmations',
    registrations: 'usuarios/registrations',
    sessions: 'usuarios/sessions'
  }

  root 'aplicacion/publicos#home'
  # manejo formulario de registro de empresas
  post '/register', to: 'empresas#create', as: 'register'
  get '/verify_email', to: 'empresas#verify', as: 'verify_email'
end
