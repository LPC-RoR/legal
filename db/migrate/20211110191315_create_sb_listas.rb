class CreateSbListas < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_listas do |t|
      t.string :lista
      t.string :acceso
      t.string :link
      t.boolean :activa

      t.timestamps
    end
  end
end
