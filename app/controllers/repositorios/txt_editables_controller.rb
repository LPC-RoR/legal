class Repositorios::TxtEditablesController < ApplicationController
  include PdfGeneratable

  before_action :set_txt_editable, only: %i[ show edit update destroy generar_pdf ]

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

    @objeto     = @ownr.txt_editables.build(codigo: code, titulo: cntxt_clss.txt_name[code], cntxt_clss: cntxt_clss.to_s)
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

  # ============================================
  # GENERAR PDF DESDE TXT_EDITABLE
  # ============================================
  # @param codigo_pdf [String] Código del reporte a generar
  # @param id [Integer] ID del TxtEditable
  def generar_pdf
    codigo_pdf = params[:codigo_pdf]
    
    # Verificaciones de codigo_pdf y valid_report?: REVISAR funcionamiento
    unless codigo_pdf.present?
      return render json: { error: "Se requiere parámetro codigo_pdf" }, status: :bad_request
    end

    unless ClssPdf.valid_report?(codigo_pdf)
      return render json: { error: "Reporte no válido: #{codigo_pdf}" }, status: :bad_request
    end

    # Obtener la denuncia asociada
    krn_denuncia = @objeto.ownr
    
    # Determinar participantes según el tipo de reporte
    participantes = obtener_participantes(krn_denuncia, codigo_pdf)
    
    if participantes.empty?
      return render json: { error: "No hay participantes para generar el PDF" }, status: :unprocessable_content
    end

    # Generar PDFs múltiples (uno por participante)
    generar_pdf_multiples(codigo_pdf, 
      objeto_id: @objeto.id,
      participantes: participantes,
      async: false
    )
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

    # ============================================
    # DETERMINAR PARTICIPANTES SEGÚN REPORTE
    # ============================================
    def obtener_participantes(krn_denuncia, codigo_pdf)
      case codigo_pdf
      when 'txt_mdds_crrctvs_sncns', 'txt_mdds_rsgrd'
        # Todos los denunciantes y denunciados
        krn_denuncia.krn_denunciantes + krn_denuncia.krn_denunciados
      when 'txt_dclrcn_dnncnt'  # Ejemplo futuro: solo denunciantes
        krn_denuncia.krn_denunciantes
      when 'txt_dclrcn_dnncd'   # Ejemplo futuro: solo denunciados
        krn_denuncia.krn_denunciados
      when 'txt_tstg'            # Ejemplo futuro: testigos
        krn_denuncia.krn_testigos
      else
        # Default: todos los participantes
        krn_denuncia.krn_denunciantes + krn_denuncia.krn_denunciados
      end
    end

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
