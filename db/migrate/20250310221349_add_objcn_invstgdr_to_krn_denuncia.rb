class AddObjcnInvstgdrToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :objcn_invstgdr, :boolean
  end
end
