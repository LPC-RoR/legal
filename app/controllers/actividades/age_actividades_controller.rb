class Actividades::AgeActividadesController < ApplicationController
  before_action :set_age_actividad, only: %i[ show edit update destroy suma_participante resta_participante agrega_antecedente realizada_pendiente]

  # GET /age_actividades or /age_actividades.json
  def index
    verifica_annio_activo

    set_tab(:menu, ['Pendientes', 'Realizadas'])

    if @options[:menu] == 'Pendientes'

      hoy = Time.zone.today
      cal_annio = CalAnnio.find_by(cal_annio: hoy.year)
      cal_mes = cal_annio.cal_meses.find_by(cal_mes: hoy.month)
      verifica_mes(cal_mes)
      n_semana = get_n_semana(hoy)
      @semana = cal_mes.cal_semanas.find_by(cal_semana: n_semana).cal_dias.order(:dt_fecha)
      @siguiente = cal_mes.cal_semanas.find_by(cal_semana: n_semana + 1).cal_dias.order(:dt_fecha)

      @agenda_15 = []
      @semana.each_with_index do |cal_dia, indice|
        dia = {}
        dia[:dia] = cal_dia.dt_fecha
        dia[:dyf] = cal_dia.dyf? ? 'danger' : 'info'
        dia[:actividades] = AgeActividad.where(fecha: cal_dia.dt_fecha.all_day)

        @agenda_15[indice] = [dia]
      end
      @siguiente.each_with_index do |cal_dia, indice|
        dia = {}
        dia[:dia] = cal_dia.dt_fecha
        dia[:dyf] = cal_dia.dyf? ? 'danger' : 'info'
        dia[:actividades] = AgeActividad.where(fecha: cal_dia.dt_fecha.all_day)

        @agenda_15[indice] << dia
      end

      set_tabla('age_actividades', AgeActividad.where(estado: 'pendiente').order(fecha: :desc), false)
    elsif @options[:menu] == 'Realizadas'
      set_tabla('age_actividades', AgeActividad.where(estado: 'realizada').order(fecha: :desc), false)
    end
  end

  # GET /age_actividades/1 or /age_actividades/1.json
  def show
    set_tabla('age_antecedentes', @objeto.age_antecedentes.order(:orden), false)
  end

  # GET /age_actividades/new
  def new
    case params[:t]
    when 'A'
      tipo = 'Audiencia'
    when 'R'
      tipo = 'Reunión'
    when 'T'
      tipo = 'Tarea'
    when 'H'
      tipo = 'Hito'
    end
    @objeto = AgeActividad.new(owner_class: params[:class_name], owner_id: params[:objeto_id], app_perfil_id: perfil_activo.id, estado: 'pendiente', tipo: tipo)
  end

  def crea_audiencia
    causa = params[:class_name].constantize.find(params[:objeto_id])
    AgeActividad.create(age_actividad: params[:label] ,owner_class: params[:class_name], owner_id: params[:objeto_id], app_perfil_id: perfil_activo.id, estado: 'ingreso', tipo: 'Audiencia')

    redirect_to causa
  end

  # GET /age_actividades/1/edit
  def edit
  end

  # POST /age_actividades or /age_actividades.json
  def create
    @objeto = AgeActividad.new(age_actividad_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Actividad fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /age_actividades/1 or /age_actividades/1.json
  def update
    respond_to do |format|
      if @objeto.update(age_actividad_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Actividad fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def suma_participante
    perfil = AppPerfil.find(params[:pid])
    @objeto.app_perfiles << perfil

    redirect_to ( params[:loc] == 'age_actividades' ? '/age_actividades' : @objeto.owner )
  end

  def resta_participante
    perfil = AppPerfil.find(params[:pid])
    @objeto.app_perfiles.delete(perfil)

    redirect_to ( params[:loc] == 'age_actividades' ? '/age_actividades' : @objeto.owner )
  end

  def agrega_antecedente
    unless params[:form_antecedente][:age_antecedente].blank? 
      @objeto.age_antecedentes.create(age_antecedente: params[:form_antecedente][:age_antecedente], orden: @objeto.age_antecedentes.count + 1)
    end

    redirect_to ( params[:c] == 'age_actividades' ? '/age_actividades' : @objeto.owner )
  end

  def realizada_pendiente
    @objeto.estado = ( @objeto.estado == 'pendiente' ? 'realizada' : 'pendiente' )
    @objeto.save

    redirect_to ( params[:c] == 'age_actividades' ? '/age_actividades' : @objeto.owner )
  end

  # DELETE /age_actividades/1 or /age_actividades/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Actividad fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_age_actividad
      @objeto = AgeActividad.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.owner
    end

    # Only allow a list of trusted parameters through.
    def age_actividad_params
      params.require(:age_actividad).permit(:age_actividad, :tipo, :app_perfil_id, :owner_class, :owner_id, :estado, :fecha)
    end
end
