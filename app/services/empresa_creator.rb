# app/services/empresa_creator.rb
class EmpresaCreator
  def self.call(attrs, owner_user)
    Empresa.transaction do
      empresa = Empresa.create!(attrs)
      tenant  = empresa.create_tenant!(name: empresa.razon_social)
      owner_user.update!(tenant: tenant)
      owner_user.add_role(:admin, tenant)
      empresa
    end
  end
end