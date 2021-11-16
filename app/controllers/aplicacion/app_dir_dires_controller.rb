class AppDirDiresController < ApplicationController
  before_action :set_app_dir_dir, only: %i[ show edit update destroy ]

  # GET /app_dir_dires or /app_dir_dires.json
  def index
    @app_dir_dires = AppDirDir.all
  end

  # GET /app_dir_dires/1 or /app_dir_dires/1.json
  def show
  end

  # GET /app_dir_dires/new
  def new
    @app_dir_dir = AppDirDir.new
  end

  # GET /app_dir_dires/1/edit
  def edit
  end

  # POST /app_dir_dires or /app_dir_dires.json
  def create
    @app_dir_dir = AppDirDir.new(app_dir_dir_params)

    respond_to do |format|
      if @app_dir_dir.save
        format.html { redirect_to @app_dir_dir, notice: "App dir dir was successfully created." }
        format.json { render :show, status: :created, location: @app_dir_dir }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app_dir_dir.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_dir_dires/1 or /app_dir_dires/1.json
  def update
    respond_to do |format|
      if @app_dir_dir.update(app_dir_dir_params)
        format.html { redirect_to @app_dir_dir, notice: "App dir dir was successfully updated." }
        format.json { render :show, status: :ok, location: @app_dir_dir }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app_dir_dir.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_dir_dires/1 or /app_dir_dires/1.json
  def destroy
    @app_dir_dir.destroy
    respond_to do |format|
      format.html { redirect_to app_dir_dires_url, notice: "App dir dir was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_dir_dir
      @app_dir_dir = AppDirDir.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_dir_dir_params
      params.require(:app_dir_dir).permit(:parent_id, :child_id)
    end
end
