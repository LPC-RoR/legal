class CreateValores < ActiveRecord::Migration[5.2]
  def change
    create_table :valores do |t|
      t.string :owner_class
      t.integer :owner_id
      t.integer :variable_id
      t.string :c_string
      t.text :c_text
      t.datetime :c_fecha
      t.decimal :c_numero

      t.timestamps
    end
    add_index :valores, :owner_class
    add_index :valores, :owner_id
    add_index :valores, :variable_id
  end
end
