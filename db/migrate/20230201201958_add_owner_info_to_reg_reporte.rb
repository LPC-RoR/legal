class AddOwnerInfoToRegReporte < ActiveRecord::Migration[5.2]
  def change
    add_column :reg_reportes, :owner_class, :string
    add_index :reg_reportes, :owner_class
    add_column :reg_reportes, :owner_id, :integer
    add_index :reg_reportes, :owner_id
  end
end
