class CreateHlpTutoriales < ActiveRecord::Migration[5.2]
  def change
    create_table :hlp_tutoriales do |t|
      t.string :tutorial
      t.string :clave
      t.text :detalle

      t.timestamps
    end
    add_index :hlp_tutoriales, :clave
  end
end
