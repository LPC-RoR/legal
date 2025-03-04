class AddMetodoToCtrPaso < ActiveRecord::Migration[8.0]
  def change
    add_column :ctr_pasos, :metodo, :string
  end
end
