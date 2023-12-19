class CausaDocsController < ApplicationController
  before_action :set_causa_doc, only: %i[ show edit update destroy ]

  # GET /causa_docs or /causa_docs.json
  def index
    @causa_docs = CausaDoc.all
  end

  # GET /causa_docs/1 or /causa_docs/1.json
  def show
  end

  # GET /causa_docs/new
  def new
    @causa_doc = CausaDoc.new
  end

  # GET /causa_docs/1/edit
  def edit
  end

  # POST /causa_docs or /causa_docs.json
  def create
    @causa_doc = CausaDoc.new(causa_doc_params)

    respond_to do |format|
      if @causa_doc.save
        format.html { redirect_to @causa_doc, notice: "Causa doc was successfully created." }
        format.json { render :show, status: :created, location: @causa_doc }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @causa_doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /causa_docs/1 or /causa_docs/1.json
  def update
    respond_to do |format|
      if @causa_doc.update(causa_doc_params)
        format.html { redirect_to @causa_doc, notice: "Causa doc was successfully updated." }
        format.json { render :show, status: :ok, location: @causa_doc }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @causa_doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /causa_docs/1 or /causa_docs/1.json
  def destroy
    @causa_doc.destroy
    respond_to do |format|
      format.html { redirect_to causa_docs_url, notice: "Causa doc was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_causa_doc
      @causa_doc = CausaDoc.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def causa_doc_params
      params.require(:causa_doc).permit(:causa_id, :app_documento_id)
    end
end
