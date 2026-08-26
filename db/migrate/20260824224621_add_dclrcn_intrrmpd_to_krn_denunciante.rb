class AddDclrcnIntrrmpdToKrnDenunciante < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denunciantes, :dclrcn_intrrmpd, :string
    add_column :krn_denunciados, :dclrcn_intrrmpd, :string
    add_column :krn_testigos, :dclrcn_intrrmpd, :string
  end
end
