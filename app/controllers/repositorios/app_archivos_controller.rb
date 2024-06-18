class Repositorios::AppArchivosController < ApplicationController
  before_action :set_app_archivo, only: %i[ show edit update destroy ]
  after_action :read_demanda, only: :update

  # GET /app_archivos or /app_archivos.json
  def index
  end

  # GET /app_archivos/1 or /app_archivos/1.json
  def show
  end

  # GET /app_archivos/new
  def new
    @objeto = AppArchivo.new(owner_class: params[:class_name], owner_id: params[:objeto_id])
  end

  # GET /app_archivos/1/edit
  def edit
  end

  # POST /app_archivos or /app_archivos.json
  def create
    @objeto = AppArchivo.new(app_archivo_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Archivo fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_archivos/1 or /app_archivos/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_archivo_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Archivo fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_archivos/1 or /app_archivos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Archivo fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Prepara la página sacada del PDF para ser procesada
    def parse_page(page_text)
      # Sacamos el caracter de comienzo de página y reemplazamos los dobles \n por </br>
      line_array = page_text.gsub(/\f/, '').gsub(/\n\n/, '</br>' ).split('</br>')
      #sacamos el número de página
      line_array.pop
      # lo volvemos a hacer texto; reemplazamos los dobles </br> por uno sólo y sacamos el exceso de espacios
      line_array.join('</br>').gsub(/<\/br><\/br>/, '</br>').split(' ').join(' ')
    end

    # Obtiene un vectos de largo 3 con las 3 primeras palabras de la línea, si no hay palabra se pone nil
    def chk_wrds_3(line, prfx)
      v_prfx = prfx.blank? ? [] : prfx.split
      v_prfx_lngth = v_prfx.length
      wrds_3 = line.blank? ? '' : line.strip.split[0..(v_prfx_lngth-1)].join(' ')
      v_ln = prfx.match(/[\:\,\;\.]$/) ? wrds_3.split : wrds_3.gsub(/[\:\,\;\.]$/, '').split

      v_prfx & v_ln == v_prfx
    end

    def read_demanda
      if @objeto.app_archivo == 'Demanda' and @objeto.archivo.present?
        path_pdf = File.join(Rails.root, 'public', @objeto.archivo.url)
        reader = PDF::Reader.new(path_pdf)

        # Unificamos las páginas en un sólo texto
        texto = ''
        reader.pages.each_with_index do |page, indx|
          texto << parse_page(page.text)
        end

        # Procesamos línea a línea
        s_names = ['Datos', 'En lo principal', 'Cuerpo', 'Por tanto', 'Otrosís']
        s_breaks = ['EN LO PRINCIPAL', 'S.J.L.', 'POR TANTO', '__FIN__']
        s_id = 0
        sub_txt = ''

        # Recorremos línea a línea
        texto.split('</br>').each do |line|
          if chk_wrds_3(line, s_breaks[s_id])
            Seccion.create(causa_id: @objeto.owner.id, orden: s_id + 1, seccion: s_names[s_id], texto: sub_txt )
            s_id += 1
            sub_txt = line
          else
            sub_txt << "#{line}</br>"
          end
        end
        Seccion.create(causa_id: @objeto.owner.id, orden: s_id + 1, seccion: s_names[s_id], texto: sub_txt )
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_app_archivo
      @objeto = AppArchivo.find(params[:id])
    end

    def set_redireccion
      if @objeto.causas.any?
        @redireccion = "/causas/#{@objeto.causas.first.id}?html_options[menu]=Hechos"
      elsif ['AppDirectorio', 'TarFactura'].include?(@objeto.owner.class.name)
        @redireccion = @objeto.owner
      elsif ['AppDocumento'].include?(@objeto.owner.class.name)
        @redireccion = "/#{@objeto.owner.objeto_destino.class.name.tableize.downcase}/#{@objeto.owner.objeto_destino.id}?html_options[menu]=Documentos"
      elsif ['Causa', 'Cliente'].include?(@objeto.objeto_destino.class.name)
        @redireccion = "/#{@objeto.objeto_destino.class.name.tableize.downcase}/#{@objeto.objeto_destino.id}?html_options[menu]=Documentos"
      else
        @redireccion = app_repositorios_path
      end
    end

    # Only allow a list of trusted parameters through.
    def app_archivo_params
      params.require(:app_archivo).permit(:app_archivo, :archivo, :owner_class, :owner_id, :remove_archivo)
    end
end
