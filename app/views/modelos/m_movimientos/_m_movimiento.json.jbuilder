json.extract! m_movimiento, :id, :fecha, :glosa, :m_item_id, :monto, :created_at, :updated_at
json.url m_movimiento_url(m_movimiento, format: :json)
