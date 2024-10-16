class AddOwnrToTarFacturacion < ActiveRecord::Migration[7.1]
  def change
    add_column :tar_facturaciones, :ownr_type, :string
    add_index :tar_facturaciones, :ownr_type
    add_column :tar_facturaciones, :ownr_id, :integer
    add_index :tar_facturaciones, :ownr_id
  end
end
