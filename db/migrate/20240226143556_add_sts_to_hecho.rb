class AddStsToHecho < ActiveRecord::Migration[5.2]
  def change
    add_column :hechos, :st_contestacion, :string
    add_index :hechos, :st_contestacion
    add_column :hechos, :st_preparatoria, :string
    add_index :hechos, :st_preparatoria
  end
end
