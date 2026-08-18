class AddDnncntOptnInvstgcnToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :dnncnt_optn_invstgcn, :string
  end
end
