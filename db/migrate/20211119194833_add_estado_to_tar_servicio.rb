class AddEstadoToTarServicio < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_servicios, :estado, :string
    add_index :tar_servicios, :estado
  end
end
