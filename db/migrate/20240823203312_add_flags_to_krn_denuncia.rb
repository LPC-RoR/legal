class AddFlagsToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :dnnte_info_derivacion, :boolean
    add_column :krn_denuncias, :dnnte_derivacion, :boolean
    add_column :krn_denuncias, :dnnte_entidad_investigacion, :string
    add_column :krn_denuncias, :dnnte_empresa_investigacion_id, :integer
    add_index :krn_denuncias, :dnnte_empresa_investigacion_id
    add_index :krn_denuncias, :dnnte_derivacion
  end
end
