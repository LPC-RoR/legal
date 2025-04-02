class AddFieldsToLglDocumento < ActiveRecord::Migration[8.0]
  def change
    add_column :lgl_documentos, :codigo, :string
    add_index :lgl_documentos, :codigo

    add_column :lgl_parrafos, :codigo, :string
    add_index :lgl_parrafos, :codigo
    add_column :lgl_parrafos, :txt_bld, :boolean
    add_column :lgl_parrafos, :txt_cntr, :boolean
  end
end
