class Karin::KrnDeclaracionesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_declaracion, only: %i[ show edit update destroy ]

  # GET /krn_declaraciones or /krn_declaraciones.json
  def index
    @coleccion = KrnDeclaracion.all
  end

  # GET /krn_declaraciones/1 or /krn_declaraciones/1.json
  def show
  end

  # GET /krn_declaraciones/new
  def new
    @objeto = KrnDeclaracion.new
  end

  def nueva
    ownr = params[:oclss].constantize.find(params[:oid])
    dnnc = ownr.class.name == 'KrnTestigo' ? ownr.ownr.krn_denuncia : ownr.krn_denuncia
    invstgdr = dnnc.krn_investigador

    ownr.krn_declaraciones.create(krn_denuncia_id: dnnc.id, krn_investigador_id: invstgdr.id, fecha: params_to_date(params, 'fecha'))

    redirect_to ownr
  end

  # GET /krn_declaraciones/1/edit
  def edit
  end

  # POST /krn_declaraciones or /krn_declaraciones.json
  def create
    @objeto = KrnDeclaracion.new(krn_declaracion_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Declaración fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_declaraciones/1 or /krn_declaraciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_declaracion_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Declaración fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_declaraciones/1 or /krn_declaraciones/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Declaración fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_declaracion
      @objeto = KrnDeclaracion.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.ownr
    end

    # Only allow a list of trusted parameters through.
    def krn_declaracion_params
      params.require(:krn_declaracion).permit(:krn_denuncia_id, :ownr_type, :ownr_id, :fecha, :archivo)
    end
end
