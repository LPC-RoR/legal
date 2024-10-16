class AddOwnrOthersToTarCalculo < ActiveRecord::Migration[7.1]
  def change
    add_column :tar_calculos, :cliente_id, :integer
    add_index :tar_calculos, :cliente_id
    add_column :tar_calculos, :ownr_type, :string
    add_index :tar_calculos, :ownr_type
  end
end
