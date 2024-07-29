class CreateHtextos < ActiveRecord::Migration[7.1]
  def change
    create_table :h_textos do |t|
      t.string :codigo
      t.string :h_texto
      t.text :texto
      t.string :imagen
      t.string :img_sz
      t.string :lnk_txt
      t.string :lnk

      t.timestamps
    end
    add_index :h_textos, :codigo
  end
end
