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

    def sin_f_pgn(page_text)
      # Saca el número de página y el caracter de inicio de página y el exceso de espacios
      page_text.gsub(/\n/, '__n__').gsub(/__n__\s+\d+\s*$/, "__n__" ).gsub(/\f/, '__n__').gsub(/\s{2,}/, " ").gsub(/__n__/, "\n")
    end

    # Obtiene un vectos de largo 3 con las 3 primeras palabras de la línea, si no hay palabra se pone nil
    def chk_wrds_3(line, prfx)
      v_prfx = prfx.blank? ? [] : prfx.split
      v_prfx_lngth = v_prfx.length
      wrds_3 = line.blank? ? '' : line.strip.split[0..(v_prfx_lngth-1)].join(' ')
      v_ln = prfx.match(/[\:\,\;\.]$/) ? wrds_3.split : wrds_3.gsub(/[\:\,\;\.]$/, '').split

      v_prfx & v_ln == v_prfx
    end

    def chk_line(line, st)
      v_rex = []
      fin = '(\s|\:)+'
      num = '(\s*\(?\s*\d+\s*\)?)?'
      rex1 = "^procedimiento#{fin}" # "verifica el término de la palabra o :
      rex2 = "^materia#{fin}"
      rex3 = "^demandante#{num}#{fin}"
      rex4 = "^ru[nt]#{fin}"
      rex5 = "^domicilio\s*(ambos)?(todos)?#{fin}"
      rex6 = "^abogado\s+patrocinante#{num}#{fin}"
      rex7 = "^((correo\s+electr[oó]nico)|(e?\-?mail))+#{fin}"
      rex8 = "^demandado\s+(solidario)?#{num}#{fin}"
      rex9 = "^representante\s*legal#{fin}"
      v_rex[0] = /#{rex1}|#{rex2}|#{rex3}|#{rex4}|#{rex5}|#{rex6}|#{rex7}|#{rex8}|#{rex9}/i
      v_rex[1] = /^EN\s*LO\s*PRINCIPAL\,*#{fin}/
      v_rex[2] = /^\s*S.J.L.\s+/
      v_rex[3] = /^POR\s*TANTO(\,|\s|\:)+/
      st == v_rex.length ? false : line.match(v_rex[st])
    end

    def read_demanda
      if @objeto.app_archivo == 'Demanda' and @objeto.archivo.present?
        path_pdf = File.join(Rails.root, 'public', @objeto.archivo.url)
        reader = PDF::Reader.new(path_pdf)

        # Unificamos las páginas en un sólo texto
        original = ''
        texto = ''
        reader.pages.each_with_index do |page, indx|
          sin_frmt_pgn = sin_f_pgn(page.text)
          original << sin_frmt_pgn
        end

        # Procesamos línea a línea
        s_names = ['Datos', 'En lo principal', 'Cuerpo', 'Por tanto', 'Otrosís']
        s_id = 0
        sub_txt = ''

        original.split("\n").each do |line|
          if s_id == 0
            if chk_line(line.strip, s_id + 1)
              Seccion.create(causa_id: @objeto.owner.id, orden: s_id + 1, seccion: s_names[s_id], texto: "#{sub_txt}</br>" )
              s_id += 1
              sub_txt = "#{line}"
            elsif chk_line(line, s_id)
              sub_txt << (sub_txt == '' ? line.strip : "</br>#{line.strip}" )
            else
              sub_txt << " #{line}"
            end
          else
            if chk_line(line, s_id + 1)
              Seccion.create(causa_id: @objeto.owner.id, orden: s_id + 1, seccion: s_names[s_id], texto: "#{sub_txt}</br>" )
              s_id += 1
              sub_txt = "#{line}"
            else
              sub_txt << "</br>#{line}"
            end
          end
        end
        Seccion.create(causa_id: @objeto.owner.id, orden: s_id + 1, seccion: s_names[s_id], texto: sub_txt )
        Seccion.create(causa_id: @objeto.owner.id, orden: s_id + 2, seccion: 'Origen', texto: original )
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
