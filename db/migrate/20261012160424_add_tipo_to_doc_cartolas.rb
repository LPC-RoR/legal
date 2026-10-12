class AddTipoToDocCartolas < ActiveRecord::Migration[8.0]
  def change
    add_column :doc_cartolas, :tipo, :string, default: 'provisoria', null: false
    add_index  :doc_cartolas, :tipo
  end
end
