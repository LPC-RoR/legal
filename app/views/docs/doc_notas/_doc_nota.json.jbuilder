json.extract! doc_nota, :id, :ownr_type, :ownr_id, :nota, :created_at, :updated_at
json.url doc_nota_url(doc_nota, format: :json)
