json.extract! doc_pago, :id, :doc_transaccion_id, :ownr_type, :ownr_id, :folio_referencia, :monto, :created_at, :updated_at
json.url doc_pago_url(doc_pago, format: :json)
