class AddFlagsToTarDetalle < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_detalles, :esconder, :boolean
    add_column :tar_detalles, :total, :boolean
  end
end
