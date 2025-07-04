class Repositorios::AppArchivosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_app_archivo, only: %i[ show edit update destroy ]
  before_action :set_bck_rdrccn, only:  %i[ edit update destroy ]
  after_action :read_demanda, only: [:create, :update], if: -> {@objeto.ownr.class.name == 'Causa'}

  # GET /app_archivos or /app_archivos.json
  def index
  end

  # GET /app_archivos/1 or /app_archivos/1.json
  def show
  end

  # GET /app_archivos/new
  def new
    # oclss: clase del ownr
    # oid: id del ownr
    # dcid: id del documento controlado. cuando lo hay
    # conviven dos modalidades de parámetros
    documento_controlado_id = params[:dcid]
    documento_controlado = params[:dcid].blank? ? nil : ControlDocumento.find(params[:dcid])
    nombre_documento = params[:dcid].blank? ? nil : documento_controlado.nombre
    ownr = params[:oclss].blank? ? params[:class_name].constantize.find(params[:objeto_id]) : params[:oclss].constantize.find(params[:oid])
    @objeto = AppArchivo.new(ownr_type: ownr.class.name, ownr_id: ownr.id, app_archivo: nombre_documento, control_documento_id: documento_controlado_id)
    set_bck_rdrccn
  end

  # GET /app_archivos/1/edit
  def edit
  end

  # POST /app_archivos or /app_archivos.json
  def create
    @objeto = AppArchivo.new(app_archivo_params)
    set_bck_rdrccn

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to params[:bck_rdrccn], notice: "Archivo fue exitosamente creado." }
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
        format.html { redirect_to params[:bck_rdrccn], notice: "Archivo fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_archivos/1 or /app_archivos/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @bck_rdrccn, notice: "Archivo fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private

    def sin_f_pgn(page_text)
      # Saca el número de página y el caracter de inicio de página.
      # No reemplazamos \s con espacios porque, \s arrastra con más que espacios
      page_text.gsub(/\n/, '__n__').gsub(/__n__\s+\d+\s*$/, "__n__" ).gsub(/\f/, '__n__').gsub(/__n__/, "\n")
    end

    def dts_rgx
      num = '(\s*\(?\s*\d+\s*\)?)?'
      rex1 = "^procedimiento(\s|:)" # "verifica el término de la palabra o :
      rex2 = "^materia(\s|:)"
      rex3 = "^demandante#{num}(\s|:)"
      rex4 = "^ru[nt](\s|:)"
      rex5 = "^domicilio\s*(ambos)?(todos)?(abogado)?s?(\s|:)"
      rex6 = "^abogado\s+(patrocinante)?(apoderado)?#{num}(\s|:)"
      rex7 = "^((correo\s+electr(o|ó)nico)|(e?\-?mail))+(\s|:)"
      rex8 = "^demandado\s+(solidario)?#{num}(\s|:)"
      rex9 = "^representante\s*legal(\s|:)"
      /#{rex1}|#{rex2}|#{rex3}|#{rex4}|#{rex5}|#{rex6}|#{rex7}|#{rex8}|#{rex9}/i
    end

    def dts_rgx_nwln
      rex1 = "^ru[nt](\s|:)"
      rex2 = "^domicilio\s*(abogado|demandante)?(\s|:)"
      rex3 = "^representante\s*legal(\s|:)"
      /#{rex1}|#{rex2}|#{rex3}/i
    end

    def new_line_rgx
      rex1 = "^[a-z]{1}\s?[\)\:\.]{1}"
      rex2 = "^[1-9]{1,2}\.?[0-2]{1,2}\s*[\)\:\.]{1}\s+"
      rex3 = "^[IVXLC]+[\s\:\.\)]{1}"
      rex4 = /^POR\s*TANTO(\,|\s|\:)+/
      /#{rex1}|#{rex2}|#{rex3}|#{rex4}/i
    end

    def one_line_rgx
      /^\s*S.\s?J.\s?(L.)?\s+/
    end

    def chk_br(line, final)
      chk_blank = (line != '' and final != '' and line != nil and final != nil)
      chk_blank and ['.', ':'].include?(final.strip[-1])
    end

    def demandante_rgx
      fin = '(\s|\:)+'
      num = '(\s*\(?\s*\d+\s*\)?)?'
      /^demandante#{num}#{fin}/i
    end

    # NO se usa en esta versión pero puede volver, sobre todo por las cifras
    def chk_shw(prrf)
      fin = '(\s|\:)+'
      num = '(\s*\(?\s*\d+\s*\)?)?'
      rex1 = /\$\s*[0-9]{1}[0-9]{0,2}(\.[0-9]{3})*[\s\.\-]+/i
      rex2 = /^demandante#{num}#{fin}/i
      rex = /#{rex1}|#{rex2}/i
      ( prrf.texto.match(rex1) or prrf.texto.match(rex2) or (prrf.seccion.seccion == 'Por tanto') )
    end

    def read_demanda
      puts "------------------------------------------------------- read_demanda"
      if @objeto.ownr.class.name == 'Causa'
        if @objeto.app_archivo == 'Demanda' and @objeto.archivo.present?
          path_pdf = File.join(Rails.root, 'public', @objeto.archivo.url)
          reader = PDF::Reader.new(path_pdf)

          causa = @objeto.ownr
          if causa.parrafos.any?
            causa.secciones.delete_all
            causa.parrafos.delete_all
          end

          # Unimos las páginas en un sólo texto
          original = ''
          reader.pages.each do |page|
            original << "#{sin_f_pgn(page.text)}\n"
          end

          # Procesamos línea a línea
          estado = 'Datos'
          p_ord = 0
          txt_prrf = ''
          final = nil

          seccion = Seccion.create(causa_id: @objeto.ownr.id, orden: 1, seccion: estado, texto: nil )

          original.split("\n").each do |raw_line|
            line = raw_line.strip
            if estado == 'Datos'
              if line.match?(/^EN\s*LO\s*PRINCIPAL\,*\b/)
                estado = 'Cuerpo'
                Parrafo.create(causa_id: @objeto.ownr.id, seccion_id: seccion.id, orden: p_ord + 1, texto: "#{txt_prrf}</br>")
                p_ord += 1
                txt_prrf = line
                final = line

                seccion = Seccion.create(causa_id: @objeto.ownr.id, orden: 2, seccion: 'Cuerpo', texto: nil )

              elsif line.match?(dts_rgx)
                if line.match?(dts_rgx_nwln)
                  txt_prrf << (txt_prrf == '' ? line.strip : "</br>#{line.strip}" )
                else
                  # Se crea nuevo campo
                  unless p_ord == 0 and txt_prrf == ''
                    Parrafo.create(causa_id: @objeto.ownr.id, seccion_id: seccion.id, orden: p_ord + 1, texto: "#{txt_prrf}</br>")
                    p_ord += 1
                  end
                  txt_prrf = "#{line}"
                end
              else
                txt_prrf << " #{line}" unless line.blank?
              end
              if line.match?(demandante_rgx)
                causa = @objeto.ownr
                n_orden = causa.demandantes.count + 1
                nombre = line.split(':')[1].strip
                wrds = nombre.split(' ')
                lngth = wrds.length
                nombres = lngth > 3 ? "#{wrds[0]} #{wrds[1]}" : wrds[0]
                apellidos = lngth > 3 ? "#{wrds[2]} #{wrds[3]}" : "#{wrds[1]} #{wrds[2]}"
                causa.demandantes.create(orden: n_orden, nombres: nombres, apellidos: apellidos)
              end
            else
              if line.match?(new_line_rgx)
                # Primera línea de la siguiente sección
                Parrafo.create(causa_id: @objeto.ownr.id, seccion_id: seccion.id, orden: p_ord + 1, texto: "#{txt_prrf}</br>")
                p_ord += 1
                txt_prrf = line
                final = line
                if line.match?(one_line_rgx)
                  Parrafo.create(causa_id: @objeto.ownr.id, seccion_id: seccion.id, orden: p_ord + 1, texto: "#{line}</br>")
                  p_ord += 1
                  txt_prrf = ''
                  final = ''
                end
              else
                # No es primera línea de la siguiente seccion y no es un campo => Debe ser la continuación de un campo.
                if chk_br(line, final)
                  Parrafo.create(causa_id: @objeto.ownr.id, seccion_id: seccion.id, orden: p_ord + 1, texto: "#{txt_prrf}</br>")
                  p_ord += 1
                  txt_prrf = line
                  final = line
                else
                  txt_prrf << " #{line}"
                end
                final = line unless (line == '' or line.blank?)
              end
            end
          end
          Parrafo.create(causa_id: @objeto.ownr.id, seccion_id: seccion.id, orden: p_ord + 1, texto: "#{txt_prrf}</br>")
        end

      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_app_archivo
      @objeto = AppArchivo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_archivo_params
      params.require(:app_archivo).permit(:app_archivo, :archivo, :archivo_cache, :ownr_type, :ownr_id, :remove_archivo, :control_documento_id)
    end
end
