json.extract! doc_emitido, :id, :nombre_original, :created_at, :updated_at
json.url doc_emitido_url(doc_emitido, format: :json)
