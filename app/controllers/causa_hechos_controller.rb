class CausaHechosController < ApplicationController
  before_action :set_causa_hecho, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /causa_hechos or /causa_hechos.json
  def index
    @causa_hechos = CausaHecho.all
  end

  # GET /causa_hechos/1 or /causa_hechos/1.json
  def show
  end

  # GET /causa_hechos/new
  def new
    @causa_hecho = CausaHecho.new
  end

  # GET /causa_hechos/1/edit
  def edit
  end

  # POST /causa_hechos or /causa_hechos.json
  def create
    @causa_hecho = CausaHecho.new(causa_hecho_params)

    respond_to do |format|
      if @causa_hecho.save
        format.html { redirect_to @causa_hecho, notice: "Causa hecho was successfully created." }
        format.json { render :show, status: :created, location: @causa_hecho }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @causa_hecho.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /causa_hechos/1 or /causa_hechos/1.json
  def update
    respond_to do |format|
      if @causa_hecho.update(causa_hecho_params)
        format.html { redirect_to @causa_hecho, notice: "Causa hecho was successfully updated." }
        format.json { render :show, status: :ok, location: @causa_hecho }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @causa_hecho.errors, status: :unprocessable_entity }
      end
    end
  end

  def arriba
    owner = @objeto.owner
    anterior = @objeto.anterior
    @objeto.orden -= 1
    @objeto.save
    anterior.orden += 1
    anterior.save

    redirect_to @objeto.redireccion
  end

  def abajo
    owner = @objeto.owner
    siguiente = @objeto.siguiente
    @objeto.orden += 1
    @objeto.save
    siguiente.orden -= 1
    siguiente.save

    redirect_to @objeto.redireccion
  end

  # DELETE /causa_hechos/1 or /causa_hechos/1.json
  def destroy
    @causa_hecho.destroy
    respond_to do |format|
      format.html { redirect_to causa_hechos_url, notice: "Causa hecho was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def reordenar
      @objeto.list.each_with_index do |val, index|
        unless val.orden == index + 1
          val.orden = index + 1
          val.save
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_causa_hecho
      @causa_hecho = CausaHecho.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def causa_hecho_params
      params.require(:causa_hecho).permit(:causa_id, :hecho_id, :orden, :st_contestación, :st_preparatoria, :st_juicio)
    end
end
