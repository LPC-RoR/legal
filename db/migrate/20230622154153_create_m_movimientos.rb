class CreateMMovimientos < ActiveRecord::Migration[5.2]
  def change
    create_table :m_movimientos do |t|
      t.datetime :fecha
      t.string :glosa
      t.integer :m_item_id
      t.decimal :monto

      t.timestamps
    end
    add_index :m_movimientos, :m_item_id
  end
end
