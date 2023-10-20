class Modelos::MModelosController < ApplicationController
  before_action :set_m_modelo, only: %i[ show edit update destroy ]

  # GET /m_modelos or /m_modelos.json
  def index
    if usuario_signed_in?
      # Repositorio de la plataforma
      general_sha1 = Digest::SHA1.hexdigest("Modelo de Negocios General")
      @modelo = MModelo.find_by(m_modelo: general_sha1)
      @modelo = MModelo.create(m_modelo: general_sha1) if @modelo.blank?

      init_tabla('m_cuentas', @modelo.m_cuentas.order(:m_cuentas), false)
      add_tabla('m_periodos', MPeriodo.all.order(clave: :desc), false)

      clase = params[:id].blank? ? 'p' : params[:id].split('_')[0]
      if clase == 'c'
        oid = params[:id].blank? ? @coleccion['m_cuentas'].first.id : params[:id].split('_')[1].to_i
        @objeto = MCuenta.find(oid)
        puts @objeto.blank?
        add_tabla('m_conciliaciones', @objeto.m_conciliaciones.order(created_at: :desc), false)
      else
        oid = params[:id].blank? ? @coleccion['m_periodos'].first.id : params[:id].split('_')[1].to_i
        @objeto = MPeriodo.find(oid)
        add_tabla('m_registros', @objeto.m_registros.order(fecha: :desc), false)

        facturas = TarFactura.where(clave: @objeto.clave)
        facturado = facturas.map { |fac| fac.monto_corregido }.sum
        abonos = @objeto.m_registros.any? ? @objeto.m_registros.where(cargo_abono: 'Abono').map {|reg| reg.monto}.sum : 0
        cargos = @objeto.m_registros.any? ? @objeto.m_registros.where(cargo_abono: 'Cargo').map {|reg| reg.monto}.sum : 0
        @totales = [['Facturado', facturado], ['Abonos', abonos], ['Cargos', -cargos]]
      end

    end
  end

  # GET /m_modelos/1 or /m_modelos/1.json
  def show
  end

  # GET /m_modelos/new
  def new
    @objeto = MModelo.new
  end

  # GET /m_modelos/1/edit
  def edit
  end

  # POST /m_modelos or /m_modelos.json
  def create
    @objeto = MModelo.new(m_modelo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Modelo fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_modelos/1 or /m_modelos/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_modelo_params)
        format.html { redirect_to @objeto, notice: "Modelo fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /m_modelos/1 or /m_modelos/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to m_modelos_url, notice: "Modelo fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_modelo
      @objeto = MModelo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def m_modelo_params
      params.require(:m_modelo).permit(:m_modelo, :ownr_class, :ownr_id)
    end
end
