class DropTwoFiles < ActiveRecord::Migration[7.1]
  def change
    drop_table :consultorias
    drop_table :juzgados
  end
end
