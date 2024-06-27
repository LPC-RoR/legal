class AddUrgenteToAsesoria < ActiveRecord::Migration[7.1]
  def change
    add_column :asesorias, :urgente, :boolean
  end
end
