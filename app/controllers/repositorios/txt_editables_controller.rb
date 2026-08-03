class Repositorios::TxtEditablesController < ApplicationController
  include PdfGeneratable

  before_action :set_txt_editable, only: %i[ show edit update destroy cargar_pdf ]

  # GET /txt_editables or /txt_editables.json
  def index
    @clccn = TxtEditable.all
  end

  # GET /txt_editables/1 or /txt_editables/1.json
  def show
  end

  # GET /txt_editables/new
  def new
    code        = params[:cdg]
    cntxt_clss  = ClssTxt.context_class(code)
    @ownr       = params[:oclss].constantize.find(params[:oid])

    @objeto     = @ownr.txt_editables.build(codigo: code, titulo: cntxt_clss.nombre[code], cntxt_clss: cntxt_clss.to_s)
  end

  # GET /txt_editables/1/edit
  def edit
  end

  # POST /txt_editables or /txt_editables.json
  def create
    @objeto = TxtEditable.new(txt_editable_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to rdrccn_path, notice: "Texto editable fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /txt_editables/1 or /txt_editables/1.json
  def update
    respond_to do |format|
      if @objeto.update(txt_editable_params)
        format.html { redirect_to rdrccn_path, notice: "Texto editable fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /txt_editables/1 or /txt_editables/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to rdrccn_path, status: :see_other, notice: "Texto editable fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private


    # Use callbacks to share common setup or constraints between actions.
    def set_txt_editable
      @objeto = TxtEditable.find(params.expect(:id))
    end

    def rdrccn_path
      @objeto.cntxt_clss.constantize.rdrccn_path(@objeto)
    end

    # Only allow a list of trusted parameters through.
    def txt_editable_params
      params.expect(txt_editable: [ :ownr_type, :ownr_id, :codigo, :titulo, :contenido, :cntxt_clss ])
    end
end
