class CausasController < ApplicationController
  before_action :set_causa, only: %i[ show edit update destroy cambio_estado ]

  include Tarifas

  # GET /causas or /causas.json
  def index
    @coleccion = Causa.all
  end

  # GET /causas/1 or /causas/1.json
  def show

    init_tab(['Documentos y enlaces', 'Facturación'], params[:tab])
    @options = { 'tab' => @tab }

    @coleccion = {}

    if @tab == 'Documentos y enlaces'
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

  # GET /causas/new
  def new
    modelo_causa = StModelo.find_by(st_modelo: 'Causa')
    @objeto = Causa.new(estado: modelo_causa.primer_estado.st_estado)
  end

  # GET /causas/1/edit
  def edit
  end

  # POST /causas or /causas.json
  def create
    @objeto = Causa.new(causa_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Causa was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /causas/1 or /causas/1.json
  def update
    respond_to do |format|
      if @objeto.update(causa_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Causa was successfully updated." }
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

  # DELETE /causas/1 or /causas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Causa was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_causa
      @objeto = Causa.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/st_bandejas?m=Causa&e=#{@objeto.estado}"
    end

    # Only allow a list of trusted parameters through.
    def causa_params
      params.require(:causa).permit(:causa, :identificador, :cliente_id, :estado, :tipo)
    end
end
