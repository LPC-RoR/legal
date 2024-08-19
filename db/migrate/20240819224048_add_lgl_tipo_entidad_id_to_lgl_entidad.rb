class AddLglTipoEntidadIdToLglEntidad < ActiveRecord::Migration[7.1]
  def change
    add_column :lgl_entidades, :lgl_tipo_entidad_id, :integer
    add_index :lgl_entidades, :lgl_tipo_entidad_id
  end
end
