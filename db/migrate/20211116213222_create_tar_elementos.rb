class CreateTarElementos < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_elementos do |t|
      t.integer :orden
      t.string :elemento
      t.string :codigo

      t.timestamps
    end
    add_index :tar_elementos, :orden
    add_index :tar_elementos, :codigo
  end
end
