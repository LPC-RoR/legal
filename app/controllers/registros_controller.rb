class RegistrosController < ApplicationController
  before_action :set_registro, only: %i[ show edit update destroy reporta_registro excluye_registro]

#  include Bandejas

  # GET /registros or /registros.json
  def index
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
    reporte = reportes.blank? ? nil : reportes.find_by(annio: @objeto.fecha.year, mes: @objeto.fecha.month)

    reporte = RegReporte.create(owner_class: @objeto.owner_class, owner_id: @objeto.owner_id, annio: @objeto.fecha.year, mes: @objeto.fecha.month, estado: 'ingreso') if reporte.blank?

    reporte.registros << @objeto
    @objeto.estado = 'reportado'
    @objeto.save

    redirect_to reporte
  end

  def excluye_registro
    objeto_base = params[:class_name].constantize.find(params[:objeto_id])
    unless @objeto.reg_reporte_id.blank?
      @objeto.estado = 'ingreso'
      @objeto.reg_reporte_id = nil
      @objeto.save
    end

    redirect_to "/#{objeto_base.owner.class.name.tableize}/#{objeto_base.owner.id}?html_options[menu]=Registro"
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
      @redireccion = "/#{@objeto.padre.class.name.tableize}/#{@objeto.padre.id}?html_options[menu]=Registro"
    end

    # Only allow a list of trusted parameters through.
    def registro_params
      params.require(:registro).permit(:owner_class, :owner_id, :fecha, :tipo, :detalle, :nota, :duracion, :descuento, :razon_descuento, :estado, :abogado, :horas, :minutos)
    end
end
