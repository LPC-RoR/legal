json.extract! app_enlace, :id, :descripcion, :enlace, :owner_class, :owner_id, :created_at, :updated_at
json.url app_enlace_url(app_enlace, format: :json)
