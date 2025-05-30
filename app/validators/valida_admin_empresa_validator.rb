# app/validators/existe_empresa_validator.rb

class ValidaAdminEmpresaValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)

    nmn = AppNomina.find_by(email: value)
    vrfy = nmn.blank?

    unless vrfy
      record.errors.add(attribute, :invalid_rut, message: "email del administrador ya ha sido utilizado.")
    end
  end

end