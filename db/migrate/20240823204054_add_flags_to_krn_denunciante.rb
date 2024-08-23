class AddFlagsToKrnDenunciante < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denunciantes, :dnnte_info_reglamento, :boolean
    add_column :krn_denunciantes, :dnnte_info_procedimiento, :boolean
    add_column :krn_denunciantes, :dnnte_info_derechos, :boolean
  end
end
