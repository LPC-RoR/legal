class Tarifas::TarHorasController < ApplicationController
  before_action :set_tar_hora, only: %i[ show edit update destroy asigna desasigna ]

  # GET /tar_horas or /tar_horas.json
  def index
  end

  # GET /tar_horas/1 or /tar_horas/1.json
  def show
  end

  # GET /tar_horas/new
  def new
    owner_class = (params[:class_name].blank? ? nil : params[:class_name])
    owner_id    = (params[:objeto_id].blank? ? nil : params[:objeto_id])
    @objeto = TarHora.new(owner_class: owner_class, owner_id: owner_id)
  end

  # GET /tar_horas/1/edit
  def edit
  end

  # POST /tar_horas or /tar_horas.json
  def create
    @objeto = TarHora.new(tar_hora_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar hora was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_horas/1 or /tar_horas/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_hora_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar hora was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def asigna
    # Asigna una tarifa a una CAUSA o COONSULTORÍA

    objeto = params[:class_name].constantize.find(params[:objeto_id])
    @objeto.send(params[:class_name].tableize) << objeto

    redirect_to "/#{params[:class_name].downcase.pluralize}/#{objeto.id}?html_options[menu]=Tarifas"

  end

  def desasigna
    # DesAsigna una tarifa a una CAUSA o COONSULTORÍA

    objeto = params[:class_name].constantize.find(params[:objeto_id])
    @objeto.send(params[:class_name].tableize).delete(objeto)

    redirect_to "/#{params[:class_name].downcase.pluralize}/#{objeto.id}?html_options[menu]=Tarifas"

  end

  # DELETE /tar_horas/1 or /tar_horas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tar hora was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_hora
      @objeto = TarHora.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.padre.blank? ? tar_tarifas_path : "/clientes/#{@objeto.padre.id}?html_options[menu]=Tarifas+y+servicios"
    end

    # Only allow a list of trusted parameters through.
    def tar_hora_params
      params.require(:tar_hora).permit(:tar_hora, :moneda, :valor, :owner_class, :owner_id)
    end
end
