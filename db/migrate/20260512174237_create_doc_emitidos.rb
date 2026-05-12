class CreateDocEmitidos < ActiveRecord::Migration[8.0]
  def change
    create_table :doc_emitidos do |t|
      # Relación con planilla origen
      t.references :doc_planilla, foreign_key: true, null: true

      # Identificación del documento
      t.integer :tipo_dte, null: false
      t.integer :folio, null: false
      t.date :fecha_emision, null: false

      # Emisor
      t.string :rut_emisor, limit: 12, null: false
      t.string :razon_social_emisor, limit: 100, null: false
      t.string :giro_emisor, limit: 100
      t.string :acteco, limit: 10
      t.string :cod_sii_sucursal, limit: 20
      t.string :direccion_emisor, limit: 200
      t.string :comuna_emisor, limit: 50
      t.string :ciudad_emisor, limit: 50

      # Receptor
      t.string :rut_receptor, limit: 12, null: false
      t.string :razon_social_receptor, limit: 100, null: false
      t.string :giro_receptor, limit: 100
      t.string :direccion_receptor, limit: 200
      t.string :comuna_receptor, limit: 50
      t.string :ciudad_receptor, limit: 50

      # Despacho y pago
      t.integer :tipo_despacho
      t.integer :forma_pago

      # Totales
      t.decimal :total_neto, precision: 15, scale: 2
      t.decimal :total_exento, precision: 15, scale: 2
      t.decimal :total_iva, precision: 15, scale: 2
      t.decimal :total_monto_total, precision: 15, scale: 2
      t.decimal :monto_periodo, precision: 15, scale: 2
      t.decimal :monto_no_facturable, precision: 15, scale: 2
      t.decimal :saldo_anterior, precision: 15, scale: 2
      t.decimal :valor_pagar, precision: 15, scale: 2

      t.timestamps
    end

    # Índices y restricciones
    add_index :doc_emitidos, [:tipo_dte, :folio, :rut_emisor], unique: true, name: 'index_doc_emitidos_on_dte_folio_emisor'
    add_index :doc_emitidos, [:rut_receptor, :fecha_emision], name: 'index_doc_emitidos_on_receptor_fecha'
    add_index :doc_emitidos, :fecha_emision, name: 'index_doc_emitidos_on_fecha'
    add_index :doc_emitidos, [:tipo_dte, :folio], name: 'index_doc_emitidos_on_tipo_folio'
    add_index :doc_emitidos, :doc_planilla_id, name: 'index_doc_emitidos_on_planilla'
  end
end
