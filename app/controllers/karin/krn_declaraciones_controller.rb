class Karin::KrnDeclaracionesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_declaracion, only: %i[ show edit update destroy swtch migrar ]
  before_action :set_bck_rdrccn

  # GET /krn_declaraciones or /krn_declaraciones.json
  def index
    @coleccion = KrnDeclaracion.all
  end

  # GET /krn_declaraciones/1 or /krn_declaraciones/1.json
  def show
  end

  # GET /krn_declaraciones/new
  def new
    ownr = params[:oclss].constantize.find(params[:oid])
    dnnc = ownr.class.name == 'KrnTestigo' ? ownr.ownr.krn_denuncia : ownr.krn_denuncia
    invstgdr = dnnc.krn_investigadores.last

    @objeto = ownr.krn_declaraciones.new(krn_denuncia_id: dnnc.id, krn_investigador_id: invstgdr.id)
  end

  # GET /krn_declaraciones/1/edit
  def edit
  end

  # POST /krn_declaraciones or /krn_declaraciones.json
  def create
    @objeto = KrnDeclaracion.new(krn_declaracion_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to params[:bck_rdrccn], notice: "Declaración fue exitosamente creada." }
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
        format.html { redirect_to params[:bck_rdrccn], notice: "Declaración fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def migrar
    if @objeto.krn_denuncia.krn_investigadores.count == 2
      @objeto.krn_investigador_id = @objeto.krn_denuncia.krn_investigadores.last.id
      @objeto.save
    end

    redirect_to params[:bck_rdrccn]
  end

  # DELETE /krn_declaraciones/1 or /krn_declaraciones/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @bck_rdrccn, notice: "Declaración fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_declaracion
      @objeto = KrnDeclaracion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_declaracion_params
      params.require(:krn_declaracion).permit(:krn_denuncia_id, :krn_investigador_id, :ownr_type, :ownr_id, :fecha, :archivo)
    end
end
