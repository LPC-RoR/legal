class Docs::DocCartolasController < ApplicationController
  before_action :set_doc_cartola, only: %i[ show edit update destroy ]

  layout 'addt'

  # GET /doc_cartolas or /doc_cartolas.json
  def index
    @clccn = DocCartola.includes(doc_cuenta: :doc_banco).with_attached_archivo
    puts "********************************************************************** index"
    puts @clccn.count
  end

  # GET /doc_cartolas/1 or /doc_cartolas/1.json
  def show
    @objeto = DocCartola.includes(doc_transacciones: :relacionable).find(params[:id])
  end

  # GET /doc_cartolas/new
  def new
    @objeto = DocCartola.new
  end

  # GET /doc_cartolas/1/edit
  def edit
  end

  # POST /doc_cartolas or /doc_cartolas.json
  def create
      uploaded_file = doc_cartola_params[:archivo]

      # Crear el blob de ActiveStorage manualmente (Rails 8 usa create_and_upload!)
      blob = ActiveStorage::Blob.create_and_upload!(
        io: uploaded_file.to_io,
        filename: uploaded_file.original_filename,
        content_type: uploaded_file.content_type
      )

      # Crear el registro DocCartola vacío
      @objeto = DocCartola.create!

      # Crear la attachment manualmente (sin validaciones del modelo)
      ActiveStorage::Attachment.create!(
        name: 'archivo',
        record_type: 'DocCartola',
        record_id: @objeto.id,
        blob_id: blob.id
      )

      # Procesar la cartola
      loader = CartolaLoader.new(@objeto)

      if loader.cargar!
        redirect_to doc_cartolas_path, notice: 'Cartola cargada exitosamente.'
      else
        @objeto.destroy
        @objeto = DocCartola.new
        flash.now[:alert] = "Error al procesar la cartola: #{loader.errores.join(', ')}"
        render :new, status: :unprocessable_content
      end
    rescue => e
      @objeto&.destroy
      @objeto = DocCartola.new
      flash.now[:alert] = "Error: #{e.message}"
      Rails.logger.error "DocCartolas#create ERROR: #{e.message}"
      Rails.logger.error e.backtrace.first(15).join("\n")
      render :new, status: :unprocessable_content
  end

  # PATCH/PUT /doc_cartolas/1 or /doc_cartolas/1.json
  def update
    respond_to do |format|
      if @objeto.update(doc_cartola_params)
        format.html { redirect_to @objeto, notice: "Doc cartola was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

    def reintentar_vinculacion
      @objeto = DocCartola.find(params[:id])
      
      no_vinculadas = @objeto.doc_transacciones.where(relacionable: nil).where.not(descripcion_rut: nil)
      
      vinculadas = 0
      no_vinculadas.each do |transaccion|
        transaccion.vincular!
        vinculadas += 1 if transaccion.reload.vinculada?
      end

      redirect_to @objeto, notice: "#{vinculadas} transacciones vinculadas exitosamente."
    end

  def verificar
    @objeto = DocCartola.find(params[:id])
    
    clccn = @objeto.doc_transacciones

    clccn.each do |doc|

      if doc.descripcion_rut
        puts "******************************** descripcion_rut"
        puts doc.descripcion_rut
        clnt = Cliente.find_by(rut: doc.descripcion_rut)
        if clnt
          puts "****************************** clnt"
          doc.relacionable = clnt
        else
          prvdr = Proveedor.find_by(rut: doc.descripcion_rut)
          if prvdr
            puts "****************************** prvdr"
            doc.relacionable = prvdr
          else
            trbjdr = Trabajador.find_by(rut: doc.descripcion_rut)
            doc.relacionable = trbjdr if trbjdr
          end
        end

        doc.save
      end
    end

    redirect_to @objeto, notice: 'Proceso terminado'
  end

# DELETE /doc_cartolas/1 or /doc_cartolas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to doc_cartolas_path, status: :see_other, notice: "Doc cartola was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doc_cartola
      @objeto = DocCartola.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
  def doc_cartola_params
    params.require(:doc_cartola).permit(:archivo)
  end
end
