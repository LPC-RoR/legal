class AddDescripcionToTipoAsesoria < ActiveRecord::Migration[7.1]
  def change
    add_column :tipo_asesorias, :descripcion, :string
  end
end
