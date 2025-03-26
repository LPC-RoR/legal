class Ayuda::HlpAyudasController < ApplicationController
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
    @objeto = HlpAyuda.new
  end

  # GET /hlp_ayudas/1/edit
  def edit
  end

  # POST /hlp_ayudas or /hlp_ayudas.json
  def create
    @objeto = HlpAyuda.new(hlp_ayuda_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Ayuda fue exitósamente creada." }
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
        format.html { redirect_to @objeto, notice: "Ayuda fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hlp_ayudas/1 or /hlp_ayudas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to hlp_ayudas_path, status: :see_other, notice: "Ayuda fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hlp_ayuda
      @objeto = HlpAyuda.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def hlp_ayuda_params
      params.expect(hlp_ayuda: [ :ownr_type, :ownr_id, :hlp_ayuda, :texto, :referencia ])
    end
end
