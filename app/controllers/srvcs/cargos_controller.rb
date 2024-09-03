class Srvcs::CargosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_cargo, only: %i[ show edit update destroy ]

  # GET /cargos or /cargos.json
  def index
    @age_usuarios = AgeUsuario.no_ownr
    @modelo = StModelo.get_model('Cargo')

    @estados = @modelo.blank? ? [] : @modelo.stts_arry
    @tipos = ['Mensuales', 'Cargos']

    @estado = std('asesorias', params[:e], params[:t])
    @tipo = typ('asesorias', params[:e], params[:t])
    @path = "/cargos?"

    unless @tipo.blank?
      tipo = TipoCargo.typ(@tipo.singularize)
      coleccion = Cargo.typ(tipo.id)
    end
    unless @estado.blank?
      coleccion = Cargo.std(@estado)
    end
    set_tabla('cargos', coleccion, true)

  end

  # GET /cargos/1 or /cargos/1.json
  def show
  end

  # GET /cargos/new
  def new
    modelo_cargo = StModelo.find_by(st_modelo: 'Cargo')
    @objeto = Cargo.new(estado: modelo_cargo.primer_estado.st_estado)
  end

  # GET /cargos/1/edit
  def edit
  end

  # POST /cargos or /cargos.json
  def create
    @objeto = Cargo.new(cargo_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Cargo fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cargos/1 or /cargos/1.json
  def update
    respond_to do |format|
      if @objeto.update(cargo_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Cargo fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cargos/1 or /cargos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Cargo fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cargo
      @objeto = Cargo.find(params[:id])
    end

    def set_redireccion
      @redireccion = cargos_path
    end

    # Only allow a list of trusted parameters through.
    def cargo_params
      params.require(:cargo).permit(:tipo_cargo_id, :cliente_id, :cargo, :detalle, :fecha, :fecha_uf, :moneda, :monto, :dia_cargo, :estado)
    end
end
