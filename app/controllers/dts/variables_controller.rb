class Dts::VariablesController < ApplicationController
  before_action :set_variable, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /variables or /variables.json
  def index
    set_tabla('variables', Variable.all.order(:orden), true)
  end

  # GET /variables/1 or /variables/1.json
  def show
  end

  # GET /variables/new
  def new
    tipo_causa = TipoCausa.find(params[:tipo_causa_id])
    @objeto = Variable.new(tipo_causa_id: params[:tipo_causa_id], orden: tipo_causa.variables.count + 1)
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

  def arriba
    owner = @objeto.owner
    anterior = @objeto.anterior
    @objeto.orden -= 1
    @objeto.save
    anterior.orden += 1
    anterior.save

    redirect_to @objeto.redireccion
  end

  def abajo
    owner = @objeto.owner
    siguiente = @objeto.siguiente
    @objeto.orden += 1
    @objeto.save
    siguiente.orden -= 1
    siguiente.save

    redirect_to @objeto.redireccion
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
    def reordenar
      @objeto.list.each_with_index do |val, index|
        unless val.orden == index + 1
          val.orden = index + 1
          val.save
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_variable
      @objeto = Variable.find(params[:id])
    end

    def set_redireccion
      @redireccion = variables_path
    end

    # Only allow a list of trusted parameters through.
    def variable_params
      params.require(:variable).permit(:tipo, :variable, :tipo_causa_id, :control, :orden)
    end
end
