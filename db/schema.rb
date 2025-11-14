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

ActiveRecord::Schema[8.0].define(version: 2025_11_12_200821) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "unaccent"

  create_table "act_archivos", force: :cascade do |t|
    t.string "ownr_type"
    t.integer "ownr_id"
    t.string "act_archivo"
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "fecha"
    t.string "mdl"
    t.boolean "control_fecha"
    t.boolean "rlzd"
    t.string "tipo"
    t.boolean "anonimizado", default: false, null: false
    t.bigint "anonimizado_de_id"
    t.string "processing_status", default: "pending"
    t.datetime "processed_at"
    t.index ["act_archivo"], name: "index_act_archivos_on_act_archivo"
    t.index ["anonimizado_de_id"], name: "index_act_archivos_on_anonimizado_de_id"
    t.index ["control_fecha"], name: "index_act_archivos_on_control_fecha"
    t.index ["mdl"], name: "index_act_archivos_on_mdl"
    t.index ["ownr_id"], name: "index_act_archivos_on_ownr_id"
    t.index ["ownr_type", "ownr_id", "act_archivo"], name: "idx_act_archivos_polymorphic_tipo"
    t.index ["ownr_type"], name: "index_act_archivos_on_ownr_type"
    t.index ["processing_status"], name: "index_act_archivos_on_processing_status"
    t.index ["rlzd"], name: "index_act_archivos_on_rlzd"
  end

  create_table "act_metadatas", force: :cascade do |t|
    t.bigint "act_archivo_id", null: false
    t.string "act_metadata", null: false
    t.jsonb "metadata", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["act_archivo_id", "act_metadata"], name: "idx_act_metadatas_unique_codigo", unique: true
    t.index ["act_archivo_id"], name: "index_act_metadatas_on_act_archivo_id"
    t.index ["metadata"], name: "index_act_metadatas_on_metadata", using: :gin
  end

  create_table "act_textos", force: :cascade do |t|
    t.bigint "act_archivo_id", null: false
    t.string "tipo_documento", null: false
    t.string "titulo", null: false
    t.text "notas"
    t.jsonb "metadata", default: {}
    t.integer "version", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["act_archivo_id", "tipo_documento"], name: "index_act_textos_on_act_archivo_id_and_tipo_documento", unique: true
    t.index ["act_archivo_id"], name: "index_act_textos_on_act_archivo_id"
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    t.index ["record_type", "record_id", "name"], name: "idx_as_attachments_record_name"
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
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
    t.boolean "suspendida"
    t.index ["app_perfil_id"], name: "index_age_actividades_on_app_perfil_id"
    t.index ["estado"], name: "index_age_actividades_on_estado"
    t.index ["fecha"], name: "index_age_actividades_on_fecha"
    t.index ["ownr_id"], name: "index_age_actividades_on_ownr_id"
    t.index ["ownr_type", "ownr_id", "fecha"], name: "idx_age_actividades_polymorphic_fecha"
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
    t.integer "usuario_id"
    t.index ["age_usuario_id"], name: "index_age_pendientes_on_age_usuario_id"
    t.index ["usuario_id"], name: "index_age_pendientes_on_usuario_id"
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

