class CreateJuzgados < ActiveRecord::Migration[5.2]
  def change
    create_table :juzgados do |t|
      t.string :juzgado

      t.timestamps
    end
  end
end
