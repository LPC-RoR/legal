class AddVerificationFieldsToKrnDenunciado < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denunciados, :verified, :boolean
    add_column :krn_denunciados, :verification_token, :string
    add_column :krn_denunciados, :verification_sent_at, :datetime
  end
end
