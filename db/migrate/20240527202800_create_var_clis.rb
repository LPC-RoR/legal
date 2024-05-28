class CreateVarClis < ActiveRecord::Migration[5.2]
  def change
    create_table :var_clis do |t|
      t.integer :variable_id
      t.integer :cliente_id

      t.timestamps
    end
    add_index :var_clis, :variable_id
    add_index :var_clis, :cliente_id
  end
end
