class ValoresController < ApplicationController
  before_action :set_valor, only: %i[ show edit update destroy ]

  # GET /valores or /valores.json
  def index
    @coleccion = Valor.all
  end

  # GET /valores/1 or /valores/1.json
  def show
  end

  # GET /valores/new
  def new
    @objeto = Valor.new
  end

  # GET /valores/1/edit
  def edit
  end

  # POST /valores or /valores.json
  def create
    @objeto = Valor.new(valor_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Valor fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /valores/1 or /valores/1.json
  def update
    respond_to do |format|
      if @objeto.update(valor_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Valor fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /valores/1 or /valores/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Valor fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_valor
      @objeto = Valor.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.owner
    end

    # Only allow a list of trusted parameters through.
    def valor_params
      params.require(:valor).permit(:owner_class, :owner_id, :variable_id, :c_string, :c_text, :c_fecha, :c_numero)
    end
end
