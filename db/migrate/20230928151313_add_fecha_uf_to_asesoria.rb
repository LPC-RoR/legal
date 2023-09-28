class AddFechaUfToAsesoria < ActiveRecord::Migration[5.2]
  def change
    add_column :asesorias, :fecha_uf, :datetime
  end
end
