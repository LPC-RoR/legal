class CreateVariables < ActiveRecord::Migration[5.2]
  def change
    create_table :variables do |t|
      t.integer :tipo_causa_id
      t.string :tipo
      t.string :variable
      t.string :control

      t.timestamps
    end
    add_index :variables, :tipo
    add_index :variables, :tipo_causa_id
    add_index :variables, :control
  end
end
