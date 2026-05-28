class CreateDocPagos < ActiveRecord::Migration[8.0]
  def change
    create_table :doc_pagos do |t|
      t.integer :doc_transaccion_id
      t.string :ownr_type
      t.integer :ownr_id
      t.integer :folio_referencia
      t.decimal :monto

      t.timestamps
    end
    add_index :doc_pagos, :doc_transaccion_id
    add_index :doc_pagos, :ownr_type
    add_index :doc_pagos, :ownr_id
  end
end
