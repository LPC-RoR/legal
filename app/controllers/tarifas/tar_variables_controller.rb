class Tarifas::TarVariablesController < ApplicationController
  before_action :set_tar_variable, only: %i[ show edit update destroy ]

  # GET /tar_variables or /tar_variables.json
  def index
    @coleccion = TarVariable.all
  end

  # GET /tar_variables/1 or /tar_variables/1.json
  def show
  end

  # GET /tar_variables/new
  def new
    @objeto = TarVariable.new
  end

  # GET /tar_variables/1/edit
  def edit
  end

  # POST /tar_variables or /tar_variables.json
  def create
    @objeto = TarVariable.new(tar_variable_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Tar variable was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_variables/1 or /tar_variables/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_variable_params)
        format.html { redirect_to @objeto, notice: "Tar variable was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_variables/1 or /tar_variables/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to tar_variables_url, notice: "Tar variable was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_variable
      @objeto = TarVariable.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tar_variable_params
      params.require(:tar_variable).permit(:variable, :owner_class, :owner_id, :porcentaje)
    end
end
