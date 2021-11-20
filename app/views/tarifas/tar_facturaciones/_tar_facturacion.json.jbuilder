json.extract! tar_facturacion, :id, :facturable, :monto, :estado, :owner_class, :owner_id, :created_at, :updated_at
json.url tar_facturacion_url(tar_facturacion, format: :json)
