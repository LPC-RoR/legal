json.extract! tar_convenio, :id, :fecha, :monto, :estado, :tar_factura_id, :created_at, :updated_at
json.url tar_convenio_url(tar_convenio, format: :json)
