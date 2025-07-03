class Dts::VarClisController < ApplicationController
  before_action :set_var_cli, only: %i[ show edit update destroy ]

  # GET /var_clis or /var_clis.json
  def index
    @coleccion = VarCli.all
  end

  # GET /var_clis/1 or /var_clis/1.json
  def show
  end

  # GET /var_clis/new
  def new
    @objeto = VarCli.new
  end

  # GET /var_clis/1/edit
  def edit
  end

  # POST /var_clis or /var_clis.json
  def create
    @objeto = VarCli.new(var_cli_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Var cli was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /var_clis/1 or /var_clis/1.json
  def update
    respond_to do |format|
      if @objeto.update(var_cli_params)
        format.html { redirect_to @objeto, notice: "Var cli was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /var_clis/1 or /var_clis/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Variable fue exitosamente liberada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_var_cli
      @objeto = VarCli.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/clientes/#{@objeto.cliente.id}?html_options[menu]=Causas"
    end

    # Only allow a list of trusted parameters through.
    def var_cli_params
      params.require(:var_cli).permit(:variable_id, :cliente_id)
    end
end
