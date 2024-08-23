json.extract! krn_denuncia, :id, :cliente_id, :receptor_denuncia_id, :empresa_receptora_id, :motivo_denuncia_id, :investigador_id, :fecha_hora, :fecha_hora_dt, :fecha_hora_recepcion, :created_at, :updated_at
json.url krn_denuncia_url(krn_denuncia, format: :json)
