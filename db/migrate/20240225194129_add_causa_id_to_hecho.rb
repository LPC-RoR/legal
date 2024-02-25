class AddCausaIdToHecho < ActiveRecord::Migration[5.2]
  def change
    add_column :hechos, :causa_id, :integer
    add_index :hechos, :causa_id
  end
end
