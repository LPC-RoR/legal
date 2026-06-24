class DropVariables < ActiveRecord::Migration[8.0]
  def change
   drop_table :variables
   drop_table :valores
   drop_table :var_clis
  end
end
