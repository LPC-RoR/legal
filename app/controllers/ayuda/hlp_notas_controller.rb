class Ayuda::HlpNotasController < ApplicationController
  before_action :set_hlp_nota, only: %i[ show edit update destroy ]

  # GET /hlp_notas or /hlp_notas.json
  def index
    @coleccion = HlpNota.all
  end

  # GET /hlp_notas/1 or /hlp_notas/1.json
  def show
  end

  # GET /hlp_notas/new
  def new
    @objeto = HlpNota.new
  end

  # GET /hlp_notas/1/edit
  def edit
  end

  # POST /hlp_notas or /hlp_notas.json
  def create
    @objeto = HlpNota.new(hlp_nota_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Nota fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hlp_notas/1 or /hlp_notas/1.json
  def update
    respond_to do |format|
      if @objeto.update(hlp_nota_params)
        format.html { redirect_to @objeto, notice: "Nota fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hlp_notas/1 or /hlp_notas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to hlp_notas_path, status: :see_other, notice: "Nota fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hlp_nota
      @objeto = HlpNota.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def hlp_nota_params
      params.expect(hlp_nota: [ :ownr_type, :ownr_id, :orden, :hlp_nota, :texto, :referencia ])
    end
end
