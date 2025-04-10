class AddVerificationFieldsToKrnInvestigador < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_investigadores, :verified, :boolean
    add_column :krn_investigadores, :verification_token, :string
    add_column :krn_investigadores, :verification_sent_at, :datetime
  end
end
