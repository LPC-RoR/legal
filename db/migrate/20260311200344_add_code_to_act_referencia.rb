class AddCodeToActReferencia < ActiveRecord::Migration[8.0]
  def change
    add_column :act_referencias, :code, :string
    add_index :act_referencias, :code
  end
end
