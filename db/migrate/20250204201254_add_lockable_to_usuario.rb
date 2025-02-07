class AddLockableToUsuario < ActiveRecord::Migration[7.1]
  def change
    add_column :usuarios, :failed_attempts, :integer, default: 0, null: false # Only if lock strategy is :failed_attempts
    add_column :usuarios, :unlock_token, :string # Only if unlock strategy is :email or :both
    add_index :usuarios, :unlock_token, unique: true
    add_column :usuarios, :locked_at, :datetime
  end
end
