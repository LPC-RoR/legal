class Csc::EstadosController < ApplicationController
  before_action :set_estado, only: %i[ show edit update destroy ]

  # GET /estados or /estados.json
  def index
    @coleccion = Estado.all
  end

  # GET /estados/1 or /estados/1.json
  def show
  end

  # GET /estados/new
  def new
    @objeto = Estado.new
  end

  def nuevo
    causa = Causa.find(params[:cid])
    f_prms = params[:nuevo_estado]
      unless f_prms[:estado].blank? or causa.blank?
      annio = f_prms['fecha(1i)'].blank? ? hoy.year : f_prms['fecha(1i)']
      mes = f_prms['fecha(2i)'].blank? ? hoy.month : f_prms['fecha(2i)']
      dia = f_prms['fecha(3i)']
      fecha = Time.zone.parse("#{dia}-#{mes}-#{annio} 00:00")
      causa.estados.create(fecha: fecha, link: f_prms[:link], estado: f_prms[:estado])
    end

    redirect_to causas_path    
  end

  # GET /estados/1/edit
  def edit
  end

  # POST /estados or /estados.json
  def create
    @objeto = Estado.new(estado_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Estado was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /estados/1 or /estados/1.json
  def update
    respond_to do |format|
      if @objeto.update(estado_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Estado was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estados/1 or /estados/1.json
  def destroy
    set_redireccion
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Estado was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_estado
      @objeto = Estado.find(params[:id])
    end

    def set_redireccion
      @redireccion = causas_path
    end

    # Only allow a list of trusted parameters through.
    def estado_params
      params.require(:estado).permit(:causa_id, :link, :estado, :urgente)
    end
end
