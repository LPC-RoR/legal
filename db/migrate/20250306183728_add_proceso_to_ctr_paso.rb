class AddProcesoToCtrPaso < ActiveRecord::Migration[8.0]
  def change
    add_column :ctr_pasos, :proceso, :boolean
  end
end
