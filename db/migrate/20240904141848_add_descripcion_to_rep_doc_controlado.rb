class AddDescripcionToRepDocControlado < ActiveRecord::Migration[7.1]
  def change
    add_column :rep_doc_controlados, :descripcion, :string
  end
end
