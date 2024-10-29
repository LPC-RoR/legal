class DropMedidasResguardo < ActiveRecord::Migration[7.1]
  def change
    drop_table :krn_lst_medidas
    drop_table :krn_lst_modificaciones
    drop_table :krn_medidas
    drop_table :krn_modificaciones
  end
end
