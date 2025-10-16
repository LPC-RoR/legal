class AddTipoToActArchivo < ActiveRecord::Migration[8.0]
  def change
    add_column :act_archivos, :tipo, :string
  end
end
