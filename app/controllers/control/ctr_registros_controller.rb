class Control::CtrRegistrosController < ApplicationController
  before_action :set_ctr_registro, only: %i[ show edit update destroy ]
  after_action :get_rdrccn, only: %i[ create update destroy ]

  # GET /ctr_registros or /ctr_registros.json
  def index
    @coleccion = CtrRegistro.all
  end

  # GET /ctr_registros/1 or /ctr_registros/1.json
  def show
  end

  # GET /ctr_registros/new
  def new
    @objeto = CtrRegistro.new
  end

  # GET /ctr_registros/1/edit
  def edit
  end

  # POST /ctr_registros or /ctr_registros.json
  def create
    @objeto = CtrRegistro.new(ctr_registro_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Ctr registro was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ctr_registros/1 or /ctr_registros/1.json
  def update
    respond_to do |format|
      if @objeto.update(ctr_registro_params)
        format.html { redirect_to @objeto, notice: "Ctr registro was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ctr_registros/1 or /ctr_registros/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to ctr_registros_path, status: :see_other, notice: "Ctr registro was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ctr_registro
      @objeto = CtrRegistro.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def ctr_registro_params
      params.expect(ctr_registro: [ :tarea_id, :ctr_paso_id, :ownr_type, :ownr_id, :fecha, :glosa, :valor ])
    end
end
