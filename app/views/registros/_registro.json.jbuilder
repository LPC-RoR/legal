json.extract! registro, :id, :owner_class, :owner_id, :fecha, :tipo, :detalle, :nota, :duracion.time, :descuento, :razon_descuento, :estado, :created_at, :updated_at
json.url registro_url(registro, format: :json)
