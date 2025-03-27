class RenameTarifasOwner < ActiveRecord::Migration[8.0]
  def change
    rename_column :tar_tarifas, :owner_class, :ownr_type
    rename_column :tar_tarifas, :owner_id, :ownr_id
    rename_column :tar_servicios, :owner_class, :ownr_type
    rename_column :tar_servicios, :owner_id, :ownr_id
  end
end
