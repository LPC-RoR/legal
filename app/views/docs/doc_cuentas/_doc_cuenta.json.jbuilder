json.extract! doc_cuenta, :id, :sucursal, :created_at, :updated_at
json.url doc_cuenta_url(doc_cuenta, format: :json)
