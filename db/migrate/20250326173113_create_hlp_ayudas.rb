class CreateHlpAyudas < ActiveRecord::Migration[8.0]
  def change
    create_table :hlp_ayudas do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.string :hlp_ayuda
      t.string :texto
      t.string :referencia

      t.timestamps
    end
    add_index :hlp_ayudas, :ownr_type
    add_index :hlp_ayudas, :ownr_id
  end
end
