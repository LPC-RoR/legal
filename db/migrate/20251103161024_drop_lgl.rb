class DropLgl < ActiveRecord::Migration[8.0]
  def change
   drop_table :lgl_entidades
   drop_table :lgl_recursos
   drop_table :lgl_temas
   drop_table :lgl_citas
   drop_table :lgl_parrafos
   drop_table :lgl_documentos
   drop_table :lgl_datos
   drop_table :lgl_parra_parras
   drop_table :lgl_puntos
   drop_table :lgl_tipo_entidades
   drop_table :lgl_tramo_empresas
  end
end
