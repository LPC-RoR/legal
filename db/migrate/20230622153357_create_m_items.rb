class CreateMItems < ActiveRecord::Migration[5.2]
  def change
    create_table :m_items do |t|
      t.integer :orden
      t.string :m_item

      t.timestamps
    end
    add_index :m_items, :m_item
  end
end
