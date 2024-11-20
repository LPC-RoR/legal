# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_11_20_004923) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "age_act_perfiles", force: :cascade do |t|
    t.integer "app_perfil_id"
    t.integer "age_actividad_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["age_actividad_id"], name: "index_age_act_perfiles_on_age_actividad_id"
    t.index ["app_perfil_id"], name: "index_age_act_perfiles_on_app_perfil_id"
  end

  create_table "age_actividades", force: :cascade do |t|
    t.string "age_actividad"
    t.string "tipo"
    t.integer "app_perfil_id"
    t.string "estado"
    t.datetime "fecha", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "prioridad"
    t.boolean "privada"
    t.string "audiencia_especial"
    t.string "ownr_type"
    t.integer "ownr_id"
    t.index ["app_perfil_id"], name: "index_age_actividades_on_app_perfil_id"
    t.index ["estado"], name: "index_age_actividades_on_estado"
    t.index ["fecha"], name: "index_age_actividades_on_fecha"
    t.index ["ownr_id"], name: "index_age_actividades_on_ownr_id"
    t.index ["ownr_type"], name: "index_age_actividades_on_ownr_type"
    t.index ["privada"], name: "index_age_actividades_on_privada"
  end

  create_table "age_logs", force: :cascade do |t|
    t.datetime "fecha", precision: nil
    t.string "actividad"
    t.integer "age_actividad_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["age_actividad_id"], name: "index_age_logs_on_age_actividad_id"
  end

  create_table "age_pendientes", force: :cascade do |t|
    t.integer "age_usuario_id"
    t.string "age_pendiente"
    t.string "estado"
    t.string "prioridad"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["age_usuario_id"], name: "index_age_pendientes_on_age_usuario_id"
  end

  create_table "age_usu_acts", force: :cascade do |t|
    t.integer "age_usuario_id"
    t.integer "age_actividad_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["age_actividad_id"], name: "index_age_usu_acts_on_age_actividad_id"
    t.index ["age_usuario_id"], name: "index_age_usu_acts_on_age_usuario_id"
  end

  create_table "age_usu_notas", force: :cascade do |t|
    t.integer "age_usuario_id"
    t.integer "nota_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["age_usuario_id"], name: "index_age_usu_notas_on_age_usuario_id"
    t.index ["nota_id"], name: "index_age_usu_notas_on_nota_id"
  end

  create_table "age_usu_perfiles", force: :cascade do |t|
    t.integer "age_usuario_id"
    t.integer "app_perfil_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["age_usuario_id"], name: "index_age_usu_perfiles_on_age_usuario_id"
    t.index ["app_perfil_id"], name: "index_age_usu_perfiles_on_app_perfil_id"
  end

  create_table "age_usuarios", force: :cascade do |t|
    t.string "owner_class"
    t.integer "owner_id"
    t.string "age_usuario"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "app_perfil_id"
    t.index ["age_usuario"], name: "index_age_usuarios_on_age_usuario"
    t.index ["app_perfil_id"], name: "index_age_usuarios_on_app_perfil_id"
    t.index ["owner_class"], name: "index_age_usuarios_on_owner_class"
    t.index ["owner_id"], name: "index_age_usuarios_on_owner_id"
  end

  create_table "alcance_denuncias", force: :cascade do |t|
    t.string "alcance_denuncia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "antecedentes", force: :cascade do |t|
    t.string "hecho"
    t.string "riesgo"
    t.string "ventaja"
    t.text "cita"
    t.integer "orden"
    t.integer "causa_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "solicitud"
    t.integer "hecho_id"
    t.index ["causa_id"], name: "index_antecedentes_on_causa_id"
    t.index ["hecho_id"], name: "index_antecedentes_on_hecho_id"
    t.index ["orden"], name: "index_antecedentes_on_orden"
  end

  create_table "app_administradores", force: :cascade do |t|
    t.string "administrador"
    t.string "email"
    t.integer "usuario_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_app_administradores_on_email"
    t.index ["usuario_id"], name: "index_app_administradores_on_usuario_id"
  end

  create_table "app_archivos", force: :cascade do |t|
    t.string "archivo"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "app_archivo"
    t.boolean "documento_control"
    t.string "control"
    t.string "visible_para"
    t.integer "control_documento_id"
    t.index ["control"], name: "index_app_archivos_on_control"
    t.index ["control_documento_id"], name: "index_app_archivos_on_control_documento_id"
    t.index ["documento_control"], name: "index_app_archivos_on_documento_control"
    t.index ["owner_class"], name: "index_app_archivos_on_owner_class"
    t.index ["owner_id"], name: "index_app_archivos_on_owner_id"
    t.index ["visible_para"], name: "index_app_archivos_on_visible_para"
  end

  create_table "app_contactos", force: :cascade do |t|
    t.string "nombre"
    t.string "telefono"
    t.string "email"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["owner_class"], name: "index_app_contactos_on_owner_class"
    t.index ["owner_id"], name: "index_app_contactos_on_owner_id"
  end

  create_table "app_control_documentos", force: :cascade do |t|
    t.string "app_control_documento"
    t.string "existencia"
    t.string "vencimiento"
    t.string "ownr_class"
    t.integer "owner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["app_control_documento"], name: "index_app_control_documentos_on_app_control_documento"
    t.index ["existencia"], name: "index_app_control_documentos_on_existencia"
    t.index ["owner_id"], name: "index_app_control_documentos_on_owner_id"
    t.index ["ownr_class"], name: "index_app_control_documentos_on_ownr_class"
    t.index ["vencimiento"], name: "index_app_control_documentos_on_vencimiento"
  end

  create_table "app_dir_dires", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["child_id"], name: "index_app_dir_dires_on_child_id"
    t.index ["parent_id"], name: "index_app_dir_dires_on_parent_id"
  end

  create_table "app_directorios", force: :cascade do |t|
    t.string "directorio"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "owner_class"
    t.integer "owner_id"
    t.string "app_directorio"
    t.boolean "directorio_control"
    t.index ["app_directorio"], name: "index_app_directorios_on_app_directorio"
    t.index ["directorio"], name: "index_app_directorios_on_directorio"
    t.index ["owner_class"], name: "index_app_directorios_on_owner_class"
    t.index ["owner_id"], name: "index_app_directorios_on_owner_id"
  end

  create_table "app_documentos", force: :cascade do |t|
    t.string "documento"
    t.boolean "publico"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "owner_class"
    t.integer "owner_id"
    t.string "app_documento"
    t.string "existencia"
    t.string "vencimiento"
    t.boolean "documento_control"
    t.string "referencia"
    t.string "visible_para"
    t.index ["app_documento"], name: "index_app_documentos_on_app_documento"
    t.index ["owner_class"], name: "index_app_documentos_on_owner_class"
    t.index ["owner_id"], name: "index_app_documentos_on_owner_id"
    t.index ["visible_para"], name: "index_app_documentos_on_visible_para"
  end

  create_table "app_enlaces", force: :cascade do |t|
    t.string "descripcion"
    t.string "enlace"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["owner_class"], name: "index_app_enlaces_on_owner_class"
    t.index ["owner_id"], name: "index_app_enlaces_on_owner_id"
  end

  create_table "app_escaneos", force: :cascade do |t|
    t.string "ownr_class"
    t.integer "ownr_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ownr_class"], name: "index_app_escaneos_on_ownr_class"
    t.index ["ownr_id"], name: "index_app_escaneos_on_ownr_id"
  end

  create_table "app_imagenes", force: :cascade do |t|
    t.string "nombre"
    t.string "imagen"
    t.string "credito_imagen"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "fecha_envio", precision: nil
    t.text "detalle"
    t.integer "app_perfil_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["app_perfil_id"], name: "index_app_mensajes_on_app_perfil_id"
    t.index ["email"], name: "index_app_mensajes_on_email"
    t.index ["estado"], name: "index_app_mensajes_on_estado"
    t.index ["fecha_envio"], name: "index_app_mensajes_on_fecha_envio"
    t.index ["tipo"], name: "index_app_mensajes_on_tipo"
  end

  create_table "app_msg_msgs", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["child_id"], name: "index_app_msg_msgs_on_child_id"
    t.index ["parent_id"], name: "index_app_msg_msgs_on_parent_id"
  end

  create_table "app_nominas", force: :cascade do |t|
    t.string "nombre"
    t.string "email"
    t.string "tipo"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "ownr_type"
    t.integer "ownr_id"
    t.index ["email"], name: "index_app_nominas_on_email"
    t.index ["ownr_id"], name: "index_app_nominas_on_ownr_id"
    t.index ["ownr_type"], name: "index_app_nominas_on_ownr_type"
  end

  create_table "app_observaciones", force: :cascade do |t|
    t.text "detalle"
    t.string "owner_class"
    t.integer "owner_id"
    t.integer "perfil_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["owner_class"], name: "index_app_observaciones_on_owner_class"
    t.index ["owner_id"], name: "index_app_observaciones_on_owner_id"
    t.index ["perfil_id"], name: "index_app_observaciones_on_perfil_id"
  end

  create_table "app_perfiles", force: :cascade do |t|
    t.string "email"
    t.integer "usuario_id"
    t.integer "app_nomina_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["app_nomina_id"], name: "index_app_perfiles_on_app_nomina_id"
    t.index ["email"], name: "index_app_perfiles_on_email"
    t.index ["usuario_id"], name: "index_app_perfiles_on_usuario_id"
  end

  create_table "app_repos", force: :cascade do |t|
    t.string "repositorio"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["owner_class"], name: "index_app_repos_on_owner_class"
    t.index ["owner_id"], name: "index_app_repos_on_owner_id"
    t.index ["repositorio"], name: "index_app_repos_on_repositorio"
  end

  create_table "app_repositorios", force: :cascade do |t|
    t.string "app_repositorio"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["app_repositorio"], name: "index_app_repositorios_on_app_repositorio"
    t.index ["owner_class"], name: "index_app_repositorios_on_owner_class"
    t.index ["owner_id"], name: "index_app_repositorios_on_owner_id"
  end

  create_table "app_versiones", force: :cascade do |t|
    t.string "app_nombre"
    t.string "app_sigla"
    t.string "app_logo"
    t.string "app_banner"
    t.string "dog_email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "asesorias", force: :cascade do |t|
    t.integer "cliente_id"
    t.integer "tar_servicio_id"
    t.string "descripcion"
    t.text "detalle"
    t.datetime "fecha", precision: nil
    t.datetime "plazo", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "estado"
    t.datetime "fecha_uf", precision: nil
    t.string "moneda"
    t.decimal "monto"
    t.integer "tipo_asesoria_id"
    t.boolean "pendiente"
    t.boolean "urgente"
    t.index ["cliente_id"], name: "index_asesorias_on_cliente_id"
    t.index ["estado"], name: "index_asesorias_on_estado"
    t.index ["tar_servicio_id"], name: "index_asesorias_on_tar_servicio_id"
    t.index ["tipo_asesoria_id"], name: "index_asesorias_on_tipo_asesoria_id"
  end

  create_table "audiencias", force: :cascade do |t|
    t.integer "tipo_causa_id"
    t.string "audiencia"
    t.string "tipo"
    t.integer "orden"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["orden"], name: "index_audiencias_on_orden"
    t.index ["tipo_causa_id"], name: "index_audiencias_on_tipo_causa_id"
  end

  create_table "aut_tipo_usuarios", force: :cascade do |t|
    t.string "aut_tipo_usuario"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["aut_tipo_usuario"], name: "index_aut_tipo_usuarios_on_aut_tipo_usuario"
  end

  create_table "blg_articulos", force: :cascade do |t|
    t.string "blg_articulo"
    t.integer "app_perfil_id"
    t.integer "blg_tema_id"
    t.string "estado"
    t.text "articulo"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "imagen"
    t.text "descripcion"
    t.string "autor"
    t.index ["app_perfil_id"], name: "index_blg_articulos_on_app_perfil_id"
    t.index ["blg_tema_id"], name: "index_blg_articulos_on_blg_tema_id"
    t.index ["estado"], name: "index_blg_articulos_on_estado"
  end

  create_table "blg_imagenes", force: :cascade do |t|
    t.string "blg_imagen"
    t.string "imagen"
    t.string "blg_credito"
    t.string "ownr_class"
    t.integer "ownr_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["blg_imagen"], name: "index_blg_imagenes_on_blg_imagen"
    t.index ["ownr_class"], name: "index_blg_imagenes_on_ownr_class"
    t.index ["ownr_id"], name: "index_blg_imagenes_on_ownr_id"
  end

  create_table "blg_temas", force: :cascade do |t|
    t.string "blg_tema"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "imagen"
    t.text "descripcion"
  end

  create_table "cal_annios", force: :cascade do |t|
    t.integer "cal_annio"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cal_annio"], name: "index_cal_annios_on_cal_annio"
  end

  create_table "cal_dias", force: :cascade do |t|
    t.integer "cal_dia"
    t.integer "cal_mes_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "clave"
    t.string "dia_semana"
    t.integer "cal_semana_id"
    t.datetime "dt_fecha", precision: nil
    t.index ["cal_dia"], name: "index_cal_dias_on_cal_dia"
    t.index ["cal_mes_id"], name: "index_cal_dias_on_cal_mes_id"
    t.index ["cal_semana_id"], name: "index_cal_dias_on_cal_semana_id"
    t.index ["dia_semana"], name: "index_cal_dias_on_dia_semana"
    t.index ["dt_fecha"], name: "index_cal_dias_on_dt_fecha"
  end

  create_table "cal_feriados", force: :cascade do |t|
    t.integer "cal_annio_id"
    t.datetime "cal_fecha", precision: nil
    t.string "descripcion"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cal_annio_id"], name: "index_cal_feriados_on_cal_annio_id"
    t.index ["cal_fecha"], name: "index_cal_feriados_on_cal_fecha"
  end

  create_table "cal_mes_sems", force: :cascade do |t|
    t.integer "cal_mes_id"
    t.integer "cal_semana_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cal_mes_id"], name: "index_cal_mes_sems_on_cal_mes_id"
    t.index ["cal_semana_id"], name: "index_cal_mes_sems_on_cal_semana_id"
  end

  create_table "cal_meses", force: :cascade do |t|
    t.integer "cal_mes"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "cal_annio_id"
    t.string "clave"
    t.index ["cal_annio_id"], name: "index_cal_meses_on_cal_annio_id"
  end

  create_table "cal_semanas", force: :cascade do |t|
    t.integer "cal_semana"
    t.integer "cal_mes_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cal_mes_id"], name: "index_cal_semanas_on_cal_mes_id"
    t.index ["cal_semana"], name: "index_cal_semanas_on_cal_semana"
  end

  create_table "cargos", force: :cascade do |t|
    t.integer "tipo_cargo_id"
    t.integer "cliente_id"
    t.string "cargo"
    t.text "detalle"
    t.datetime "fecha", precision: nil
    t.datetime "fecha_uf", precision: nil
    t.string "moneda"
    t.integer "dia_cargo"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "estado"
    t.decimal "monto"
    t.index ["cliente_id"], name: "index_cargos_on_cliente_id"
    t.index ["estado"], name: "index_cargos_on_estado"
    t.index ["tipo_cargo_id"], name: "index_cargos_on_tipo_cargo_id"
  end

  create_table "causa_archivos", force: :cascade do |t|
    t.integer "causa_id"
    t.integer "app_archivo_id"
    t.integer "orden"
    t.boolean "seleccionado"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["app_archivo_id"], name: "index_causa_archivos_on_app_archivo_id"
    t.index ["causa_id"], name: "index_causa_archivos_on_causa_id"
    t.index ["orden"], name: "index_causa_archivos_on_orden"
    t.index ["seleccionado"], name: "index_causa_archivos_on_seleccionado"
  end

  create_table "causa_docs", force: :cascade do |t|
    t.integer "causa_id"
    t.integer "app_documento_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "orden"
    t.boolean "seleccionado"
    t.index ["app_documento_id"], name: "index_causa_docs_on_app_documento_id"
    t.index ["causa_id"], name: "index_causa_docs_on_causa_id"
    t.index ["orden"], name: "index_causa_docs_on_orden"
    t.index ["seleccionado"], name: "index_causa_docs_on_seleccionado"
  end

  create_table "causa_hechos", force: :cascade do |t|
    t.integer "causa_id"
    t.integer "hecho_id"
    t.integer "orden"
    t.string "st_contestación"
    t.string "st_preparatoria"
    t.string "st_juicio"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["causa_id"], name: "index_causa_hechos_on_causa_id"
    t.index ["hecho_id"], name: "index_causa_hechos_on_hecho_id"
    t.index ["orden"], name: "index_causa_hechos_on_orden"
  end

  create_table "causas", force: :cascade do |t|
    t.string "causa"
    t.string "identificador"
    t.string "cliente_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "estado"
    t.integer "tar_tarifa_id"
    t.string "tipo"
    t.integer "tipo_causa_id"
    t.integer "tar_hora_id"
    t.integer "juzgado_id"
    t.string "rol"
    t.integer "era"
    t.datetime "fecha_ingreso", precision: nil
    t.string "caratulado"
    t.string "ubicacion"
    t.datetime "fecha_ubicacion", precision: nil
    t.integer "tribunal_corte_id"
    t.string "rit"
    t.string "estado_causa"
    t.datetime "fecha_uf", precision: nil
    t.decimal "monto_pagado"
    t.string "demandante"
    t.string "abogados"
    t.string "cargo"
    t.string "sucursal"
    t.boolean "causa_ganada"
    t.boolean "hechos_registrados"
    t.boolean "archivos_registrados"
    t.boolean "pendiente"
    t.boolean "urgente"
    t.datetime "fecha_audiencia"
    t.string "audiencia"
    t.boolean "en_cobranza"
    t.index ["archivos_registrados"], name: "index_causas_on_archivos_registrados"
    t.index ["causa_ganada"], name: "index_causas_on_causa_ganada"
    t.index ["era"], name: "index_causas_on_era"
    t.index ["estado"], name: "index_causas_on_estado"
    t.index ["estado_causa"], name: "index_causas_on_estado_causa"
    t.index ["fecha_audiencia"], name: "index_causas_on_fecha_audiencia"
    t.index ["fecha_ingreso"], name: "index_causas_on_fecha_ingreso"
    t.index ["fecha_uf"], name: "index_causas_on_fecha_uf"
    t.index ["hechos_registrados"], name: "index_causas_on_hechos_registrados"
    t.index ["juzgado_id"], name: "index_causas_on_juzgado_id"
    t.index ["rol"], name: "index_causas_on_rol"
    t.index ["tar_hora_id"], name: "index_causas_on_tar_hora_id"
    t.index ["tar_tarifa_id"], name: "index_causas_on_tar_tarifa_id"
    t.index ["tipo"], name: "index_causas_on_tipo"
    t.index ["tipo_causa_id"], name: "index_causas_on_tipo_causa_id"
    t.index ["tribunal_corte_id"], name: "index_causas_on_tribunal_corte_id"
  end

  create_table "cfg_valores", force: :cascade do |t|
    t.string "cfg_valor"
    t.string "tipo"
    t.decimal "numero"
    t.string "palabra"
    t.text "texto"
    t.date "fecha"
    t.datetime "fecha_hora", precision: nil
    t.boolean "check_box"
    t.integer "app_version_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["app_version_id"], name: "index_cfg_valores_on_app_version_id"
    t.index ["cfg_valor"], name: "index_cfg_valores_on_cfg_valor"
    t.index ["tipo"], name: "index_cfg_valores_on_tipo"
  end

  create_table "clientes", force: :cascade do |t|
    t.string "razon_social"
    t.string "rut"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "estado"
    t.string "tipo_cliente"
    t.boolean "pendiente"
    t.boolean "urgente"
    t.boolean "preferente"
    t.index ["estado"], name: "index_clientes_on_estado"
    t.index ["tipo_cliente"], name: "index_clientes_on_tipo_cliente"
  end

  create_table "comunas", force: :cascade do |t|
    t.string "comuna"
    t.integer "region_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["region_id"], name: "index_comunas_on_region_id"
  end

  create_table "consultorias", force: :cascade do |t|
    t.string "consultoria"
    t.integer "cliente_id"
    t.string "estado"
    t.integer "tar_tarifa_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "tar_hora_id"
    t.index ["cliente_id"], name: "index_consultorias_on_cliente_id"
    t.index ["tar_hora_id"], name: "index_consultorias_on_tar_hora_id"
    t.index ["tar_tarifa_id"], name: "index_consultorias_on_tar_tarifa_id"
  end

  create_table "control_documentos", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.string "tipo"
    t.string "control"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "orden"
    t.string "visible_para"
    t.string "codigo"
    t.index ["codigo"], name: "index_control_documentos_on_codigo"
    t.index ["orden"], name: "index_control_documentos_on_orden"
    t.index ["owner_class"], name: "index_control_documentos_on_owner_class"
    t.index ["owner_id"], name: "index_control_documentos_on_owner_id"
    t.index ["visible_para"], name: "index_control_documentos_on_visible_para"
  end

  create_table "ctr_etapas", force: :cascade do |t|
    t.integer "procedimiento_id"
    t.string "codigo"
    t.string "ctr_etapa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "orden"
    t.index ["codigo"], name: "index_ctr_etapas_on_codigo"
    t.index ["orden"], name: "index_ctr_etapas_on_orden"
    t.index ["procedimiento_id"], name: "index_ctr_etapas_on_procedimiento_id"
  end

  create_table "cuestionarios", force: :cascade do |t|
    t.integer "orden"
    t.integer "pauta_id"
    t.string "cuestionario"
    t.string "referencia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["orden"], name: "index_cuestionarios_on_orden"
    t.index ["pauta_id"], name: "index_cuestionarios_on_pauta_id"
  end

  create_table "demandantes", force: :cascade do |t|
    t.integer "causa_id"
    t.integer "orden"
    t.string "nombres"
    t.string "apellidos"
    t.decimal "remuneracion"
    t.string "cargo"
    t.string "lugar_trabajo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["causa_id"], name: "index_demandantes_on_causa_id"
    t.index ["orden"], name: "index_demandantes_on_orden"
  end

  create_table "denunciados", force: :cascade do |t|
    t.integer "denuncia_id"
    t.integer "tipo_denunciado_id"
    t.string "empresa_denunciado"
    t.string "rut_empresa_denunciado"
    t.string "denunciado"
    t.string "vinculo"
    t.string "rut"
    t.string "cargo"
    t.string "lugar_trabajo"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["denuncia_id"], name: "index_denunciados_on_denuncia_id"
    t.index ["tipo_denunciado_id"], name: "index_denunciados_on_tipo_denunciado_id"
  end

  create_table "dependencia_denunciantes", force: :cascade do |t|
    t.string "dependencia_denunciante"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dt_criterio_multas", force: :cascade do |t|
    t.integer "dt_tabla_multa_id"
    t.integer "orden"
    t.decimal "monto"
    t.string "unidad"
    t.string "dt_criterio_multa"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["dt_tabla_multa_id"], name: "index_dt_criterio_multas_on_dt_tabla_multa_id"
    t.index ["orden"], name: "index_dt_criterio_multas_on_orden"
  end

  create_table "dt_infracciones", force: :cascade do |t|
    t.string "codigo"
    t.string "normas"
    t.string "dt_infraccion"
    t.text "tipificacion"
    t.string "criterios"
    t.integer "dt_materia_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "dt_tabla_multa_id"
    t.string "nota_multa"
    t.index ["dt_materia_id"], name: "index_dt_infracciones_on_dt_materia_id"
    t.index ["dt_tabla_multa_id"], name: "index_dt_infracciones_on_dt_tabla_multa_id"
  end

  create_table "dt_materias", force: :cascade do |t|
    t.string "dt_materia"
    t.integer "capitulo"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["capitulo"], name: "index_dt_materias_on_capitulo"
  end

  create_table "dt_multas", force: :cascade do |t|
    t.integer "orden"
    t.string "tamanio"
    t.decimal "leve"
    t.decimal "grave"
    t.decimal "gravisima"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "dt_infraccion_id"
    t.integer "dt_tabla_multa_id"
    t.integer "dt_tramo_id"
    t.index ["dt_infraccion_id"], name: "index_dt_multas_on_dt_infraccion_id"
    t.index ["dt_tabla_multa_id"], name: "index_dt_multas_on_dt_tabla_multa_id"
    t.index ["dt_tramo_id"], name: "index_dt_multas_on_dt_tramo_id"
    t.index ["orden"], name: "index_dt_multas_on_orden"
  end

  create_table "dt_tabla_multas", force: :cascade do |t|
    t.string "dt_tabla_multa"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "moneda"
    t.decimal "p100_leve"
    t.decimal "p100_grave"
    t.decimal "p100_gravisima"
    t.index ["dt_tabla_multa"], name: "index_dt_tabla_multas_on_dt_tabla_multa"
  end

  create_table "dt_tramos", force: :cascade do |t|
    t.string "dt_tramo"
    t.integer "orden"
    t.decimal "min"
    t.decimal "max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["orden"], name: "index_dt_tramos_on_orden"
  end

  create_table "empresas", force: :cascade do |t|
    t.string "rut"
    t.string "razon_social"
    t.string "email_administrador"
    t.string "email_verificado"
    t.string "sha1"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rut"], name: "index_empresas_on_rut"
    t.index ["sha1"], name: "index_empresas_on_sha1"
  end

  create_table "estados", force: :cascade do |t|
    t.integer "causa_id"
    t.string "link"
    t.text "estado"
    t.boolean "urgente"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "fecha"
    t.index ["causa_id"], name: "index_estados_on_causa_id"
    t.index ["fecha"], name: "index_estados_on_fecha"
  end

  create_table "h_imagenes", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["nombre"], name: "index_h_imagenes_on_nombre"
  end

  create_table "h_links", force: :cascade do |t|
    t.string "texto"
    t.string "link"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "h_preguntas", force: :cascade do |t|
    t.string "codigo"
    t.string "h_pregunta"
    t.text "respuesta"
    t.string "lnk_txt"
    t.string "lnk"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_h_preguntas_on_codigo"
  end

  create_table "h_temas", force: :cascade do |t|
    t.string "tema"
    t.string "detalle"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["tema"], name: "index_h_temas_on_tema"
  end

  create_table "h_textos", force: :cascade do |t|
    t.string "codigo"
    t.string "h_texto"
    t.text "texto"
    t.string "imagen"
    t.string "img_sz"
    t.string "lnk_txt"
    t.string "lnk"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_h_textos_on_codigo"
  end

  create_table "hecho_archivos", force: :cascade do |t|
    t.integer "hecho_id"
    t.integer "app_archivo_id"
    t.string "establece"
    t.integer "orden"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "aprobado_por"
    t.index ["app_archivo_id"], name: "index_hecho_archivos_on_app_archivo_id"
    t.index ["establece"], name: "index_hecho_archivos_on_establece"
    t.index ["hecho_id"], name: "index_hecho_archivos_on_hecho_id"
    t.index ["orden"], name: "index_hecho_archivos_on_orden"
  end

  create_table "hecho_docs", force: :cascade do |t|
    t.integer "hecho_id"
    t.integer "app_documento_id"
    t.string "establece"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "orden"
    t.index ["app_documento_id"], name: "index_hecho_docs_on_app_documento_id"
    t.index ["establece"], name: "index_hecho_docs_on_establece"
    t.index ["hecho_id"], name: "index_hecho_docs_on_hecho_id"
    t.index ["orden"], name: "index_hecho_docs_on_orden"
  end

  create_table "hechos", force: :cascade do |t|
    t.integer "tema_id"
    t.integer "orden"
    t.string "hecho"
    t.text "cita"
    t.string "archivo"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "documento"
    t.string "paginas"
    t.text "descripcion"
    t.integer "causa_id"
    t.string "st_contestacion"
    t.string "st_preparatoria"
    t.index ["causa_id"], name: "index_hechos_on_causa_id"
    t.index ["orden"], name: "index_hechos_on_orden"
    t.index ["st_contestacion"], name: "index_hechos_on_st_contestacion"
    t.index ["st_preparatoria"], name: "index_hechos_on_st_preparatoria"
    t.index ["tema_id"], name: "index_hechos_on_tema_id"
  end

  create_table "hlp_pasos", force: :cascade do |t|
    t.integer "orden"
    t.string "paso"
    t.text "detalle"
    t.integer "hlp_tutorial_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["hlp_tutorial_id"], name: "index_hlp_pasos_on_hlp_tutorial_id"
    t.index ["orden"], name: "index_hlp_pasos_on_orden"
  end

  create_table "hlp_tutoriales", force: :cascade do |t|
    t.string "tutorial"
    t.string "clave"
    t.text "detalle"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["clave"], name: "index_hlp_tutoriales_on_clave"
  end

  create_table "hm_links", force: :cascade do |t|
    t.integer "orden"
    t.integer "hm_parrafo_id"
    t.string "hm_link"
    t.string "texto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hm_parrafo_id"], name: "index_hm_links_on_hm_parrafo_id"
    t.index ["orden"], name: "index_hm_links_on_orden"
  end

  create_table "hm_notas", force: :cascade do |t|
    t.integer "hm_parrafo_id"
    t.integer "orden"
    t.string "hm_nota"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hm_parrafo_id"], name: "index_hm_notas_on_hm_parrafo_id"
    t.index ["orden"], name: "index_hm_notas_on_orden"
  end

  create_table "hm_paginas", force: :cascade do |t|
    t.string "codigo"
    t.string "hm_pagina"
    t.string "tooltip"
    t.boolean "menu_lft"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_hm_paginas_on_codigo"
  end

  create_table "hm_parrafos", force: :cascade do |t|
    t.integer "hm_pagina_id"
    t.integer "orden"
    t.text "hm_parrafo"
    t.string "tipo"
    t.string "imagen"
    t.string "img_lyt"
    t.boolean "menu_lft"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hm_pagina_id"], name: "index_hm_parrafos_on_hm_pagina_id"
    t.index ["orden"], name: "index_hm_parrafos_on_orden"
  end

  create_table "juzgados", force: :cascade do |t|
    t.string "juzgado"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "k_sesiones", force: :cascade do |t|
    t.datetime "fecha"
    t.string "sesion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "krn_declaraciones", force: :cascade do |t|
    t.integer "krn_denuncia_id"
    t.string "ownr_type"
    t.integer "ownr_id"
    t.datetime "fecha"
    t.string "archivo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "krn_investigador_id"
    t.index ["krn_denuncia_id"], name: "index_krn_declaraciones_on_krn_denuncia_id"
    t.index ["krn_investigador_id"], name: "index_krn_declaraciones_on_krn_investigador_id"
    t.index ["ownr_id"], name: "index_krn_declaraciones_on_ownr_id"
    t.index ["ownr_type"], name: "index_krn_declaraciones_on_ownr_type"
  end

  create_table "krn_denunciados", force: :cascade do |t|
    t.integer "krn_denuncia_id"
    t.integer "krn_empresa_externa_id"
    t.string "rut"
    t.string "nombre"
    t.string "cargo"
    t.string "lugar_trabajo"
    t.string "email"
    t.string "email_ok"
    t.boolean "articulo_4_1"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "krn_empleado_id"
    t.boolean "articulo_516"
    t.string "direccion_notificacion"
    t.boolean "empleado_externo"
    t.index ["krn_denuncia_id"], name: "index_krn_denunciados_on_krn_denuncia_id"
    t.index ["krn_empleado_id"], name: "index_krn_denunciados_on_krn_empleado_id"
    t.index ["krn_empresa_externa_id"], name: "index_krn_denunciados_on_krn_empresa_externa_id"
    t.index ["rut"], name: "index_krn_denunciados_on_rut"
  end

  create_table "krn_denunciantes", force: :cascade do |t|
    t.integer "krn_denuncia_id"
    t.integer "krn_empresa_externa_id"
    t.string "rut"
    t.string "nombre"
    t.string "cargo"
    t.string "lugar_trabajo"
    t.string "email"
    t.string "email_ok"
    t.boolean "articulo_4_1"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "articulo_516"
    t.string "direccion_notificacion"
    t.boolean "empleado_externo"
    t.index ["krn_denuncia_id"], name: "index_krn_denunciantes_on_krn_denuncia_id"
    t.index ["krn_empresa_externa_id"], name: "index_krn_denunciantes_on_krn_empresa_externa_id"
    t.index ["rut"], name: "index_krn_denunciantes_on_rut"
  end

  create_table "krn_denuncias", force: :cascade do |t|
    t.integer "krn_empresa_externa_id"
    t.datetime "fecha_hora"
    t.datetime "fecha_hora_dt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "presentado_por"
    t.string "via_declaracion"
    t.string "tipo_declaracion"
    t.string "representante"
    t.integer "krn_investigador_id"
    t.string "ownr_type"
    t.integer "ownr_id"
    t.string "receptor_denuncia"
    t.string "motivo_denuncia"
    t.datetime "fecha_hora_corregida"
    t.datetime "fecha_trmtcn"
    t.datetime "fecha_trmn"
    t.datetime "fecha_hora_ntfccn_invsgdr"
    t.datetime "fecha_env_infrm"
    t.datetime "fecha_prnncmnt"
    t.index ["fecha_hora"], name: "index_krn_denuncias_on_fecha_hora"
    t.index ["fecha_hora_dt"], name: "index_krn_denuncias_on_fecha_hora_dt"
    t.index ["krn_empresa_externa_id"], name: "index_krn_denuncias_on_krn_empresa_externa_id"
    t.index ["krn_investigador_id"], name: "index_krn_denuncias_on_krn_investigador_id"
    t.index ["motivo_denuncia"], name: "index_krn_denuncias_on_motivo_denuncia"
    t.index ["ownr_id"], name: "index_krn_denuncias_on_ownr_id"
    t.index ["ownr_type"], name: "index_krn_denuncias_on_ownr_type"
    t.index ["receptor_denuncia"], name: "index_krn_denuncias_on_receptor_denuncia"
  end

  create_table "krn_derivaciones", force: :cascade do |t|
    t.integer "krn_denuncia_id"
    t.datetime "fecha"
    t.integer "krn_empresa_externa_id"
    t.string "motivo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tipo"
    t.string "destino"
    t.string "origen"
    t.index ["destino"], name: "index_krn_derivaciones_on_destino"
    t.index ["fecha"], name: "index_krn_derivaciones_on_fecha"
    t.index ["krn_denuncia_id"], name: "index_krn_derivaciones_on_krn_denuncia_id"
    t.index ["krn_empresa_externa_id"], name: "index_krn_derivaciones_on_krn_empresa_externa_id"
    t.index ["origen"], name: "index_krn_derivaciones_on_origen"
    t.index ["tipo"], name: "index_krn_derivaciones_on_tipo"
  end

  create_table "krn_empresa_externas", force: :cascade do |t|
    t.string "rut"
    t.string "razon_social"
    t.string "tipo"
    t.string "contacto"
    t.string "email_contacto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ownr_type"
    t.integer "ownr_id"
    t.index ["ownr_id"], name: "index_krn_empresa_externas_on_ownr_id"
    t.index ["ownr_type"], name: "index_krn_empresa_externas_on_ownr_type"
    t.index ["rut"], name: "index_krn_empresa_externas_on_rut"
    t.index ["tipo"], name: "index_krn_empresa_externas_on_tipo"
  end

  create_table "krn_investigadores", force: :cascade do |t|
    t.string "krn_investigador"
    t.string "rut"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ownr_type"
    t.integer "ownr_id"
    t.index ["ownr_id"], name: "index_krn_investigadores_on_ownr_id"
    t.index ["ownr_type"], name: "index_krn_investigadores_on_ownr_type"
  end

  create_table "krn_motivo_derivaciones", force: :cascade do |t|
    t.string "krn_motivo_derivacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "krn_testigos", force: :cascade do |t|
    t.string "ownr_type"
    t.integer "ownr_id"
    t.integer "krn_empresa_externa_id"
    t.string "rut"
    t.string "nombre"
    t.string "cargo"
    t.string "lugar_trabajo"
    t.string "email"
    t.boolean "email_ok"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "articulo_4_1"
    t.boolean "articulo_516"
    t.string "direccion_notificacion"
    t.boolean "empleado_externo"
    t.index ["krn_empresa_externa_id"], name: "index_krn_testigos_on_krn_empresa_externa_id"
    t.index ["ownr_id"], name: "index_krn_testigos_on_ownr_id"
    t.index ["ownr_type"], name: "index_krn_testigos_on_ownr_type"
    t.index ["rut"], name: "index_krn_testigos_on_rut"
  end

  create_table "lgl_datos", force: :cascade do |t|
    t.integer "lgl_parrafo_id"
    t.integer "orden"
    t.string "lgl_dato"
    t.text "cita"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lgl_parrafo_id"], name: "index_lgl_datos_on_lgl_parrafo_id"
    t.index ["orden"], name: "index_lgl_datos_on_orden"
  end

  create_table "lgl_documentos", force: :cascade do |t|
    t.string "lgl_documento"
    t.string "tipo"
    t.string "archivo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tipo"], name: "index_lgl_documentos_on_tipo"
  end

  create_table "lgl_entidades", force: :cascade do |t|
    t.string "lgl_entidad"
    t.string "tipo"
    t.string "dependencia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lgl_tipo_entidad_id"
    t.index ["lgl_tipo_entidad_id"], name: "index_lgl_entidades_on_lgl_tipo_entidad_id"
    t.index ["tipo"], name: "index_lgl_entidades_on_tipo"
  end

  create_table "lgl_n_empleados", force: :cascade do |t|
    t.string "lgl_n_empleados"
    t.decimal "n_min"
    t.decimal "n_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lgl_parra_parras", force: :cascade do |t|
    t.integer "child_id"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_lgl_parra_parras_on_child_id"
    t.index ["parent_id"], name: "index_lgl_parra_parras_on_parent_id"
  end

  create_table "lgl_parrafos", force: :cascade do |t|
    t.integer "lgl_documento_id"
    t.integer "orden"
    t.text "lgl_parrafo"
    t.string "tipo"
    t.integer "pdd_lft"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "definicion"
    t.string "accion"
    t.string "resumen"
    t.boolean "ocultar"
    t.index ["lgl_documento_id"], name: "index_lgl_parrafos_on_lgl_documento_id"
    t.index ["orden"], name: "index_lgl_parrafos_on_orden"
    t.index ["tipo"], name: "index_lgl_parrafos_on_tipo"
  end

  create_table "lgl_puntos", force: :cascade do |t|
    t.integer "orden"
    t.integer "lgl_parrafo_id"
    t.string "lgl_punto"
    t.text "cita"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lgl_parrafo_id"], name: "index_lgl_puntos_on_lgl_parrafo_id"
    t.index ["orden"], name: "index_lgl_puntos_on_orden"
  end

  create_table "lgl_recursos", force: :cascade do |t|
    t.string "lgl_recurso"
    t.string "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tipo"], name: "index_lgl_recursos_on_tipo"
  end

  create_table "lgl_tipo_entidades", force: :cascade do |t|
    t.string "lgl_tipo_entidad"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lgl_tramo_empresas", force: :cascade do |t|
    t.integer "orden"
    t.string "lgl_tramo_empresa"
    t.decimal "min"
    t.decimal "max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["orden"], name: "index_lgl_tramo_empresas_on_orden"
  end

  create_table "m_bancos", force: :cascade do |t|
    t.string "m_banco"
    t.integer "m_modelo_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["m_banco"], name: "index_m_bancos_on_m_banco"
    t.index ["m_modelo_id"], name: "index_m_bancos_on_m_modelo_id"
  end

  create_table "m_campos", force: :cascade do |t|
    t.string "m_campo"
    t.string "valor"
    t.integer "m_conciliacion_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["m_campo"], name: "index_m_campos_on_m_campo"
    t.index ["m_conciliacion_id"], name: "index_m_campos_on_m_conciliacion_id"
  end

  create_table "m_conceptos", force: :cascade do |t|
    t.string "m_concepto"
    t.integer "m_modelo_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "orden"
    t.index ["m_concepto"], name: "index_m_conceptos_on_m_concepto"
    t.index ["m_modelo_id"], name: "index_m_conceptos_on_m_modelo_id"
    t.index ["orden"], name: "index_m_conceptos_on_orden"
  end

  create_table "m_conciliaciones", force: :cascade do |t|
    t.string "m_conciliacion"
    t.integer "m_cuenta_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["m_cuenta_id"], name: "index_m_conciliaciones_on_m_cuenta_id"
  end

  create_table "m_cuentas", force: :cascade do |t|
    t.string "m_cuenta"
    t.integer "m_banco_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "m_formato_id"
    t.integer "m_modelo_id"
    t.index ["m_banco_id"], name: "index_m_cuentas_on_m_banco_id"
    t.index ["m_formato_id"], name: "index_m_cuentas_on_m_formato_id"
    t.index ["m_modelo_id"], name: "index_m_cuentas_on_m_modelo_id"
  end

  create_table "m_datos", force: :cascade do |t|
    t.string "m_dato"
    t.string "tipo"
    t.string "formula"
    t.string "split_tag"
    t.integer "m_formato_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "orden"
    t.index ["m_dato"], name: "index_m_datos_on_m_dato"
    t.index ["m_formato_id"], name: "index_m_datos_on_m_formato_id"
    t.index ["orden"], name: "index_m_datos_on_orden"
    t.index ["tipo"], name: "index_m_datos_on_tipo"
  end

  create_table "m_elementos", force: :cascade do |t|
    t.integer "orden"
    t.string "m_elemento"
    t.string "tipo"
    t.integer "m_formato_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "registro"
    t.string "columna"
    t.index ["m_elemento"], name: "index_m_elementos_on_m_elemento"
    t.index ["m_formato_id"], name: "index_m_elementos_on_m_formato_id"
    t.index ["orden"], name: "index_m_elementos_on_orden"
    t.index ["tipo"], name: "index_m_elementos_on_tipo"
  end

  create_table "m_formatos", force: :cascade do |t|
    t.string "m_formato"
    t.integer "m_banco_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "inicio"
    t.string "termino"
    t.index ["m_banco_id"], name: "index_m_formatos_on_m_banco_id"
    t.index ["m_formato"], name: "index_m_formatos_on_m_formato"
  end

  create_table "m_items", force: :cascade do |t|
    t.integer "orden"
    t.string "m_item"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "m_concepto_id"
    t.decimal "presupuesto"
    t.string "abono_cargo"
    t.index ["abono_cargo"], name: "index_m_items_on_abono_cargo"
    t.index ["m_concepto_id"], name: "index_m_items_on_m_concepto_id"
    t.index ["m_item"], name: "index_m_items_on_m_item"
  end

  create_table "m_modelos", force: :cascade do |t|
    t.string "m_modelo"
    t.string "ownr_class"
    t.integer "ownr_id"
    t.index ["ownr_class"], name: "index_m_modelos_on_ownr_class"
    t.index ["ownr_id"], name: "index_m_modelos_on_ownr_id"
  end

  create_table "m_movimientos", force: :cascade do |t|
    t.datetime "fecha", precision: nil
    t.string "glosa"
    t.integer "m_item_id"
    t.decimal "monto"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["m_item_id"], name: "index_m_movimientos_on_m_item_id"
  end

  create_table "m_periodos", force: :cascade do |t|
    t.string "m_periodo"
    t.integer "clave"
    t.integer "m_modelo_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["clave"], name: "index_m_periodos_on_clave"
    t.index ["m_modelo_id"], name: "index_m_periodos_on_m_modelo_id"
  end

  create_table "m_reg_facts", force: :cascade do |t|
    t.integer "m_registro_id"
    t.integer "tar_factura_id"
    t.decimal "monto"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["m_registro_id"], name: "index_m_reg_facts_on_m_registro_id"
    t.index ["tar_factura_id"], name: "index_m_reg_facts_on_tar_factura_id"
  end

  create_table "m_registros", force: :cascade do |t|
    t.string "m_registro"
    t.integer "orden"
    t.integer "m_conciliacion_id"
    t.datetime "fecha", precision: nil
    t.string "glosa_banco"
    t.string "glosa"
    t.string "documento"
    t.decimal "monto"
    t.string "cargo_abono"
    t.decimal "saldo"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "m_periodo_id"
    t.integer "m_item_id"
    t.integer "m_modelo_id"
    t.index ["cargo_abono"], name: "index_m_registros_on_cargo_abono"
    t.index ["fecha"], name: "index_m_registros_on_fecha"
    t.index ["m_conciliacion_id"], name: "index_m_registros_on_m_conciliacion_id"
    t.index ["m_item_id"], name: "index_m_registros_on_m_item_id"
    t.index ["m_modelo_id"], name: "index_m_registros_on_m_modelo_id"
    t.index ["m_periodo_id"], name: "index_m_registros_on_m_periodo_id"
    t.index ["m_registro"], name: "index_m_registros_on_m_registro"
    t.index ["orden"], name: "index_m_registros_on_orden"
  end

  create_table "m_valores", force: :cascade do |t|
    t.integer "orden"
    t.string "m_valor"
    t.string "tipo"
    t.string "valor"
    t.integer "m_conciliacion_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["m_conciliacion_id"], name: "index_m_valores_on_m_conciliacion_id"
    t.index ["orden"], name: "index_m_valores_on_orden"
  end

  create_table "monto_conciliaciones", force: :cascade do |t|
    t.integer "causa_id"
    t.string "tipo"
    t.datetime "fecha"
    t.decimal "monto"
    t.string "nota"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["causa_id"], name: "index_monto_conciliaciones_on_causa_id"
  end

  create_table "notas", force: :cascade do |t|
    t.string "ownr_clss"
    t.integer "ownr_id"
    t.integer "perfil_id"
    t.string "nota"
    t.string "prioridad"
    t.boolean "realizado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pendiente"
    t.boolean "urgente"
    t.datetime "fecha_gestion"
    t.boolean "sin_fecha_gestion"
    t.index ["ownr_clss"], name: "index_notas_on_ownr_clss"
    t.index ["ownr_id"], name: "index_notas_on_ownr_id"
    t.index ["perfil_id"], name: "index_notas_on_perfil_id"
  end

  create_table "org_area_areas", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["child_id"], name: "index_org_area_areas_on_child_id"
    t.index ["parent_id"], name: "index_org_area_areas_on_parent_id"
  end

  create_table "org_areas", force: :cascade do |t|
    t.string "org_area"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "cliente_id"
    t.index ["cliente_id"], name: "index_org_areas_on_cliente_id"
  end

  create_table "org_cargos", force: :cascade do |t|
    t.string "org_cargo"
    t.integer "dotacion"
    t.integer "org_area_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["org_area_id"], name: "index_org_cargos_on_org_area_id"
  end

  create_table "org_empleados", force: :cascade do |t|
    t.string "rut"
    t.string "nombres"
    t.string "apellido_paterno"
    t.string "apellido_materno"
    t.integer "org_cargo_id"
    t.datetime "fecha_nacimiento", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "org_sucursal_id"
    t.index ["org_cargo_id"], name: "index_org_empleados_on_org_cargo_id"
    t.index ["org_sucursal_id"], name: "index_org_empleados_on_org_sucursal_id"
  end

  create_table "org_regiones", force: :cascade do |t|
    t.string "org_region"
    t.integer "cliente_id"
    t.integer "region_id"
    t.integer "orden"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cliente_id"], name: "index_org_regiones_on_cliente_id"
    t.index ["orden"], name: "index_org_regiones_on_orden"
    t.index ["org_region"], name: "index_org_regiones_on_org_region"
    t.index ["region_id"], name: "index_org_regiones_on_region_id"
  end

  create_table "org_sucursales", force: :cascade do |t|
    t.string "org_sucursal"
    t.string "direccion"
    t.integer "org_region_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["org_region_id"], name: "index_org_sucursales_on_org_region_id"
    t.index ["org_sucursal"], name: "index_org_sucursales_on_org_sucursal"
  end

  create_table "parrafos", force: :cascade do |t|
    t.integer "causa_id"
    t.integer "seccion_id"
    t.integer "orden"
    t.text "texto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "oculto"
    t.index ["causa_id"], name: "index_parrafos_on_causa_id"
    t.index ["orden"], name: "index_parrafos_on_orden"
    t.index ["seccion_id"], name: "index_parrafos_on_seccion_id"
  end

  create_table "pautas", force: :cascade do |t|
    t.integer "orden"
    t.string "pauta"
    t.string "referencia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["orden"], name: "index_pautas_on_orden"
  end

  create_table "preguntas", force: :cascade do |t|
    t.integer "orden"
    t.integer "cuestionario_id"
    t.string "pregunta"
    t.string "tipo"
    t.string "referencia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cuestionario_id"], name: "index_preguntas_on_cuestionario_id"
    t.index ["orden"], name: "index_preguntas_on_orden"
  end

  create_table "pro_dtll_ventas", force: :cascade do |t|
    t.string "ownr_type"
    t.integer "ownr_id"
    t.integer "producto_id"
    t.datetime "fecha_activacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ownr_id"], name: "index_pro_dtll_ventas_on_ownr_id"
    t.index ["ownr_type"], name: "index_pro_dtll_ventas_on_ownr_type"
    t.index ["producto_id"], name: "index_pro_dtll_ventas_on_producto_id"
  end

  create_table "procedimientos", force: :cascade do |t|
    t.string "procedimiento"
    t.integer "tipo_procedimiento_id"
    t.text "detalle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "codigo"
    t.index ["codigo"], name: "index_procedimientos_on_codigo"
    t.index ["tipo_procedimiento_id"], name: "index_procedimientos_on_tipo_procedimiento_id"
  end

  create_table "productos", force: :cascade do |t|
    t.string "producto"
    t.string "codigo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tipo"
    t.integer "procedimiento_id"
    t.string "formato"
    t.boolean "prepago"
    t.integer "capacidad"
    t.string "moneda"
    t.decimal "precio"
    t.index ["codigo"], name: "index_productos_on_codigo"
    t.index ["procedimiento_id"], name: "index_productos_on_procedimiento_id"
    t.index ["tipo"], name: "index_productos_on_tipo"
  end

  create_table "reg_reportes", force: :cascade do |t|
    t.string "clave"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "annio"
    t.integer "mes"
    t.integer "cliente_id"
    t.string "owner_class"
    t.integer "owner_id"
    t.string "estado"
    t.index ["annio"], name: "index_reg_reportes_on_annio"
    t.index ["clave"], name: "index_reg_reportes_on_clave"
    t.index ["cliente_id"], name: "index_reg_reportes_on_cliente_id"
    t.index ["estado"], name: "index_reg_reportes_on_estado"
    t.index ["mes"], name: "index_reg_reportes_on_mes"
    t.index ["owner_class"], name: "index_reg_reportes_on_owner_class"
    t.index ["owner_id"], name: "index_reg_reportes_on_owner_id"
  end

  create_table "regiones", force: :cascade do |t|
    t.string "region"
    t.integer "orden"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["orden"], name: "index_regiones_on_orden"
  end

  create_table "registros", force: :cascade do |t|
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "fecha", precision: nil
    t.string "tipo"
    t.string "detalle"
    t.text "nota"
    t.time "duracion"
    t.time "descuento"
    t.string "razon_descuento"
    t.string "estado"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "reporte_id"
    t.integer "RegReporteId"
    t.integer "annio"
    t.integer "mes"
    t.integer "reg_reporte_id"
    t.integer "horas"
    t.integer "minutos"
    t.string "abogado"
    t.index ["RegReporteId"], name: "index_registros_on_RegReporteId"
    t.index ["annio"], name: "index_registros_on_annio"
    t.index ["estado"], name: "index_registros_on_estado"
    t.index ["fecha"], name: "index_registros_on_fecha"
    t.index ["mes"], name: "index_registros_on_mes"
    t.index ["owner_class"], name: "index_registros_on_owner_class"
    t.index ["owner_id"], name: "index_registros_on_owner_id"
    t.index ["reg_reporte_id"], name: "index_registros_on_reg_reporte_id"
    t.index ["reporte_id"], name: "index_registros_on_reporte_id"
    t.index ["tipo"], name: "index_registros_on_tipo"
  end

  create_table "rep_archivos", force: :cascade do |t|
    t.string "ownr_type", null: false
    t.bigint "ownr_id", null: false
    t.string "rep_archivo"
    t.string "archivo"
    t.integer "rep_doc_controlado_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nombre"
    t.index ["ownr_type", "ownr_id"], name: "index_rep_archivos_on_ownr"
    t.index ["rep_archivo"], name: "index_rep_archivos_on_rep_archivo"
    t.index ["rep_doc_controlado_id"], name: "index_rep_archivos_on_rep_doc_controlado_id"
  end

  create_table "rep_doc_controlados", force: :cascade do |t|
    t.string "ownr_type", null: false
    t.bigint "ownr_id", null: false
    t.string "rep_doc_controlado"
    t.string "archivo"
    t.string "tipo"
    t.string "control"
    t.integer "orden"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "codigo"
    t.string "descripcion"
    t.boolean "multiple"
    t.index ["codigo"], name: "index_rep_doc_controlados_on_codigo"
    t.index ["orden"], name: "index_rep_doc_controlados_on_orden"
    t.index ["ownr_type", "ownr_id"], name: "index_rep_doc_controlados_on_ownr"
    t.index ["rep_doc_controlado"], name: "index_rep_doc_controlados_on_rep_doc_controlado"
    t.index ["tipo"], name: "index_rep_doc_controlados_on_tipo"
  end

  create_table "respuestas", force: :cascade do |t|
    t.integer "campania_id"
    t.integer "k_sesion_id"
    t.string "respuesta"
    t.string "propuesta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pregunta_id"
    t.index ["campania_id"], name: "index_respuestas_on_campania_id"
    t.index ["k_sesion_id"], name: "index_respuestas_on_k_sesion_id"
    t.index ["pregunta_id"], name: "index_respuestas_on_pregunta_id"
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["orden"], name: "index_sb_elementos_on_orden"
    t.index ["sb_lista_id"], name: "index_sb_elementos_on_sb_lista_id"
  end

  create_table "sb_listas", force: :cascade do |t|
    t.string "lista"
    t.string "acceso"
    t.string "link"
    t.boolean "activa"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "secciones", force: :cascade do |t|
    t.integer "causa_id"
    t.integer "orden"
    t.string "seccion"
    t.text "texto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["causa_id"], name: "index_secciones_on_causa_id"
    t.index ["orden"], name: "index_secciones_on_orden"
  end

  create_table "st_estados", force: :cascade do |t|
    t.integer "orden"
    t.string "st_estado"
    t.string "destinos"
    t.string "destinos_admin"
    t.integer "st_modelo_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "aprobacion"
    t.string "check"
    t.index ["check"], name: "index_st_estados_on_check"
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["e_destino"], name: "index_st_logs_on_e_destino"
    t.index ["e_origen"], name: "index_st_logs_on_e_origen"
    t.index ["objeto_id"], name: "index_st_logs_on_objeto_id"
    t.index ["perfil_id"], name: "index_st_logs_on_perfil_id"
  end

  create_table "st_modelos", force: :cascade do |t|
    t.string "st_modelo"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "bandeja"
    t.string "crud"
    t.string "k_estados"
    t.index ["bandeja"], name: "index_st_modelos_on_bandeja"
    t.index ["crud"], name: "index_st_modelos_on_crud"
    t.index ["st_modelo"], name: "index_st_modelos_on_st_modelo"
  end

  create_table "st_perfil_estados", force: :cascade do |t|
    t.string "st_perfil_estado"
    t.string "rol"
    t.integer "st_perfil_modelo_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "orden"
    t.index ["orden"], name: "index_st_perfil_estados_on_orden"
    t.index ["st_perfil_modelo_id"], name: "index_st_perfil_estados_on_st_perfil_modelo_id"
  end

  create_table "st_perfil_modelos", force: :cascade do |t|
    t.string "st_perfil_modelo"
    t.string "rol"
    t.boolean "ingresa_registros"
    t.integer "app_nomina_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["app_nomina_id"], name: "index_st_perfil_modelos_on_app_nomina_id"
  end

  create_table "tar_aprobaciones", force: :cascade do |t|
    t.integer "cliente_id"
    t.datetime "fecha", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cliente_id"], name: "index_tar_aprobaciones_on_cliente_id"
    t.index ["fecha"], name: "index_tar_aprobaciones_on_fecha"
  end

  create_table "tar_bases", force: :cascade do |t|
    t.string "base"
    t.decimal "monto_uf"
    t.decimal "monto"
    t.string "owner_class"
    t.integer "owner_id"
    t.integer "perfil_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["owner_class"], name: "index_tar_bases_on_owner_class"
    t.index ["owner_id"], name: "index_tar_bases_on_owner_id"
    t.index ["perfil_id"], name: "index_tar_bases_on_perfil_id"
  end

  create_table "tar_calculos", force: :cascade do |t|
    t.integer "ownr_id"
    t.integer "tar_pago_id"
    t.string "moneda"
    t.decimal "monto"
    t.string "glosa"
    t.decimal "cuantia"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "fecha_uf", precision: nil
    t.integer "tar_aprobacion_id"
    t.integer "cliente_id"
    t.string "ownr_type"
    t.index ["cliente_id"], name: "index_tar_calculos_on_cliente_id"
    t.index ["ownr_id"], name: "index_tar_calculos_on_ownr_id"
    t.index ["ownr_type"], name: "index_tar_calculos_on_ownr_type"
    t.index ["tar_aprobacion_id"], name: "index_tar_calculos_on_tar_aprobacion_id"
    t.index ["tar_pago_id"], name: "index_tar_calculos_on_tar_pago_id"
  end

  create_table "tar_comentarios", force: :cascade do |t|
    t.integer "tar_pago_id"
    t.integer "orden"
    t.string "tipo"
    t.string "formula"
    t.text "comentario"
    t.text "opcional"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "despliegue"
    t.string "moneda"
    t.index ["tar_pago_id"], name: "index_tar_comentarios_on_tar_pago_id"
  end

  create_table "tar_convenios", force: :cascade do |t|
    t.datetime "fecha", precision: nil
    t.decimal "monto"
    t.string "estado"
    t.integer "tar_factura_id"
    t.integer "tar_facturacion_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["estado"], name: "index_tar_convenios_on_estado"
    t.index ["fecha"], name: "index_tar_convenios_on_fecha"
    t.index ["tar_factura_id"], name: "index_tar_convenios_on_tar_factura_id"
    t.index ["tar_facturacion_id"], name: "index_tar_convenios_on_tar_facturacion_id"
  end

  create_table "tar_cuotas", force: :cascade do |t|
    t.integer "tar_pago_id"
    t.integer "orden"
    t.string "tar_cuota"
    t.string "moneda"
    t.decimal "monto"
    t.decimal "porcentaje"
    t.boolean "ultima_cuota"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["orden"], name: "index_tar_cuotas_on_orden"
    t.index ["tar_pago_id"], name: "index_tar_cuotas_on_tar_pago_id"
  end

  create_table "tar_det_cuantia_controles", force: :cascade do |t|
    t.integer "tar_detalle_cuantia_id"
    t.integer "control_documento_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["control_documento_id"], name: "index_tar_det_cuantia_controles_on_control_documento_id"
    t.index ["tar_detalle_cuantia_id"], name: "index_tar_det_cuantia_controles_on_tar_detalle_cuantia_id"
  end

  create_table "tar_detalle_cuantias", force: :cascade do |t|
    t.string "tar_detalle_cuantia"
    t.string "descripcion"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "formula_cuantia"
    t.string "formula_honorarios"
    t.index ["tar_detalle_cuantia"], name: "index_tar_detalle_cuantias_on_tar_detalle_cuantia"
  end

  create_table "tar_detalles", force: :cascade do |t|
    t.integer "orden"
    t.string "codigo"
    t.string "detalle"
    t.string "tipo"
    t.string "formula"
    t.integer "tar_tarifa_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["codigo"], name: "index_tar_elementos_on_codigo"
    t.index ["orden"], name: "index_tar_elementos_on_orden"
  end

  create_table "tar_facturaciones", force: :cascade do |t|
    t.string "facturable"
    t.decimal "monto"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "glosa"
    t.integer "tar_factura_id"
    t.string "moneda"
    t.integer "tar_aprobacion_id"
    t.integer "tar_pago_id"
    t.decimal "cuantia_calculo"
    t.integer "tar_cuota_id"
    t.integer "tar_calculo_id"
    t.datetime "fecha_uf", precision: nil
    t.string "ownr_type"
    t.integer "ownr_id"
    t.index ["facturable"], name: "index_tar_facturaciones_on_facturable"
    t.index ["moneda"], name: "index_tar_facturaciones_on_moneda"
    t.index ["ownr_id"], name: "index_tar_facturaciones_on_ownr_id"
    t.index ["ownr_type"], name: "index_tar_facturaciones_on_ownr_type"
    t.index ["tar_aprobacion_id"], name: "index_tar_facturaciones_on_tar_aprobacion_id"
    t.index ["tar_calculo_id"], name: "index_tar_facturaciones_on_tar_calculo_id"
    t.index ["tar_cuota_id"], name: "index_tar_facturaciones_on_tar_cuota_id"
    t.index ["tar_factura_id"], name: "index_tar_facturaciones_on_tar_factura_id"
    t.index ["tar_pago_id"], name: "index_tar_facturaciones_on_tar_pago_id"
  end

  create_table "tar_facturas", force: :cascade do |t|
    t.string "owner_class"
    t.integer "owner_id"
    t.integer "documento"
    t.string "estado"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "detalle_pago"
    t.datetime "fecha_uf", precision: nil
    t.decimal "uf_factura"
    t.string "concepto"
    t.datetime "fecha_pago", precision: nil
    t.datetime "fecha_factura", precision: nil
    t.integer "clave"
    t.integer "m_registro_id"
    t.index ["clave"], name: "index_tar_facturas_on_clave"
    t.index ["estado"], name: "index_tar_facturas_on_estado"
    t.index ["fecha_pago"], name: "index_tar_facturas_on_fecha_pago"
    t.index ["m_registro_id"], name: "index_tar_facturas_on_m_registro_id"
    t.index ["owner_class"], name: "index_tar_facturas_on_owner_class"
    t.index ["owner_id"], name: "index_tar_facturas_on_owner_id"
  end

  create_table "tar_formula_cuantias", force: :cascade do |t|
    t.integer "tar_tarifa_id"
    t.integer "tar_detalle_cuantia_id"
    t.string "tar_formula_cuantia"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.decimal "porcentaje_base"
    t.index ["tar_detalle_cuantia_id"], name: "index_tar_formula_cuantias_on_tar_detalle_cuantia_id"
    t.index ["tar_tarifa_id"], name: "index_tar_formula_cuantias_on_tar_tarifa_id"
  end

  create_table "tar_formulas", force: :cascade do |t|
    t.integer "orden"
    t.integer "tar_pago_id"
    t.string "tar_formula"
    t.string "mensaje"
    t.string "error"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "codigo"
    t.integer "tar_tarifa_id"
    t.index ["codigo"], name: "index_tar_formulas_on_codigo"
    t.index ["tar_formula"], name: "index_tar_formulas_on_tar_formula"
    t.index ["tar_pago_id"], name: "index_tar_formulas_on_tar_pago_id"
    t.index ["tar_tarifa_id"], name: "index_tar_formulas_on_tar_tarifa_id"
  end

  create_table "tar_horas", force: :cascade do |t|
    t.string "tar_hora"
    t.string "moneda"
    t.decimal "valor"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["owner_class"], name: "index_tar_horas_on_owner_class"
    t.index ["owner_id"], name: "index_tar_horas_on_owner_id"
    t.index ["tar_hora"], name: "index_tar_horas_on_tar_hora"
  end

  create_table "tar_liquidaciones", force: :cascade do |t|
    t.string "liquidacion"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["owner_class"], name: "index_tar_liquidaciones_on_owner_class"
    t.index ["owner_id"], name: "index_tar_liquidaciones_on_owner_id"
  end

  create_table "tar_nota_creditos", force: :cascade do |t|
    t.integer "numero"
    t.datetime "fecha", precision: nil
    t.decimal "monto"
    t.boolean "monto_total"
    t.integer "tar_factura_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["fecha"], name: "index_tar_nota_creditos_on_fecha"
    t.index ["numero"], name: "index_tar_nota_creditos_on_numero"
    t.index ["tar_factura_id"], name: "index_tar_nota_creditos_on_tar_factura_id"
  end

  create_table "tar_pagos", force: :cascade do |t|
    t.integer "tar_tarifa_id"
    t.string "tar_pago"
    t.string "estado"
    t.string "moneda"
    t.decimal "valor"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "orden"
    t.string "codigo_formula"
    t.string "porcentaje_cuantia"
    t.string "boolean"
    t.boolean "requiere_uf"
    t.boolean "detalla_porcentaje_cuantia"
    t.index ["codigo_formula"], name: "index_tar_pagos_on_codigo_formula"
    t.index ["orden"], name: "index_tar_pagos_on_orden"
    t.index ["tar_pago"], name: "index_tar_pagos_on_tar_pago"
    t.index ["tar_tarifa_id"], name: "index_tar_pagos_on_tar_tarifa_id"
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "estado"
    t.integer "tipo_asesoria_id"
    t.index ["codigo"], name: "index_tar_servicios_on_codigo"
    t.index ["estado"], name: "index_tar_servicios_on_estado"
    t.index ["owner_class"], name: "index_tar_servicios_on_owner_class"
    t.index ["owner_id"], name: "index_tar_servicios_on_owner_id"
    t.index ["tipo"], name: "index_tar_servicios_on_tipo"
    t.index ["tipo_asesoria_id"], name: "index_tar_servicios_on_tipo_asesoria_id"
  end

  create_table "tar_tarifas", force: :cascade do |t|
    t.string "tarifa"
    t.string "estado"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "facturables"
    t.string "moneda"
    t.decimal "valor"
    t.decimal "valor_hora"
    t.boolean "cuantia_tarifa"
    t.integer "tipo_causa_id"
    t.index ["estado"], name: "index_tar_tarifas_on_estado"
    t.index ["facturables"], name: "index_tar_tarifas_on_facturables"
    t.index ["moneda"], name: "index_tar_tarifas_on_moneda"
    t.index ["owner_class"], name: "index_tar_tarifas_on_owner_class"
    t.index ["owner_id"], name: "index_tar_tarifas_on_owner_id"
    t.index ["tipo_causa_id"], name: "index_tar_tarifas_on_tipo_causa_id"
  end

  create_table "tar_uf_facturaciones", force: :cascade do |t|
    t.datetime "fecha_uf", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "tar_pago_id"
    t.string "ownr_type"
    t.integer "ownr_id"
    t.index ["fecha_uf"], name: "index_tar_uf_facturaciones_on_fecha_uf"
    t.index ["ownr_id"], name: "index_tar_uf_facturaciones_on_ownr_id"
    t.index ["ownr_type"], name: "index_tar_uf_facturaciones_on_ownr_type"
    t.index ["tar_pago_id"], name: "index_tar_uf_facturaciones_on_tar_pago_id"
  end

  create_table "tar_uf_sistemas", force: :cascade do |t|
    t.date "fecha"
    t.decimal "valor"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["fecha"], name: "index_tar_uf_sistemas_on_fecha"
  end

  create_table "tar_valor_cuantias", force: :cascade do |t|
    t.string "owner_class"
    t.integer "owner_id"
    t.integer "tar_detalle_cuantia_id"
    t.string "otro_detalle"
    t.decimal "valor"
    t.decimal "valor_uf"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "moneda"
    t.decimal "valor_tarifa"
    t.boolean "desactivado"
    t.string "nota"
    t.integer "demandante_id"
    t.string "ownr_type"
    t.integer "ownr_id"
    t.index ["demandante_id"], name: "index_tar_valor_cuantias_on_demandante_id"
    t.index ["desactivado"], name: "index_tar_valor_cuantias_on_desactivado"
    t.index ["owner_class"], name: "index_tar_valor_cuantias_on_owner_class"
    t.index ["owner_id"], name: "index_tar_valor_cuantias_on_owner_id"
    t.index ["ownr_id"], name: "index_tar_valor_cuantias_on_ownr_id"
    t.index ["ownr_type"], name: "index_tar_valor_cuantias_on_ownr_type"
    t.index ["tar_detalle_cuantia_id"], name: "index_tar_valor_cuantias_on_tar_detalle_cuantia_id"
  end

  create_table "tar_valores", force: :cascade do |t|
    t.string "codigo"
    t.string "detalle"
    t.decimal "valor_uf"
    t.decimal "valor"
    t.string "owner_class"
    t.integer "owner_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["codigo"], name: "index_tar_valores_on_codigo"
    t.index ["owner_class"], name: "index_tar_valores_on_owner_class"
    t.index ["owner_id"], name: "index_tar_valores_on_owner_id"
  end

  create_table "tar_variable_bases", force: :cascade do |t|
    t.integer "tar_tarifa_id"
    t.integer "tipo_causa_id"
    t.decimal "tar_base_variable"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["tar_tarifa_id"], name: "index_tar_variable_bases_on_tar_tarifa_id"
    t.index ["tipo_causa_id"], name: "index_tar_variable_bases_on_tipo_causa_id"
  end

  create_table "tar_variables", force: :cascade do |t|
    t.string "variable"
    t.string "owner_class"
    t.integer "owner_id"
    t.decimal "porcentaje"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["owner_class"], name: "index_tar_variables_on_owner_class"
    t.index ["owner_id"], name: "index_tar_variables_on_owner_id"
  end

  create_table "tareas", force: :cascade do |t|
    t.integer "orden"
    t.string "codigo"
    t.string "tarea"
    t.string "plazo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "procedimiento_id"
    t.text "detalle"
    t.integer "ctr_etapa_id"
    t.string "sub_procs"
    t.index ["codigo"], name: "index_tareas_on_codigo"
    t.index ["ctr_etapa_id"], name: "index_tareas_on_ctr_etapa_id"
    t.index ["orden"], name: "index_tareas_on_orden"
    t.index ["procedimiento_id"], name: "index_tareas_on_procedimiento_id"
    t.index ["sub_procs"], name: "index_tareas_on_sub_procs"
  end

  create_table "temas", force: :cascade do |t|
    t.integer "causa_id"
    t.integer "orden"
    t.string "tema"
    t.text "descripcion"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["causa_id"], name: "index_temas_on_causa_id"
    t.index ["orden"], name: "index_temas_on_orden"
  end

  create_table "tipo_asesorias", force: :cascade do |t|
    t.string "tipo_asesoria"
    t.boolean "facturable"
    t.boolean "documento"
    t.boolean "archivos"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "descripcion"
    t.index ["tipo_asesoria"], name: "index_tipo_asesorias_on_tipo_asesoria"
  end

  create_table "tipo_cargos", force: :cascade do |t|
    t.string "tipo_cargo"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["tipo_cargo"], name: "index_tipo_cargos_on_tipo_cargo"
  end

  create_table "tipo_causas", force: :cascade do |t|
    t.string "tipo_causa"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "tar_tarifa_id"
    t.index ["tar_tarifa_id"], name: "index_tipo_causas_on_tar_tarifa_id"
    t.index ["tipo_causa"], name: "index_tipo_causas_on_tipo_causa"
  end

  create_table "tipo_denunciados", force: :cascade do |t|
    t.string "tipo_denunciado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_denuncias", force: :cascade do |t|
    t.string "tipo_denuncia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_procedimientos", force: :cascade do |t|
    t.string "tipo_procedimiento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tribunal_cortes", force: :cascade do |t|
    t.string "tribunal_corte"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["tribunal_corte"], name: "index_tribunal_cortes_on_tribunal_corte"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true
  end

  create_table "valores", force: :cascade do |t|
    t.string "ownr_type"
    t.integer "ownr_id"
    t.integer "variable_id"
    t.string "c_string"
    t.text "c_text"
    t.datetime "c_fecha", precision: nil
    t.decimal "c_numero"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "c_booleano"
    t.index ["ownr_id"], name: "index_valores_on_ownr_id"
    t.index ["ownr_type"], name: "index_valores_on_ownr_type"
    t.index ["variable_id"], name: "index_valores_on_variable_id"
  end

  create_table "var_clis", force: :cascade do |t|
    t.integer "variable_id"
    t.integer "cliente_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cliente_id"], name: "index_var_clis_on_cliente_id"
    t.index ["variable_id"], name: "index_var_clis_on_variable_id"
  end

  create_table "var_tp_causas", force: :cascade do |t|
    t.integer "variable_id"
    t.integer "tipo_causa_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["tipo_causa_id"], name: "index_var_tp_causas_on_tipo_causa_id"
    t.index ["variable_id"], name: "index_var_tp_causas_on_variable_id"
  end

  create_table "variables", force: :cascade do |t|
    t.string "tipo"
    t.string "variable"
    t.string "control"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "orden"
    t.string "descripcion"
    t.string "ownr_type"
    t.integer "ownr_id"
    t.index ["control"], name: "index_variables_on_control"
    t.index ["descripcion"], name: "index_variables_on_descripcion"
    t.index ["orden"], name: "index_variables_on_orden"
    t.index ["ownr_id"], name: "index_variables_on_ownr_id"
    t.index ["ownr_type"], name: "index_variables_on_ownr_type"
    t.index ["tipo"], name: "index_variables_on_tipo"
  end

end
