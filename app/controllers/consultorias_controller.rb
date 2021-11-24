class ConsultoriasController < ApplicationController
  before_action :set_consultoria, only: %i[ show edit update destroy cambio_estado ]

  include Tarifas

  # GET /consultorias or /consultorias.json
  def index
    @coleccion = Consultoria.all
  end

  # GET /consultorias/1 or /consultorias/1.json
  def show

    @array_tarifa = tarifa_array(@objeto) if @objeto.tar_tarifa.present?

    @coleccion = {}

    @coleccion['tar_valores'] = @objeto.valores
    @coleccion['tar_facturaciones'] = @objeto.facturaciones

    AppRepo.create(repositorio: @objeto.consultoria, owner_class: 'Consultoria', owner_id: @objeto.id) if @objeto.repo.blank?

    @coleccion['app_directorios'] = @objeto.repo.directorios
    @coleccion['app_documentos'] = @objeto.repo.documentos

  end

  # GET /consultorias/new
  def new
    modelo_causa = StModelo.find_by(st_modelo: 'Causa')
    @objeto = Consultoria.new(estado: modelo_causa.primer_estado.st_estado)
  end

  # GET /consultorias/1/edit
  def edit
  end

  # POST /consultorias or /consultorias.json
  def create
    @objeto = Consultoria.new(consultoria_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Consultoria was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consultorias/1 or /consultorias/1.json
  def update
    respond_to do |format|
      if @objeto.update(consultoria_params)
        format.html { redirect_to @objeto, notice: "Consultoria was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def cambio_estado
    StLog.create(perfil_id: current_usuario.id, class_name: @objeto.class.name, objeto_id: @objeto.id, e_origen: @objeto.estado, e_destino: params[:st])

    @objeto.estado = params[:st]
    @objeto.save

    redirect_to "/st_bandejas?m=#{@objeto.class.name}&e=#{@objeto.estado}"
  end

  # DELETE /consultorias/1 or /consultorias/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to consultorias_url, notice: "Consultoria was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consultoria
      @objeto = Consultoria.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def consultoria_params
      params.require(:consultoria).permit(:consultoria, :cliente_id, :estado, :tar_tarea_id)
    end
end
