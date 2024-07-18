class CreateLglParrafos < ActiveRecord::Migration[7.1]
  def change
    create_table :lgl_parrafos do |t|
      t.integer :lgl_documento_id
      t.integer :orden
      t.text :lgl_parrafo
      t.string :tipo
      t.integer :pdd_lft

      t.timestamps
    end
    add_index :lgl_parrafos, :lgl_documento_id
    add_index :lgl_parrafos, :orden
    add_index :lgl_parrafos, :tipo
  end
end
