class AddVerificationFieldsToKrnTestigo < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_testigos, :verified, :boolean
    add_column :krn_testigos, :verification_token, :string
    add_column :krn_testigos, :verification_sent_at, :datetime
  end
end
