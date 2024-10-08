class AddPholToVariable < ActiveRecord::Migration[7.1]
  def change
    add_column :variables, :ownr_type, :string
    add_index :variables, :ownr_type
    add_column :variables, :ownr_id, :integer
    add_index :variables, :ownr_id

    remove_index :variables, :tipo_causa_id
    remove_column :variables, :tipo_causa_id, :integer
  end
end
