class CreateVarTpCausas < ActiveRecord::Migration[5.2]
  def change
    create_table :var_tp_causas do |t|
      t.integer :variable_id
      t.integer :tipo_causa_id

      t.timestamps
    end
    add_index :var_tp_causas, :variable_id
    add_index :var_tp_causas, :tipo_causa_id
  end
end
