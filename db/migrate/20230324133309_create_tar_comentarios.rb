class CreateTarComentarios < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_comentarios do |t|
      t.integer :tar_pago_id
      t.integer :orden
      t.string :tipo
      t.string :formula
      t.text :comentario
      t.text :opcional

      t.timestamps
    end
    add_index :tar_comentarios, :tar_pago_id
  end
end
