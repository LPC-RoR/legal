class RenameFlags < ActiveRecord::Migration[7.1]
  def change
    rename_column :krn_denunciados, :dnndo_info_reglamento, :info_reglamento
    rename_column :krn_denunciados, :dnndo_info_procedimiento, :info_procedimiento
    rename_column :krn_denunciados, :dnndo_info_derechos, :info_derechos
    rename_column :krn_denunciantes, :dnnte_info_reglamento, :info_reglamento
    rename_column :krn_denunciantes, :dnnte_info_procedimiento, :info_procedimiento
    rename_column :krn_denunciantes, :dnnte_info_derechos, :info_derechos
  end
end
