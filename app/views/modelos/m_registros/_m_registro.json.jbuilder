json.extract! m_registro, :id, :m_registro, :orden, :m_conciliacion_id, :fecha, :glosa_banco, :glosa, :documento, :monto, :cargo_abono, :saldo, :created_at, :updated_at
json.url m_registro_url(m_registro, format: :json)
