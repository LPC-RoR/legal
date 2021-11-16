class ClientesController < ApplicationController
  before_action :set_cliente, only: %i[ show edit update destroy ]

  # GET /clientes or /clientes.json
  def index
    @coleccion = Cliente.all
  end

  # GET /clientes/1 or /clientes/1.json
  def show
    @coleccion = {}
    @coleccion['causas'] = @objeto.causas.order(:created_at)

    @repo = AppRepo.where(owner_class: 'Cliente').find_by(owner_id: @objeto.id)
    @repo = AppRepo.create(repositorio: @objeto.razon_social, owner_class: 'Cliente', owner_id: @objeto.id) if @repo.blank?

    @coleccion['app_directorios'] = @repo.directorios
    @coleccion['app_documentos'] = @repo.documentos
  end

  # GET /clientes/new
  def new
    @objeto = Cliente.new(estado: 'ingreso')
  end

  # GET /clientes/1/edit
  def edit
  end

  # POST /clientes or /clientes.json
  def create
    @objeto = Cliente.new(cliente_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Cliente was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clientes/1 or /clientes/1.json
  def update
    respond_to do |format|
      if @objeto.update(cliente_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Cliente was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clientes/1 or /clientes/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Cliente was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente
      @objeto = Cliente.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/st_bandejas?m=Cliente&e=ingreso" 
    end

    # Only allow a list of trusted parameters through.
    def cliente_params
      params.require(:cliente).permit(:razon_social, :rut, :estado)
    end
end
