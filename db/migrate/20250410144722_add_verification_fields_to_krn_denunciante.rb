class AddVerificationFieldsToKrnDenunciante < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denunciantes, :verified, :boolean
    add_column :krn_denunciantes, :verification_token, :string
    add_column :krn_denunciantes, :verification_sent_at, :datetime
  end
end
