class Ayuda::HlpAyudasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_hlp_ayuda, only: %i[ show edit update destroy ]

  # GET /hlp_ayudas or /hlp_ayudas.json
  def index
    @coleccion = HlpAyuda.all
  end

  # GET /hlp_ayudas/1 or /hlp_ayudas/1.json
  def show
  end

  # GET /hlp_ayudas/new
  def new
    @objeto = HlpAyuda.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  # GET /hlp_ayudas/1/edit
  def edit
  end

  # POST /hlp_ayudas or /hlp_ayudas.json
  def create
    @objeto = HlpAyuda.new(hlp_ayuda_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Ayuda fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hlp_ayudas/1 or /hlp_ayudas/1.json
  def update
    respond_to do |format|
      if @objeto.update(hlp_ayuda_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Ayuda fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hlp_ayudas/1 or /hlp_ayudas/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, status: :see_other, notice: "Ayuda fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hlp_ayuda
      @objeto = HlpAyuda.find(params.expect(:id))
    end

    def get_rdrccn
      @rdrccn = @objeto.ownr
    end

    # Only allow a list of trusted parameters through.
    def hlp_ayuda_params
      params.expect(hlp_ayuda: [ :ownr_type, :ownr_id, :hlp_ayuda, :texto, :referencia ])
    end
end
