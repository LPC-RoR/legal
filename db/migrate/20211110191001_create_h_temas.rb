class CreateHTemas < ActiveRecord::Migration[5.2]
  def change
    create_table :h_temas do |t|
      t.string :tema
      t.string :detalle

      t.timestamps
    end
    add_index :h_temas, :tema
  end
end
