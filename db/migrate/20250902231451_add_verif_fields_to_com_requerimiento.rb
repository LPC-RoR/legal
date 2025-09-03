class AddVerifFieldsToComRequerimiento < ActiveRecord::Migration[8.0]
  def change
    add_column :com_requerimientos, :email_ok, :string
    add_column :com_requerimientos, :verification_token, :string
    add_column :com_requerimientos, :verification_sent_at, :datetime
    add_column :com_requerimientos, :n_vrfccn_lnks, :integer, default: 0, null: false
    add_column :com_requerimientos, :fecha_vrfccn_lnk, :datetime
  
    add_index :com_requerimientos, :verification_token, unique: true
  end
end
