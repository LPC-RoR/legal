class EmpresasController < ApplicationController
  before_action :authenticate_usuario!, only: %i[ show ]
  before_action :scrty_on
  before_action :set_empresa, only: %i[ show edit update destroy ]
  after_action :add_admin, only: :registro

  include Rut

  # GET /empresas or /empresas.json
  def index
    set_tabla('empresas', Empresa.rut_ordr, true)
  end

  # GET /empresas/1 or /empresas/1.json
  def show
      set_tabla('pro_dtll_ventas', @objeto.pro_dtll_ventas.fecha_ordr, false)
  end

  # GET /empresas/new
  def new
    @objeto = Empresa.new
  end

  def registro
    prms = params[:rgstr]
    unless prms[:rut].blank? or prms[:razon_social].blank? or prms[:email_administrador].blank?
      if valid_rut?(prms[:rut])
        emprs = Empresa.find_by(rut: rut_format(prms[:rut]))
        if emprs.blank?
          @objeto = Empresa.create(rut: rut_format(prms[:rut]), razon_social: prms[:razon_social], email_administrador: prms[:email_administrador], demo: prms[:demo], contacto: prms[:contacto])
          ntc = 'Empresa registrada exitósamente'
        else
          alrt = 'Empresa ya registrada'
        end
      else
        alrt = 'Error de registro: RUT no válido'
      end
    else
      alrt = 'Error de registro: Falta información para completar el registro'
    end

    redirect_to root_path, notice: ntc, alert: alrt
  end

  # GET /empresas/1/edit
  def edit
  end

  # POST /empresas or /empresas.json
  def create
    @objeto = Empresa.new(empresa_params)
    @objeto.verification_token = SecureRandom.urlsafe_base64
    @objeto.email_verified = false

    respond_to do |format|
      if @objeto.save
        EmpresaMailer.verification_email(@objeto).deliver_later
        format.html { redirect_to root_path, notice: 'Te hemos enviado un correo de verificación' }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'registration-form',
            partial: 'empresas/registration_success',
            locals: { email: @objeto.email_administrador }
          )
        end
      else
        format.html { redirect_to root_path, alert: @objeto.errors.full_messages.join(', ') }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'registration-form',
            partial: 'empresas/registration_form',
            locals: { user: @objeto }
          )
        end
      end

    end
  end

  def verify
    @objeto = Empresa.find_by(verification_token: params[:token])
    
    if @objeto
      @objeto.update(email_verified: true, verification_token: nil)
      redirect_to root_path, notice: 'Correo verificado correctamente'
    else
      redirect_to root_path, alert: 'Token de verificación inválido'
    end
  end

  # PATCH/PUT /empresas/1 or /empresas/1.json
  def update
    respond_to do |format|
      if @objeto.update(empresa_params)
        format.html { redirect_to empresa_url(@objeto), notice: "Empresa was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /empresas/1 or /empresas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to empresas_url, notice: "Empresa was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def add_admin
      unless @objeto.blank?
        @objeto.app_nominas.create(ownr_type: @objeto.class.name, ownr_id: @objeto.id, nombre: 'Administrador', email: @objeto.email_administrador, tipo:'admin')
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_empresa
      @objeto = Empresa.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def empresa_params
      params.require(:empresa).permit(:rut, :razon_social, :email_administrador, :email_verificado, :sha1)
    end
end
