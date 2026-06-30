class AddTipoAsesoriaToAsesoria < ActiveRecord::Migration[8.0]
  def change
    add_column :asesorias, :tipo, :string
    add_index :asesorias, :tipo
  end
end
