class AddVerificationFieldsToAppNomina < ActiveRecord::Migration[8.0]
  def change
    add_column :app_nominas, :verification_token, :string
    add_column :app_nominas, :verification_sent_at, :datetime
    add_column :app_nominas, :fecha_vrfccn_lnk, :datetime
    add_column :app_nominas, :n_vrfccn_lnks, :integer
    add_column :app_nominas, :email_ok, :string
  end
end
