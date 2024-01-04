class AddOrdenToCausaDoc < ActiveRecord::Migration[5.2]
  def change
    add_column :causa_docs, :orden, :integer
    add_index :causa_docs, :orden
  end
end
