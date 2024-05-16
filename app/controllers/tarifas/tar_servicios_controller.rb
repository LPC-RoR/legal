class Tarifas::TarServiciosController < ApplicationController
  before_action :set_tar_servicio, only: %i[ show edit update destroy ]

  # GET /tar_servicios or /tar_servicios.json
  def index
  end

  # GET /tar_servicios/1 or /tar_servicios/1.json
  def show
    set_tabla('asesorias', @objeto.asesorias.order(created_at: :desc), false)
  end

  # GET /tar_servicios/new
  def new
    @objeto = TarServicio.new(owner_class: params[:class_name], owner_id: params[:objeto_id], estado: 'ingreso')
  end

  # GET /tar_servicios/1/edit
  def edit
  end

  # POST /tar_servicios or /tar_servicios.json
  def create
    @objeto = TarServicio.new(tar_servicio_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tarifa fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_servicios/1 or /tar_servicios/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_servicio_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tarifa fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_servicios/1 or /tar_servicios/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tarifa fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_servicio
      @objeto = TarServicio.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.padre.blank? ? tabla_path(@objeto) : "/clientes/#{@objeto.padre.id}?html_options[menu]=Tarifas"
    end

    # Only allow a list of trusted parameters through.
    def tar_servicio_params
      params.require(:tar_servicio).permit(:codigo, :descripcion, :detalle, :tipo, :moneda, :monto, :owner_class, :owner_id, :estado)
    end
end
