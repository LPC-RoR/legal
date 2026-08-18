class AddEmprsOptnInvstgcnToKrnDenuncias < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :emprs_optn_invstgcn, :string
  end
end
