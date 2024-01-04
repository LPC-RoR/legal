class CausaDocsController < ApplicationController
  before_action :set_causa_doc, only: %i[ show edit update destroy arriba abajo cambia_seleccion ]

  # GET /causa_docs or /causa_docs.json
  def index
    @coleccion = CausaDoc.all
  end

  # GET /causa_docs/1 or /causa_docs/1.json
  def show
  end

  # GET /causa_docs/new
  def new
    @objeto = CausaDoc.new
  end

  # GET /causa_docs/1/edit
  def edit
  end

  # POST /causa_docs or /causa_docs.json
  def create
    @objeto = CausaDoc.new(causa_doc_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Causa doc was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /causa_docs/1 or /causa_docs/1.json
  def update
    respond_to do |format|
      if @objeto.update(causa_doc_params)
        format.html { redirect_to @objeto, notice: "Causa doc was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def cambia_seleccion
    @objeto.seleccionado = ( @objeto.seleccionado ? false : true )
    @objeto.save

    redirect_to "/causas/#{@objeto.causa.id}?html_options[menu]=Hechos"
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

  # DELETE /causa_docs/1 or /causa_docs/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to causa_docs_url, notice: "Causa doc was successfully destroyed." }
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
    def set_causa_doc
      @objeto = CausaDoc.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def causa_doc_params
      params.require(:causa_doc).permit(:causa_id, :app_documento_id)
    end
end
