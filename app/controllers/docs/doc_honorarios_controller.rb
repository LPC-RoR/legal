class Docs::DocHonorariosController < ApplicationController
  before_action :set_doc_honorario, only: [:show, :destroy, :reprocesar]

  layout 'addt'

  def index
    @clccn = DocHonorario.order(anio: :desc, mes: :desc)
  end

  def show
    @boletas = @objeto.doc_boletas.order(:fecha, :numero)
  end

  def new
    @objeto = DocHonorario.new
  end

  def create
    uploaded_file = doc_honorario_params[:archivo]

    unless uploaded_file.present?
      @objeto = DocHonorario.new
      @objeto.errors.add(:archivo, "debe seleccionar un archivo")
      render :new, status: :unprocessable_entity
      return
    end

    content = leer_contenido_archivo(uploaded_file)

    unless content
      @objeto = DocHonorario.new
      @objeto.errors.add(:archivo, "no se pudo leer el contenido")
      render :new, status: :unprocessable_entity
      return
    end

    datos = extraer_datos_del_contenido(content)

    unless datos
      @objeto = DocHonorario.new
      @objeto.errors.add(:archivo, "no contiene los datos necesarios en el encabezado")
      render :new, status: :unprocessable_entity
      return
    end

    # Normalizar RUT contribuyente (sin guion)
    datos[:contribuyente_rut] = datos[:contribuyente_rut].to_s.gsub('-', '')

    @objeto = DocHonorario.find_or_initialize_by(
      contribuyente_rut: datos[:contribuyente_rut],
      mes: datos[:mes],
      anio: datos[:anio]
    )

    @objeto.contribuyente_nombre = datos[:contribuyente_nombre]
    @objeto.mes = datos[:mes]
    @objeto.anio = datos[:anio]

    uploaded_file.rewind
    @objeto.archivo.attach(uploaded_file)

    if @objeto.save
      @objeto.procesar_contenido!(content)
      redirect_to @objeto, notice: 'Documento procesado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @objeto.destroy
    redirect_to doc_honorarios_url, notice: 'Documento eliminado.'
  end

  def reprocesar
    @objeto.reprocesar!
    redirect_to @objeto, notice: 'Documento reprocesado exitosamente.'
  end

  private

  def set_doc_honorario
    @objeto = DocHonorario.find(params[:id])
  end

  def doc_honorario_params
    params.require(:doc_honorario).permit(:archivo)
  end

  def leer_contenido_archivo(uploaded_file)
    raw = uploaded_file.read
    raw.encode('UTF-8', 'ISO-8859-1', invalid: :replace, undef: :replace)
  rescue => e
    Rails.logger.error "Error leyendo archivo: #{e.message}"
    nil
  ensure
    uploaded_file.rewind
  end

  def extraer_datos_del_contenido(content)
    require 'nokogiri'
    doc = Nokogiri::HTML(content)

    header_cell = doc.at('td[colspan="10"]')
    return nil unless header_cell

    texto = header_cell.text

    datos = {}

    if texto =~ /RUT\s*[:·]\s*([\d\.]+-\d)/
      datos[:contribuyente_rut] = $1.gsub('.', '')
    end

    if texto =~ /Contribuyente:\s*(.+?)\s*RUT/i
      datos[:contribuyente_nombre] = $1.strip
    end

    if texto =~ /mes\s+(\d+)\s+del\s+a[ñn]o\s+(\d{4})/i
      datos[:mes] = $1.to_i
      datos[:anio] = $2.to_i
    end

    return nil if datos[:contribuyente_rut].blank? ||
                  datos[:contribuyente_nombre].blank? ||
                  datos[:mes].blank? ||
                  datos[:anio].blank?

    datos
  end
end