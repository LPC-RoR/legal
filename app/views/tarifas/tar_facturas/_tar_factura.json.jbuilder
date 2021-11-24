json.extract! tar_factura, :id, :owner_class, :owner_id, :documento, :estado, :created_at, :updated_at
json.url tar_factura_url(tar_factura, format: :json)
