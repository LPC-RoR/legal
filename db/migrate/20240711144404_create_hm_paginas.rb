class CreateHmPaginas < ActiveRecord::Migration[7.1]
  def change
    create_table :hm_paginas do |t|
      t.string :codigo
      t.string :hm_pagina
      t.string :tooltip
      t.boolean :menu_lft

      t.timestamps
    end
    add_index :hm_paginas, :codigo
  end
end
