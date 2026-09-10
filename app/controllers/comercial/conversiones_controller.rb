# app/controllers/admin/conversiones_controller.rb
class Comercial::ConversionesController < ApplicationController
  before_action :set_lead

  def new
    @empresa = Empresa.new(
      nombre_contacto: @lead.nombre,
      email_contacto: @lead.email,
      telefono_contacto: @lead.telefono
    )
  end

  def create
    @empresa = @lead.convertir_a_empresa!(
      rut: params[:empresa][:rut],
      razon_social: params[:empresa][:razon_social]
    )
    redirect_to admin_leads_path, notice: "Lead convertido en Empresa."
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  private

  def set_lead
    @lead = Lead.find(params[:lead_id])
    redirect_to admin_leads_path, alert: "Lead ya convertido." if @lead.convertido?
  end
end