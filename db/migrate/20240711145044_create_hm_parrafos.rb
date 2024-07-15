class CreateHmParrafos < ActiveRecord::Migration[7.1]
  def change
    create_table :hm_parrafos do |t|
      t.integer :hm_pagina_id
      t.integer :orden
      t.text :hm_parrafo
      t.string :tipo
      t.string :imagen
      t.string :img_lyt
      t.boolean :menu_lft

      t.timestamps
    end
    add_index :hm_parrafos, :hm_pagina_id
    add_index :hm_parrafos, :orden
  end
end
