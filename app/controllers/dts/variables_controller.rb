class Dts::VariablesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_variable, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  include Orden

  # GET /variables or /variables.json
  def index
    set_tabla('variables', Variable.all.order(:orden), true)
  end

  # GET /variables/1 or /variables/1.json
  def show
  end

  # GET /variables/new
  def new
    ownr = params[:oclss].constantize.find(params[:oid])
    ownr_type = params[:oclss]
    ownr_id = params[:oid]
    orden = ownr.variables.count + 1
    @objeto = Variable.new(ownr_type: ownr_type, ownr_id: ownr_id, orden: orden)
  end

  # GET /variables/1/edit
  def edit
  end

  # POST /variables or /variables.json
  def create
    @objeto = Variable.new(variable_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Variable fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variables/1 or /variables/1.json
  def update
    respond_to do |format|
      if @objeto.update(variable_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Variable fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variables/1 or /variables/1.json
  def destroy
    get_rdrccn
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Variable fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable
      @objeto = Variable.find(params[:id])
    end

    def get_rdrccn
      case @objeto.ownr_type
      when 'Tarea'
        @rdrccn = @objeto.ownr.ctr_etapa.procedimiento
      end
    end

    # Only allow a list of trusted parameters through.
    def variable_params
      params.require(:variable).permit(:ownr_type, :ownr_id, :orden, :tipo, :variable, :control, :descripcion)
    end
end
