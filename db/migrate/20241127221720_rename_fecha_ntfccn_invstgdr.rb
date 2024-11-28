class RenameFechaNtfccnInvstgdr < ActiveRecord::Migration[7.1]
  def change
    rename_column :krn_denuncias, :fecha_hora_ntfccn_invsgdr, :fecha_ntfccn_invstgdr
  end
end
