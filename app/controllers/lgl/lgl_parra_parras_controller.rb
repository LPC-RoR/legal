class Lgl::LglParraParrasController < ApplicationController
  before_action :set_lgl_parra_parra, only: %i[ show edit update destroy ]

  # GET /lgl_parra_parras or /lgl_parra_parras.json
  def index
    @lgl_parra_parras = LglParraParra.all
  end

  # GET /lgl_parra_parras/1 or /lgl_parra_parras/1.json
  def show
  end

  # GET /lgl_parra_parras/new
  def new
    @lgl_parra_parra = LglParraParra.new
  end

  # GET /lgl_parra_parras/1/edit
  def edit
  end

  # POST /lgl_parra_parras or /lgl_parra_parras.json
  def create
    @lgl_parra_parra = LglParraParra.new(lgl_parra_parra_params)

    respond_to do |format|
      if @lgl_parra_parra.save
        format.html { redirect_to lgl_parra_parra_url(@lgl_parra_parra), notice: "Lgl parra parra was successfully created." }
        format.json { render :show, status: :created, location: @lgl_parra_parra }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lgl_parra_parra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_parra_parras/1 or /lgl_parra_parras/1.json
  def update
    respond_to do |format|
      if @lgl_parra_parra.update(lgl_parra_parra_params)
        format.html { redirect_to lgl_parra_parra_url(@lgl_parra_parra), notice: "Lgl parra parra was successfully updated." }
        format.json { render :show, status: :ok, location: @lgl_parra_parra }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lgl_parra_parra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgl_parra_parras/1 or /lgl_parra_parras/1.json
  def destroy
    @lgl_parra_parra.destroy!

    respond_to do |format|
      format.html { redirect_to lgl_parra_parras_url, notice: "Lgl parra parra was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_parra_parra
      @lgl_parra_parra = LglParraParra.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lgl_parra_parra_params
      params.require(:lgl_parra_parra).permit(:child_id, :parent_id)
    end
end
