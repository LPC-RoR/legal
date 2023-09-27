class AddEstadoToAsesoria < ActiveRecord::Migration[5.2]
  def change
    add_column :asesorias, :estado, :string
    add_index :asesorias, :estado
  end
end
