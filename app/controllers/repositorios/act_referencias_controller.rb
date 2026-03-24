class Repositorios::ActReferenciasController < ApplicationController
  before_action :set_act_referencia, only: %i[ show edit update destroy ]

  # GET /act_referencias or /act_referencias.json
  def index
    @act_referencias = ActReferencia.all
  end

  # GET /act_referencias/1 or /act_referencias/1.json
  def show
  end

  # GET /act_referencias/new
  def new
    @act_referencia = ActReferencia.new
  end

  # GET /act_referencias/1/edit
  def edit
  end

  # POST /act_referencias or /act_referencias.json
  def create
    @act_referencia = ActReferencia.new(act_referencia_params)

    respond_to do |format|
      if @act_referencia.save
        format.html { redirect_to @act_referencia, notice: "Act referencia was successfully created." }
        format.json { render :show, status: :created, location: @act_referencia }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @act_referencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /act_referencias/1 or /act_referencias/1.json
  def update
    respond_to do |format|
      if @act_referencia.update(act_referencia_params)
        format.html { redirect_to @act_referencia, notice: "Act referencia was successfully updated." }
        format.json { render :show, status: :ok, location: @act_referencia }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @act_referencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /act_referencias/1 or /act_referencias/1.json
  def destroy
    @act_referencia.destroy!

    respond_to do |format|
      format.html { redirect_to act_referencias_path, status: :see_other, notice: "Act referencia was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_act_referencia
      @act_referencia = ActReferencia.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def act_referencia_params
      params.expect(act_referencia: [ :act_archivo_id, :ref_type, :ref_id ])
    end
end
