json.extract! denuncia, :id, :empresa_id, :tipo_denuncia_id, :denunciante, :rut, :cargo, :lugar_trabajo, :verbal_escrita, :empleador_dt_tercero, :presencial_electronica, :email, :created_at, :updated_at
json.url denuncia_url(denuncia, format: :json)
