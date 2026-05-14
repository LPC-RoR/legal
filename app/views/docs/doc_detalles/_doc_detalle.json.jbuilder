json.extract! doc_detalle, :id, :doc_emitido_id, :ownr_type, :ownr_id, :tipo_detalle, :fecha_uf, :glosa, :monto, :created_at, :updated_at
json.url doc_detalle_url(doc_detalle, format: :json)
