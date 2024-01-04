class AddOrdenToHechoDoc < ActiveRecord::Migration[5.2]
  def change
    add_column :hecho_docs, :orden, :integer
    add_index :hecho_docs, :orden
  end
end
