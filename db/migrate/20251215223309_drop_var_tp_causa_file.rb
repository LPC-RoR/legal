class DropVarTpCausaFile < ActiveRecord::Migration[8.0]
  def change
   drop_table :var_tp_causas
  end
end
