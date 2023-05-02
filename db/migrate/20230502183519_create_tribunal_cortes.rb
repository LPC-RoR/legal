class CreateTribunalCortes < ActiveRecord::Migration[5.2]
  def change
    create_table :tribunal_cortes do |t|
      t.string :tribunal_corte

      t.timestamps
    end
    add_index :tribunal_cortes, :tribunal_corte
  end
end
