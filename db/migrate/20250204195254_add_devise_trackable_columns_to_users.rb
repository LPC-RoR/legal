class AddDeviseTrackableColumnsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :usuarios, :sign_in_count, :integer, default: 0, null: false
    add_column :usuarios, :current_sign_in_at, :datetime
    add_column :usuarios, :last_sign_in_at, :datetime
    add_column :usuarios, :current_sign_in_ip, :string
    add_column :usuarios, :last_sign_in_ip, :string
  end
end
