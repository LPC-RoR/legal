class AddFieldsToLglParrafo < ActiveRecord::Migration[7.1]
  def change
    add_column :lgl_parrafos, :definicion, :boolean
    add_column :lgl_parrafos, :accion, :string
    add_column :lgl_parrafos, :resumen, :string
  end
end
