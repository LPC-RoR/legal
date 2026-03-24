class CreateCheckFuentes < ActiveRecord::Migration[8.0]
  def change
    create_table :check_fuentes do |t|
      t.integer :check_realizado_id
      t.integer :usuario_id
      t.datetime :fecha
      t.string :fuente

      t.timestamps
    end
    add_index :check_fuentes, :check_realizado_id
    add_index :check_fuentes, :usuario_id
  end
end
