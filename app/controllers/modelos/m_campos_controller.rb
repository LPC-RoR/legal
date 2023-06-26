class Modelos::MCamposController < ApplicationController
  before_action :set_m_campo, only: %i[ show edit update destroy ]

  # GET /m_campos or /m_campos.json
  def index
    @m_campos = MCampo.all
  end

  # GET /m_campos/1 or /m_campos/1.json
  def show
  end

  # GET /m_campos/new
  def new
    @m_campo = MCampo.new
  end

  # GET /m_campos/1/edit
  def edit
  end

  # POST /m_campos or /m_campos.json
  def create
    @m_campo = MCampo.new(m_campo_params)

    respond_to do |format|
      if @m_campo.save
        format.html { redirect_to @m_campo, notice: "M campo was successfully created." }
        format.json { render :show, status: :created, location: @m_campo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @m_campo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_campos/1 or /m_campos/1.json
  def update
    respond_to do |format|
      if @m_campo.update(m_campo_params)
        format.html { redirect_to @m_campo, notice: "M campo was successfully updated." }
        format.json { render :show, status: :ok, location: @m_campo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @m_campo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /m_campos/1 or /m_campos/1.json
  def destroy
    @m_campo.destroy
    respond_to do |format|
      format.html { redirect_to m_campos_url, notice: "M campo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_campo
      @m_campo = MCampo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def m_campo_params
      params.require(:m_campo).permit(:m_campo, :valor, :m_conciliacion_id)
    end
end
