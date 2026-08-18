class AddObjecionRslcnToKrnInvDenuncias < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_inv_denuncias, :objecion_rslcn, :string
  end
end
