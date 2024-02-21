class Estados::StBandejasController < ApplicationController
  before_action :set_st_bandeja, only: %i[ show edit update destroy ]

  # GET /st_bandejas or /st_bandejas.json
  def index
    # Manejo del sidebar
    if perfil_activo.present?

      unless StModelo.all.empty?
        primer_modelo = StModelo.all.order(:st_modelo).first
        @m = params[:m].blank? ? primer_modelo.st_modelo : params[:m]
        if StModelo.find_by(st_modelo: @m).blank?
          @e = nil
        else
          @e = (params[:e].blank? ? primer_modelo.primer_estado.st_estado : params[:e])
        end
      else
        @m = nil
        @e = nil
      end

      # Despliegue
      set_tabla(@m.tableize, st_colecciones(@m, @e), @m.constantize.where(estado: @e).count > 25)

      @bandejas = admin? ? StModelo.all.order(:st_modelo) : AppNomina.find_by(email: perfil_activo.email).st_perfil_modelos.order(:st_perfil_modelo))

      #inicializa despliegue
      unless @bandejas.empty?
        @m = params[:m].blank? ? @bandejas.first.modelo : params[:m]
        @e = (params[:e].blank? ? @bandejas.first.estados.first.estado : params[:e])
      else
        @m = nil
        @e = nil
      end

    end

  end

  # GET /st_bandejas/1 or /st_bandejas/1.json
  def show
  end

  # GET /st_bandejas/new
  def new
    @objeto = StBandeja.new
  end

  # GET /st_bandejas/1/edit
  def edit
  end

  # POST /st_bandejas or /st_bandejas.json
  def create
    @objeto = StBandeja.new(st_bandeja_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "St bandeja was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /st_bandejas/1 or /st_bandejas/1.json
  def update
    respond_to do |format|
      if @objeto.update(st_bandeja_params)
        format.html { redirect_to @objeto, notice: "St bandeja was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /st_bandejas/1 or /st_bandejas/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to st_bandejas_url, notice: "St bandeja was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_st_bandeja
      @objeto = StBandeja.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def st_bandeja_params
      params.fetch(:st_bandeja, {})
    end
end
