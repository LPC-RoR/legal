class AddChecksOpcionesToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :info_opciones, :boolean
    add_column :krn_denuncias, :dnncnt_opcion, :string
    add_column :krn_denuncias, :emprs_opcion, :string
  end
end
