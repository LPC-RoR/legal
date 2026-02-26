class AddVrfccnFieldToKrnEmpresaExterna < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_empresa_externas, :verification_token, :string
    add_column :krn_empresa_externas, :verification_sent_at, :datetime
    add_column :krn_empresa_externas, :fecha_vrfccn_lnk, :datetime
    add_column :krn_empresa_externas, :n_vrfccn_lnks, :integer
  end
end
