class RemoveOldFieldsFromHrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    remove_column :krn_denuncias, :fecha_hora_recepcion, :datetime
    remove_column :krn_denuncias, :dnnte_info_derivacion, :boolean
    remove_column :krn_denuncias, :dnnte_derivacion, :boolean
    remove_column :krn_denuncias, :dnnte_entidad_investigacion, :string
    remove_column :krn_denuncias, :dnnte_empresa_investigacion_id, :integer
    remove_column :krn_denuncias, :documento_representacion, :string
    remove_column :krn_denuncias, :info_opciones, :boolean
    remove_column :krn_denuncias, :dnncnt_opcion, :string
    remove_column :krn_denuncias, :emprs_opcion, :string
    remove_column :krn_denuncias, :leida, :boolean
    remove_column :krn_denuncias, :incnsstnt, :boolean
    remove_column :krn_denuncias, :incmplt, :boolean
  end
end
