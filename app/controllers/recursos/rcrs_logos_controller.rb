class Recursos::RcrsLogosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_rcrs_logo, only: %i[ show edit update destroy ]

  # GET /rcrs_logos or /rcrs_logos.json
  def index
    @coleccion = RcrsLogo.all
  end

  # GET /rcrs_logos/1 or /rcrs_logos/1.json
  def show
  end

  # GET /rcrs_logos/new
  def new
    @objeto = RcrsLogo.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  # GET /rcrs_logos/1/edit
  def edit
  end

  # POST /rcrs_logos or /rcrs_logos.json
  def create
    @objeto = RcrsLogo.new(rcrs_logo_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Logo fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rcrs_logos/1 or /rcrs_logos/1.json
  def update
    respond_to do |format|
      if @objeto.update(rcrs_logo_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Logo fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rcrs_logos/1 or /rcrs_logos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, status: :see_other, notice: "Logo fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rcrs_logo
      @objeto = RcrsLogo.find(params.expect(:id))
    end

    def get_rdrccn
      @rdrccn = "/cuentas/#{@objeto.ownr.class.name[0].downcase}_#{@objeto.ownr.id}/dnncs"
    end

    # Only allow a list of trusted parameters through.
    def rcrs_logo_params
      params.expect(rcrs_logo: [ :ownr_type, :ownr_id, :logo ])
    end
end
