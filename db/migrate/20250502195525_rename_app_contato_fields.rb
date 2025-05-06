class RenameAppContatoFields < ActiveRecord::Migration[8.0]
  def change
    rename_column :app_contactos, :owner_class, :ownr_type
    rename_column :app_contactos, :owner_id, :ownr_id
  end
end
