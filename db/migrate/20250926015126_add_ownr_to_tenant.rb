class AddOwnrToTenant < ActiveRecord::Migration[8.0]
  def change
    add_column :tenants, :owner_type, :string
    add_index :tenants, :owner_type
    add_column :tenants, :owner_id, :integer
    add_index :tenants, :owner_id
  end
end
