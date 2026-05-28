class CreateDocRecibidos < ActiveRecord::Migration[8.0]
  def change
    create_table :doc_recibidos, force: :cascade do |t|
      t.integer :tipo_dte, null: false
      t.integer :folio, null: false
      t.date :fecha_emision, null: false
      t.string :rut_emisor, limit: 12, null: false
      t.string :razon_social_emisor, limit: 100, null: false
      t.string :giro_emisor, limit: 100
      t.string :acteco, limit: 10
      t.string :cod_sii_sucursal, limit: 20
      t.string :direccion_emisor, limit: 200
      t.string :comuna_emisor, limit: 50
      t.string :ciudad_emisor, limit: 50
      t.string :rut_receptor, limit: 12, null: false
      t.string :razon_social_receptor, limit: 100, null: false
      t.string :giro_receptor, limit: 100
      t.string :direccion_receptor, limit: 200
      t.string :comuna_receptor, limit: 50
      t.string :ciudad_receptor, limit: 50
      t.integer :tipo_despacho
      t.integer :forma_pago
      t.decimal :total_neto, precision: 15, scale: 2
      t.decimal :total_exento, precision: 15, scale: 2
      t.decimal :total_iva, precision: 15, scale: 2
      t.decimal :total_monto_total, precision: 15, scale: 2
      t.decimal :monto_periodo, precision: 15, scale: 2
      t.decimal :monto_no_facturable, precision: 15, scale: 2
      t.decimal :saldo_anterior, precision: 15, scale: 2
      t.decimal :valor_pagar, precision: 15, scale: 2
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.bigint :proveedor_id
      t.bigint :doc_planilla_id
      t.string :tipo_factura

      t.index [:proveedor_id], name: "index_doc_recibidos_on_cliente_id"
      t.index [:doc_planilla_id], name: "index_doc_recibidos_on_doc_planilla_id"
      t.index [:fecha_emision], name: "index_doc_recibidos_on_fecha"
      t.index [:rut_receptor, :fecha_emision], name: "index_doc_recibidos_on_receptor_fecha"
      t.index [:tipo_dte, :folio, :rut_emisor], name: "index_doc_recibidos_on_dte_folio_emisor", unique: true
      t.index [:tipo_dte, :folio], name: "index_doc_recibidos_on_tipo_folio"
    end
  end
end
