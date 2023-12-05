class VariablesController < ApplicationController
  before_action :set_variable, only: %i[ show edit update destroy ]

  # GET /variables or /variables.json
  def index
    @coleccion = Variable.all
  end

  # GET /variables/1 or /variables/1.json
  def show
  end

  # GET /variables/new
  def new
    @objeto = Variable.new(tipo_causa_id: params[:tipo_causa_id])
  end

  # GET /variables/1/edit
  def edit
  end

  # POST /variables or /variables.json
  def create
    @objeto = Variable.new(variable_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Variable fue exitósamente creada." }
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
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Variable fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variables/1 or /variables/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Variable fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable
      @objeto = Variable.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.tipo_causa
    end

    # Only allow a list of trusted parameters through.
    def variable_params
      params.require(:variable).permit(:tipo, :variable, :tipo_causa_id, :control)
    end
end