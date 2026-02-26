class Autenticacion::AppNominasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_app_nomina, only: %i[ show edit update destroy rlzd ]

  include MailDesk

  # GET /app_nominas or /app_nominas.json
  def index
    set_pgnt_tbl('app_nominas', AppNomina.gnrl.nombre_ordr)
    set_tabla('app_nominas', AppNomina.gnrl.nombre_ordr, false)
  end

  # GET /app_nominas/1 or /app_nominas/1.json
  def show
  end

  # GET /app_nominas/new
  def new
    oid = params[:oid].blank? ? nil : params[:oid]
    oclss = params[:oid].blank? ? nil : params[:oclss]
    @objeto = AppNomina.new(ownr_type: oclss, ownr_id: oid)
  end

  # GET /app_nominas/1/edit
  def edit
  end

  # POST /app_nominas or /app_nominas.json
  def create
    @objeto = AppNomina.new(app_nomina_params)
    
    # -----------------------------------------------------------
    # MailDesk: llena los campos del modelo que registra el envío
    set_vrfccn_fields

    respond_to do |format|
      if @objeto.save

        # ------------------------------------
        # MailDesk
        enviar_correo_verificacion('nmn')

        format.html { redirect_to default_redirect_path(@objeto), notice: "Nomina de usuario fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def verify
    @objeto = AppNomina.find_by!(verification_token: params[:token])
    @objeto.update!(email_verified: true, verification_token: nil)

    usuario = Usuario.find_or_initialize_by(email: @objeto.email_administrador)

    random_password = usuario.new_record? ? Devise.friendly_token.first(12) : nil
    if usuario.new_record?
      usuario.assign_attributes(
        password:              random_password,
        password_confirmation: random_password,
        confirmed_at:          Time.current
      )
    end

    usuario.tenant = @objeto.tenant
    usuario.save!
    usuario.add_role(@objeto.tipo.to_sym, @objeto.tenant)

    bypass_sign_in(usuario) if usuario == current_usuario

    # NUEVO: Usar mailer de Platform context directamente
    if random_password
      Contexts::Platform::AccountMailer
        .welcome_email(usuario.id, random_password)
        .deliver_later
    end

    redirect_to default_redirect_path(@objeto), notice: 'Correo verificado correctamente'
  rescue ActiveRecord::RecordNotFound
    redirect_to default_redirect_path(@objeto), alert: 'Token inválido'
  end


# PATCH/PUT /app_nominas/1 or /app_nominas/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_nomina_params)
        format.html { redirect_to default_redirect_path(@objeto), notice: "Nomina de usuario fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_nominas/1 or /app_nominas/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to default_redirect_path(@objeto), notice: "Nomina de usuario fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_nomina
      @objeto = AppNomina.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_nomina_params
      params.require(:app_nomina).permit(:nombre, :email, :tipo, :ownr_type, :ownr_id)
    end
end
