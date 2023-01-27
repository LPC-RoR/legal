class ConsultoriasController < ApplicationController
  before_action :set_consultoria, only: %i[ show edit update destroy cambio_estado ]

  include Tarifas

  # GET /consultorias or /consultorias.json
  def index
    @coleccion = Consultoria.all
  end

  # GET /consultorias/1 or /consultorias/1.json
  def show

    init_tab(['Registro', 'Documentos y enlaces', 'Facturación'], params[:tab])
    @options = { 'tab' => @tab }

    @coleccion = {}

    if @tab == 'Registro'
      @coleccion['registros'] = @objeto.registros
      @coleccion['registros'] = @coleccion['registros'].order(fecha: :desc) unless @coleccion['registros'].blank?
    elsif @tab == 'Documentos y enlaces'
      AppRepo.create(repositorio: @objeto.causa, owner_class: 'Causa', owner_id: @objeto.id) if @objeto.repo.blank?

      @coleccion['app_directorios'] = @objeto.repo.directorios
      @coleccion['app_documentos'] = @objeto.repo.documentos

      @coleccion['app_enlaces'] = @objeto.enlaces.order(:descripcion)
    elsif @tab == 'Facturación'
      @array_tarifa = tarifa_array(@objeto) if @objeto.tar_tarifa.present?

      @coleccion['tar_valores'] = @objeto.valores
      @coleccion['tar_facturaciones'] = @objeto.facturaciones
    end

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
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Consultoria was successfully created." }
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
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Consultoria was successfully updated." }
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

    redirect_to "/consultorias/#{@objeto.id}"
  end

  # DELETE /consultorias/1 or /consultorias/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Consultoria was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consultoria
      @objeto = Consultoria.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/st_bandejas?m=Consultoria&e=#{@objeto.estado}"
    end

    # Only allow a list of trusted parameters through.
    def consultoria_params
      params.require(:consultoria).permit(:consultoria, :cliente_id, :estado, :tar_tarea_id)
    end
end
