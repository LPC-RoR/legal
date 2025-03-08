class RenameOwnerToAppEnlace < ActiveRecord::Migration[8.0]
  def change
    rename_column :app_enlaces, :owner_class, :ownr_type
    rename_column :app_enlaces, :owner_id, :ownr_id
  end
end
