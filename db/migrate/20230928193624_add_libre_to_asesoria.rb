class AddLibreToAsesoria < ActiveRecord::Migration[5.2]
  def change
    add_column :asesorias, :moneda, :string
    add_column :asesorias, :monto, :decimal
  end
end
