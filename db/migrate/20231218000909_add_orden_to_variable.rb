class AddOrdenToVariable < ActiveRecord::Migration[5.2]
  def change
    add_column :variables, :orden, :integer
    add_index :variables, :orden
  end
end
