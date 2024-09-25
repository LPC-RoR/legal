class AddOwnrToAppNomina < ActiveRecord::Migration[7.1]
  def change
    add_column :app_nominas, :ownr_type, :string
    add_index :app_nominas, :ownr_type
    add_column :app_nominas, :ownr_id, :integer
    add_index :app_nominas, :ownr_id
  end
end
