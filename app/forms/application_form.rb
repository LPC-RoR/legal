# app/forms/application_form.rb
class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :denuncia_id

  def persisted?
    denuncia_id.present? && denuncia.persisted?
  end

  def to_model
    denuncia
  end

  def denuncia
    @denuncia ||= if denuncia_id.present?
                    KrnDenuncia.find(denuncia_id)
                  else
                    KrnDenuncia.new
                  end
  end

  private

end