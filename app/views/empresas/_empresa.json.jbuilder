json.extract! empresa, :id, :rut, :razon_social, :email_administrador, :email_verificado, :sha1, :created_at, :updated_at
json.url empresa_url(empresa, format: :json)
