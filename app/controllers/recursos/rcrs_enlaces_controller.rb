class Recursos::RcrsEnlacesController < ApplicationController
  before_action :set_rcrs_enlace, only: %i[ show edit update destroy ]

  layout 'addt'

  # GET /rcrs_enlaces or /rcrs_enlaces.json
  def index
    @enlaces_app  = RcrsEnlace.gnrl.dscrptn_ordr if current_usuario.admin?
    @enlaces_user = current_usuario.rcrs_enlaces.dscrptn_ordr
  end

  # GET /rcrs_enlaces/1 or /rcrs_enlaces/1.json
  def show
  end

  # GET /rcrs_enlaces/new
  def new
    ownr_type = [nil, ''].include?(params[:oclss]) ? nil : params[:oclss]
    @objeto = RcrsEnlace.new(ownr_type: ownr_type, ownr_id: params[:oid])
  end

  # GET /rcrs_enlaces/1/edit
  def edit
  end

  # POST /rcrs_enlaces or /rcrs_enlaces.json
  def create
    @objeto = RcrsEnlace.new(rcrs_enlace_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to rcrs_enlaces_path, notice: "Enlace fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rcrs_enlaces/1 or /rcrs_enlaces/1.json
  def update
    respond_to do |format|
      if @objeto.update(rcrs_enlace_params)
        format.html { redirect_to rcrs_enlaces_path, notice: "Enlace fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rcrs_enlaces/1 or /rcrs_enlaces/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to rcrs_enlaces_path, status: :see_other, notice: "Enlace fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rcrs_enlace
      @objeto = RcrsEnlace.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def rcrs_enlace_params
      params.expect(rcrs_enlace: [ :ownr_type, :ownr_id, :descripcion, :link, :blank ])
    end
end
