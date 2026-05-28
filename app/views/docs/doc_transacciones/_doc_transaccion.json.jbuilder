json.extract! doc_transaccion, :id, :descripcion, :created_at, :updated_at
json.url doc_transaccion_url(doc_transaccion, format: :json)
