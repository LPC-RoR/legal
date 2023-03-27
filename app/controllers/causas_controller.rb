class CausasController < ApplicationController
  before_action :set_causa, only: %i[ show edit update destroy cambio_estado procesa_registros ]

  include Tarifas

  # GET /causas or /causas.json
  def index
    @coleccion = Causa.all
  end

  # GET /causas/1 or /causas/1.json
  def show

    init_tab( { menu: ['Facturacion', 'Documentos y enlaces', 'Registro', 'Reportes', 'Tarifas', 'Cuantía'] }, true )

    @coleccion = {}

    if @options[:menu] == 'Registro'
      @coleccion['registros'] = @objeto.registros
      @coleccion['registros'] = @coleccion['registros'].order(fecha: :desc) unless @coleccion['registros'].blank?
    elsif @options[:menu] == 'Reportes'
      @coleccion['reg_reportes'] = @objeto.reportes
      @coleccion['reg_reportes'] = @coleccion['reg_reportes'].order(annio: :desc, mes: :desc) unless @coleccion['reg_reportes'].blank?
    elsif @options[:menu] == 'Documentos y enlaces'
      AppRepo.create(repositorio: @objeto.causa, owner_class: 'Causa', owner_id: @objeto.id) if @objeto.repo.blank?

      @coleccion['app_directorios'] = @objeto.repo.directorios
      @coleccion['app_documentos'] = @objeto.repo.documentos

      @coleccion['app_enlaces'] = @objeto.enlaces.order(:descripcion)
    elsif @options[:menu] == 'Facturacion'
      @coleccion['tar_valor_cuantias'] = @objeto.valores_cuantia
      @coleccion['tar_valores'] = @objeto.valores
      @coleccion['tar_facturaciones'] = @objeto.facturaciones
    elsif @options[:menu] == 'Tarifas'
    elsif @options[:menu] == 'Cuantía'
      @coleccion['tar_valor_cuantias'] = @objeto.valores_cuantia
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

#    redirect_to "/st_bandejas?m=#{@objeto.class.name}&e=#{@objeto.estado}"
    redirect_to "/causas/#{@objeto.id}"
  end

  def procesa_registros
    registros_proceso = @objeto.registros.where(estado: 'ingreso')
    unless registros_proceso.empty?
      registros_proceso.each do |registro|
        reporte_mes = @objeto.reportes.where(annio: registro.fecha.year).find_by(mes: registro.fecha.month) unless @objeto.reportes.blank?
        reporte_mes = RegReporte.new(owner_class: 'Causa', owner_id: @objeto.id, annio: registro.fecha.year, mes: registro.fecha.month) if (reporte_mes.blank? or @objeto.reportes.empty?)
        reporte_mes.save

        registro.estado = 'reportado'
        registro.reg_reporte_id = reporte_mes.id
        registro.save
      end
    end

    redirect_to "/causas/#{@objeto.id}?html_options[tab]=Reportes"
    
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
      params.require(:causa).permit(:causa, :identificador, :cliente_id, :estado, :tipo_causa_id)
    end
end
