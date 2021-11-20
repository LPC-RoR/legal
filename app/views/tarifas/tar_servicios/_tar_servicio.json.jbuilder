json.extract! tar_servicio, :id, :codigo, :descripcion, :detalle, :tipo, :moneda, :monto, :owner_class, :objeto_id, :created_at, :updated_at
json.url tar_servicio_url(tar_servicio, format: :json)
