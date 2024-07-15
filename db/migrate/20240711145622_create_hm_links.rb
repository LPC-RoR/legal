class CreateHmLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :hm_links do |t|
      t.integer :orden
      t.integer :hm_parrafo_id
      t.string :hm_link
      t.string :texto

      t.timestamps
    end
    add_index :hm_links, :orden
    add_index :hm_links, :hm_parrafo_id
  end
end
