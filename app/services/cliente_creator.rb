# app/services/empresa_creator.rb
class ClienteCreator
  def self.call(attrs, owner_user)
    Cliente.transaction do
      cliente = Cliente.create!(attrs)
      tenant  = cliente.create_tenant!(name: cliente.razon_social)
      owner_user.update!(tenant: tenant)
      owner_user.add_role(:admin, tenant)
      cliente
    end
  end
end