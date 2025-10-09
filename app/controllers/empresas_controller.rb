class EmpresasController < ApplicationController
  before_action :authenticate_usuario!, except: [:create, :verify]
  before_action :scrty_on
  before_action :set_empresa, only: %i[ show edit update destroy swtch prg ]

  # anti-bot para create
  MIN_FILL_SECONDS = 3

  after_action :add_admin, only: :create
  after_action :rut_puro, only: %i[ create update ]

  include Rut

  # GET /empresas or /empresas.json
  def index
    set_tabla('empresas', empresas_visibles, true)
    render layout: 'addt'
  end

  # GET /empresas/1 or /empresas/1.json
  def show
    set_tabla('pro_dtll_ventas', @objeto.pro_dtll_ventas, false)
  end

  # GET /empresas/new
  def new
    @objeto = Empresa.new
  end

  # GET /empresas/1/edit
  def edit
  end

  # POST /empresas or /empresas.json
  def create
    # --- CORTES TEMPRANOS ANTI-BOT ---
    if params.dig(:objeto, :website).present?
      head :ok and return
    end

    loaded_at = params[:form_loaded_at].to_i
    if loaded_at.zero? || (Time.current.to_i - loaded_at) < MIN_FILL_SECONDS
      head :ok and return
    end
    # --- FIN ANTI-BOT ---

    @objeto = Empresa.new(empresa_params)
    @objeto.build_tenant(name: @objeto.razon_social)

    purge_logo_if_requested
    @objeto.verification_token = SecureRandom.urlsafe_base64
    @objeto.email_verified = false

    respond_to do |format|          # <-- FALTABA ESTE BLOQUE
      if @objeto.save
        EmpresaMailer.with(empresa_id: @objeto.id).verification_email.deliver_later

        format.html { redirect_to root_path, notice: 'Te hemos enviado un correo de verificación' }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'registration-form',
            partial: 'empresas/registration_success',
            locals: { email: @objeto.email_administrador }
          )
        end
      else
        @req = ComRequerimiento.new
        error_messages = @objeto.errors.full_messages
        flash[:errors] = error_messages

        format.html { redirect_to root_path(errors: error_messages), alert: 'Error en el registro de la empresa' }
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
    @objeto = Empresa.find_by!(verification_token: params[:token])
    @objeto.update!(email_verified: true, verification_token: nil)

    usuario = Usuario.find_or_initialize_by(email: @objeto.email_administrador)

    if usuario.new_record?
      random_password = Devise.friendly_token.first(12)
      usuario.assign_attributes(
        password:              random_password,
        password_confirmation: random_password,
        confirmed_at:          Time.current
      )
    end

    # Asignar tenant y rol
    usuario.tenant = @objeto.tenant
    usuario.save!
    usuario.add_role(:admin, @objeto.tenant)

    # <-- AQUÍ -->
    if usuario == current_usuario
      bypass_sign_in(usuario) # actualiza sesión de Devise
    end

    # Bienvenida
    EmpresaMailer.wellcome_email(usuario.email, random_password).deliver_later

    redirect_to root_path, notice: 'Correo verificado correctamente'
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Token inválido'
  end

  # PATCH/PUT /empresas/1 or /empresas/1.json
  def update
    respond_to do |format|
      if @objeto.update(empresa_params)
        purge_logo_if_requested
        format.html { redirect_to cta_root_path, notice: "Empresa fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_role
    @usuario = @objeto.tenant.usuarios.find(params[:usuario_id])
    nuevo_rol = params[:rol]

    # 1. Quitar roles previos sobre este tenant
    @usuario.roles.where(resource: @objeto.tenant).destroy_all

    # 2. Asignar nuevo rol
    @usuario.add_role(nuevo_rol.to_sym, @objeto.tenant)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "usuario_#{@usuario.id}_rol",
          partial: 'empresas/usuario_rol',
          locals: { usuario: @usuario }
        )
      end
      format.html { redirect_back fallback_location: empresa_path(@objeto), notice: 'Rol actualizado' }
    end
  end

  # DELETE /empresas/1 or /empresas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to empresas_path, notice: "Empresa fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  def prg
    @objeto.krn_investigadores.delete_all
    @objeto.krn_denuncias.delete_all
    @objeto.krn_empresa_externas.delete_all
    @objeto.pro_dtll_ventas.delete_all
    @objeto.rcrs_logo.delete if @objeto.rcrs_logo.present?
    @objeto.app_contactos.delete_all
    @objeto.app_nominas.each do |nmn|
      prfl = nmn.app_perfil
      prfl.delete unless prfl.blank?
      nmn.delete
    end

    redirect_to empresas_path
  end

  private

    # devuelve el scope que el usuario puede ver
    def empresas_visibles
      if current_usuario.tenant.nil?
        Empresa.all
      else
        case current_usuario.tenant.owner_type
        when 'AppVersion'
          Empresa.all
        when 'Empresa'
          Empresa.where(id: current_usuario.tenant.owner_id)
        when 'Cliente'
          Empresa.none # o la lógica que corresponda si un Cliente puede ver empresas
        else
          Empresa.none
        end
      end
    end

    def cta_root_path
      "/cuentas/e_#{@objeto.id}/dnncs"
    end

    def purge_logo_if_requested
      if params.dig(:empresa, :remove_logo) == "1" && @objeto.logo.attached?
        @objeto.logo.purge
      end
    end

    def current_tenant_id
      return nil unless defined?(::Current)
      return nil unless ::Current.respond_to?(:tenant)
      ::Current.tenant&.id
    end

    def add_admin
      return unless @objeto&.persisted?
      @objeto.app_nominas.create(
        ownr_type: @objeto.class.name,
        ownr_id:   @objeto.id,
        nombre:    'Administrador',
        email:     @objeto.email_administrador,
        tipo:      'admin'
      )
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_empresa
      @objeto = empresas_visibles.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to empresas_path, alert: 'Empresa no encontrada'
    end

    # Only allow a list of trusted parameters through.
    def empresa_params
      params.require(:empresa).permit(
        :rut, :razon_social, :administrador, :email_administrador, 
        :contacto, :telefono, :informacion_comercial, :principal_usuaria, :logo,
        :activa_devolucion, :verificacion_datos, :coordinacion_apt
        # :website NO se persiste (honeypot)
      )
    end
end
