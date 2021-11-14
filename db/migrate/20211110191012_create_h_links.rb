class CreateHLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :h_links do |t|
      t.string :texto
      t.string :link

      t.timestamps
    end
  end
end
