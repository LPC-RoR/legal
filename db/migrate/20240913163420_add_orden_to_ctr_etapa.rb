class AddOrdenToCtrEtapa < ActiveRecord::Migration[7.1]
  def change
    add_column :ctr_etapas, :orden, :integer
    add_index :ctr_etapas, :orden
  end
end
