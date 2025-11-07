class Repositorios::ActMetadatasController < ApplicationController
  before_action :set_act_metadata, only: %i[ show edit update destroy ]

  # GET /act_metadatas or /act_metadatas.json
  def index
    @act_metadatas = ActMetadata.all
  end

  # GET /act_metadatas/1 or /act_metadatas/1.json
  def show
  end

  # GET /act_metadatas/new
  def new
    @act_metadata = ActMetadata.new
  end

  # GET /act_metadatas/1/edit
  def edit
  end

  # POST /act_metadatas or /act_metadatas.json
  def create
    @act_metadata = ActMetadata.new(act_metadata_params)

    respond_to do |format|
      if @act_metadata.save
        format.html { redirect_to @act_metadata, notice: "Act metadata was successfully created." }
        format.json { render :show, status: :created, location: @act_metadata }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @act_metadata.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /act_metadatas/1 or /act_metadatas/1.json
  def update
    respond_to do |format|
      if @act_metadata.update(act_metadata_params)
        format.html { redirect_to @act_metadata, notice: "Act metadata was successfully updated." }
        format.json { render :show, status: :ok, location: @act_metadata }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @act_metadata.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /act_metadatas/1 or /act_metadatas/1.json
  def destroy
    @act_metadata.destroy!

    respond_to do |format|
      format.html { redirect_to act_metadatas_path, status: :see_other, notice: "Act metadata was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_act_metadata
      @act_metadata = ActMetadata.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def act_metadata_params
      params.expect(act_metadata: [ :act_metadata ])
    end
end
