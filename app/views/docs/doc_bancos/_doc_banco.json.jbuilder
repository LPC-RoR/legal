json.extract! doc_banco, :id, :nombre, :rut, :created_at, :updated_at
json.url doc_banco_url(doc_banco, format: :json)
