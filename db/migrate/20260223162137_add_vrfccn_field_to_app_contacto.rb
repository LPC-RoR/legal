class AddVrfccnFieldToAppContacto < ActiveRecord::Migration[8.0]
  def change
    add_column :app_contactos, :verification_token, :string
    add_column :app_contactos, :verification_sent_at, :datetime
    add_column :app_contactos, :fecha_vrfccn_lnk, :datetime
    add_column :app_contactos, :n_vrfccn_lnks, :integer
  end
end
