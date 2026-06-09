class AddOwnrToDocBoleta < ActiveRecord::Migration[8.0]
  def change
    add_column :doc_boletas, :ownr_type, :string
    add_index :doc_boletas, :ownr_type
    add_column :doc_boletas, :ownr_id, :integer
    add_index :doc_boletas, :ownr_id
    add_column :doc_boletas, :detalle, :string
  end
end
