# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_24_191422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_administradores", force: :cascade do |t|
    t.string "administrador"
    t.string "email"
    t.integer "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_app_administradores_on_email"
    t.index ["usuario_id"], name: "index_app_administradores_on_usuario_id"
  end

  create_table "app_archivos", force: :cascade do |t|
    t.string "archivo"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_class"], name: "index_app_archivos_on_owner_class"
    t.index ["owner_id"], name: "index_app_archivos_on_owner_id"
  end

  create_table "app_contactos", force: :cascade do |t|
    t.string "nombre"
    t.string "telefono"
    t.string "email"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_class"], name: "index_app_contactos_on_owner_class"
    t.index ["owner_id"], name: "index_app_contactos_on_owner_id"
  end

  create_table "app_dir_dires", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_app_dir_dires_on_child_id"
    t.index ["parent_id"], name: "index_app_dir_dires_on_parent_id"
  end

  create_table "app_directorios", force: :cascade do |t|
    t.string "directorio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_class"
    t.integer "owner_id"
    t.index ["directorio"], name: "index_app_directorios_on_directorio"
    t.index ["owner_class"], name: "index_app_directorios_on_owner_class"
    t.index ["owner_id"], name: "index_app_directorios_on_owner_id"
  end

  create_table "app_documentos", force: :cascade do |t|
    t.string "documento"
    t.boolean "publico"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_class"
    t.integer "owner_id"
    t.index ["owner_class"], name: "index_app_documentos_on_owner_class"
    t.index ["owner_id"], name: "index_app_documentos_on_owner_id"
  end

  create_table "app_imagenes", force: :cascade do |t|
    t.string "nombre"
    t.string "imagen"
    t.string "credito_imagen"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_app_imagenes_on_nombre"
    t.index ["owner_class"], name: "index_app_imagenes_on_owner_class"
    t.index ["owner_id"], name: "index_app_imagenes_on_owner_id"
  end

  create_table "app_mejoras", force: :cascade do |t|
    t.text "detalle"
    t.string "estado"
    t.string "owner_class"
    t.integer "owner_id"
    t.integer "app_perfil_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_perfil_id"], name: "index_app_mejoras_on_app_perfil_id"
    t.index ["estado"], name: "index_app_mejoras_on_estado"
    t.index ["owner_class"], name: "index_app_mejoras_on_owner_class"
    t.index ["owner_id"], name: "index_app_mejoras_on_owner_id"
  end

  create_table "app_mensajes", force: :cascade do |t|
    t.string "mensaje"
    t.string "tipo"
    t.string "estado"
    t.string "email"
    t.datetime "fecha_envio"
    t.text "detalle"
    t.integer "app_perfil_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_perfil_id"], name: "index_app_mensajes_on_app_perfil_id"
    t.index ["email"], name: "index_app_mensajes_on_email"
    t.index ["estado"], name: "index_app_mensajes_on_estado"
    t.index ["fecha_envio"], name: "index_app_mensajes_on_fecha_envio"
    t.index ["tipo"], name: "index_app_mensajes_on_tipo"
  end

  create_table "app_msg_msgs", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_app_msg_msgs_on_child_id"
    t.index ["parent_id"], name: "index_app_msg_msgs_on_parent_id"
  end

  create_table "app_nominas", force: :cascade do |t|
    t.string "nombre"
    t.string "email"
    t.string "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_app_nominas_on_email"
  end

  create_table "app_observaciones", force: :cascade do |t|
    t.text "detalle"
    t.string "owner_class"
    t.integer "owner_id"
    t.integer "perfil_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_class"], name: "index_app_observaciones_on_owner_class"
    t.index ["owner_id"], name: "index_app_observaciones_on_owner_id"
    t.index ["perfil_id"], name: "index_app_observaciones_on_perfil_id"
  end

  create_table "app_perfiles", force: :cascade do |t|
    t.string "email"
    t.integer "usuario_id"
    t.integer "app_administrador_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_administrador_id"], name: "index_app_perfiles_on_app_administrador_id"
    t.index ["email"], name: "index_app_perfiles_on_email"
    t.index ["usuario_id"], name: "index_app_perfiles_on_usuario_id"
  end

  create_table "app_repos", force: :cascade do |t|
    t.string "repositorio"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_class"], name: "index_app_repos_on_owner_class"
    t.index ["owner_id"], name: "index_app_repos_on_owner_id"
    t.index ["repositorio"], name: "index_app_repos_on_repositorio"
  end

  create_table "causas", force: :cascade do |t|
    t.string "causa"
    t.string "identificador"
    t.string "cliente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "estado"
    t.integer "tar_tarifa_id"
    t.index ["estado"], name: "index_causas_on_estado"
    t.index ["tar_tarifa_id"], name: "index_causas_on_tar_tarifa_id"
  end

  create_table "clientes", force: :cascade do |t|
    t.string "razon_social"
    t.string "rut"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "estado"
    t.index ["estado"], name: "index_clientes_on_estado"
  end

  create_table "consultorias", force: :cascade do |t|
    t.string "consultoria"
    t.integer "cliente_id"
    t.string "estado"
    t.integer "tar_tarifa_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_consultorias_on_cliente_id"
    t.index ["tar_tarifa_id"], name: "index_consultorias_on_tar_tarifa_id"
  end

  create_table "h_imagenes", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_h_imagenes_on_nombre"
  end

  create_table "h_links", force: :cascade do |t|
    t.string "texto"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "h_temas", force: :cascade do |t|
    t.string "tema"
    t.string "detalle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tema"], name: "index_h_temas_on_tema"
  end

  create_table "hlp_pasos", force: :cascade do |t|
    t.integer "orden"
    t.string "paso"
    t.text "detalle"
    t.integer "hlp_tutorial_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hlp_tutorial_id"], name: "index_hlp_pasos_on_hlp_tutorial_id"
    t.index ["orden"], name: "index_hlp_pasos_on_orden"
  end

  create_table "hlp_tutoriales", force: :cascade do |t|
    t.string "tutorial"
    t.string "clave"
    t.text "detalle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clave"], name: "index_hlp_tutoriales_on_clave"
  end

  create_table "sb_elementos", force: :cascade do |t|
    t.integer "orden"
    t.integer "nivel"
    t.string "tipo"
    t.string "elemento"
    t.string "acceso"
    t.boolean "activo"
    t.string "despliegue"
    t.string "controlador"
    t.integer "sb_lista_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["orden"], name: "index_sb_elementos_on_orden"
    t.index ["sb_lista_id"], name: "index_sb_elementos_on_sb_lista_id"
  end

  create_table "sb_listas", force: :cascade do |t|
    t.string "lista"
    t.string "acceso"
    t.string "link"
    t.boolean "activa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "st_estados", force: :cascade do |t|
    t.integer "orden"
    t.string "st_estado"
    t.string "destinos"
    t.string "destinos_admin"
    t.integer "st_modelo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["orden"], name: "index_st_estados_on_orden"
    t.index ["st_estado"], name: "index_st_estados_on_st_estado"
    t.index ["st_modelo_id"], name: "index_st_estados_on_st_modelo_id"
  end

  create_table "st_logs", force: :cascade do |t|
    t.integer "perfil_id"
    t.string "class_name"
    t.integer "objeto_id"
    t.string "e_origen"
    t.string "e_destino"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["e_destino"], name: "index_st_logs_on_e_destino"
    t.index ["e_origen"], name: "index_st_logs_on_e_origen"
    t.index ["objeto_id"], name: "index_st_logs_on_objeto_id"
    t.index ["perfil_id"], name: "index_st_logs_on_perfil_id"
  end

  create_table "st_modelos", force: :cascade do |t|
    t.string "st_modelo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["st_modelo"], name: "index_st_modelos_on_st_modelo"
  end

  create_table "st_perfil_estados", force: :cascade do |t|
    t.string "st_perfil_estado"
    t.string "rol"
    t.integer "st_perfil_modelo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["st_perfil_modelo_id"], name: "index_st_perfil_estados_on_st_perfil_modelo_id"
  end

  create_table "st_perfil_modelos", force: :cascade do |t|
    t.string "st_perfil_modelo"
    t.string "rol"
    t.boolean "ingresa_registros"
    t.integer "app_nomina_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_nomina_id"], name: "index_st_perfil_modelos_on_app_nomina_id"
  end

  create_table "tar_convenios", force: :cascade do |t|
    t.datetime "fecha"
    t.decimal "monto"
    t.string "estado"
    t.integer "tar_factura_id"
    t.integer "tar_facturacion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estado"], name: "index_tar_convenios_on_estado"
    t.index ["fecha"], name: "index_tar_convenios_on_fecha"
    t.index ["tar_factura_id"], name: "index_tar_convenios_on_tar_factura_id"
    t.index ["tar_facturacion_id"], name: "index_tar_convenios_on_tar_facturacion_id"
  end

  create_table "tar_detalles", force: :cascade do |t|
    t.integer "orden"
    t.string "codigo"
    t.string "detalle"
    t.string "tipo"
    t.string "formula"
    t.integer "tar_tarifa_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "esconder"
    t.boolean "total"
    t.index ["codigo"], name: "index_tar_detalles_on_codigo"
    t.index ["orden"], name: "index_tar_detalles_on_orden"
    t.index ["tar_tarifa_id"], name: "index_tar_detalles_on_tar_tarifa_id"
  end

  create_table "tar_elementos", force: :cascade do |t|
    t.integer "orden"
    t.string "elemento"
    t.string "codigo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_tar_elementos_on_codigo"
    t.index ["orden"], name: "index_tar_elementos_on_orden"
  end

  create_table "tar_facturaciones", force: :cascade do |t|
    t.string "facturable"
    t.decimal "monto"
    t.string "estado"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "glosa"
    t.integer "tar_factura_id"
    t.index ["estado"], name: "index_tar_facturaciones_on_estado"
    t.index ["facturable"], name: "index_tar_facturaciones_on_facturable"
    t.index ["owner_class"], name: "index_tar_facturaciones_on_owner_class"
    t.index ["owner_id"], name: "index_tar_facturaciones_on_owner_id"
    t.index ["tar_factura_id"], name: "index_tar_facturaciones_on_tar_factura_id"
  end

  create_table "tar_facturas", force: :cascade do |t|
    t.string "owner_class"
    t.integer "owner_id"
    t.integer "documento"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "detalle_pago"
    t.index ["estado"], name: "index_tar_facturas_on_estado"
    t.index ["owner_class"], name: "index_tar_facturas_on_owner_class"
    t.index ["owner_id"], name: "index_tar_facturas_on_owner_id"
  end

  create_table "tar_servicios", force: :cascade do |t|
    t.string "codigo"
    t.string "descripcion"
    t.text "detalle"
    t.string "tipo"
    t.string "moneda"
    t.decimal "monto"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "estado"
    t.index ["codigo"], name: "index_tar_servicios_on_codigo"
    t.index ["estado"], name: "index_tar_servicios_on_estado"
    t.index ["owner_class"], name: "index_tar_servicios_on_owner_class"
    t.index ["owner_id"], name: "index_tar_servicios_on_owner_id"
    t.index ["tipo"], name: "index_tar_servicios_on_tipo"
  end

  create_table "tar_tarifas", force: :cascade do |t|
    t.string "tarifa"
    t.string "estado"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "facturables"
    t.index ["estado"], name: "index_tar_tarifas_on_estado"
    t.index ["facturables"], name: "index_tar_tarifas_on_facturables"
    t.index ["owner_class"], name: "index_tar_tarifas_on_owner_class"
    t.index ["owner_id"], name: "index_tar_tarifas_on_owner_id"
  end

  create_table "tar_valores", force: :cascade do |t|
    t.string "codigo"
    t.string "detalle"
    t.decimal "valor_uf"
    t.decimal "valor"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_tar_valores_on_codigo"
    t.index ["owner_class"], name: "index_tar_valores_on_owner_class"
    t.index ["owner_id"], name: "index_tar_valores_on_owner_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true
  end

end
