class RegistrosController < ApplicationController
  before_action :set_registro, only: %i[ show edit update destroy reporta_registro excluye_registro]

  # GET /registros or /registros.json
  def index
    @coleccion = Registro.all
  end

  # GET /registros/1 or /registros/1.json
  def show
  end

  # GET /registros/new
  def new
    owner_class = (params[:class_name].blank? ? nil : params[:class_name])
    owner_id    = (params[:objeto_id].blank? ? nil : params[:objeto_id])
    @objeto = Registro.new(owner_class: owner_class, owner_id: owner_id, estado: 'ingreso')
  end

  # GET /registros/1/edit
  def edit
  end

  # POST /registros or /registros.json
  def create
    @objeto = Registro.new(registro_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Registro was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registros/1 or /registros/1.json
  def update
    respond_to do |format|
      if @objeto.update(registro_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Registro was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def reporta_registro
    reportes = @objeto.padre.reportes
    reportes_periodo = reportes.blank? ? nil : reportes.where(annio: @objeto.fecha.year, mes: @objeto.fecha.month)
    reporte = reportes_periodo.blank? ? nil : reportes_periodo.last

    reporte = RegReporte.build(owner_class: @objeto.owner_class, owner_id: @objeto_id, annio: @objeto.fecha.annio, mes: @objeto.fecha.month) if reporte.blank?

    reporte.registros << @objeto
    @objeto.estado = 'reportado'
    @objeto.save

    redirect_to reporte
  end

  def excluye_registro
    objeto_base = params[:class_name].constantize.find(params[:objeto_id])
    @objeto.estado = 'ingreso'
    @objeto.reg_reporte_id = nil
    @objeto.save

    redirect_to objeto_base
  end

  # DELETE /registros/1 or /registros/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Registro was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registro
      @objeto = Registro.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/#{@objeto.padre.class.name.downcase.pluralize}/#{@objeto.padre.id}?html_options[tab]=Registro"
    end

    # Only allow a list of trusted parameters through.
    def registro_params
      params.require(:registro).permit(:owner_class, :owner_id, :fecha, :tipo, :detalle, :nota, :duracion, :descuento, :razon_descuento, :estado)
    end
end
