class CreateEstados < ActiveRecord::Migration[7.1]
  def change
    create_table :estados do |t|
      t.integer :causa_id
      t.string :link
      t.text :estado
      t.boolean :urgente

      t.timestamps
    end
    add_index :estados, :causa_id
  end
end
