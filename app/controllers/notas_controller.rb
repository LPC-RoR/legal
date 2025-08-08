class NotasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_nota, only: %i[ show edit update destroy swtch swtch_clr dssgn_usr assgn_usr ]
  before_action :set_bck_rdrccn, only:  %i[ edit update destroy agrega_nota ]

  include AgeUsr

  # GET /notas or /notas.json
  def index
    @coleccion = Nota.all
  end

  # GET /notas/1 or /notas/1.json
  def show
  end

  # GET /notas/new
  def new
    ownr = params[:oclss].constantize.find(params[:oid])
    @objeto = ownr.notas.new(app_perfil_id: perfil_activo.id, prioridad: 'success', fecha_gestion: Time.zone.now)
    set_bck_rdrccn
  end

  # REVISAR
  def agrega_nota
    f_prms = params[:form_nota]    
    fecha_gestion = prms_to_date_raw(f_prms, 'fecha_gestion')
    unless f_prms[:nota].blank?
      @objeto =Nota.create(ownr_type: params[:clss], ownr_id: params[:oid], app_perfil_id: perfil_activo.id, fecha_gestion: fecha_gestion, nota: f_prms[:nota], prioridad: 'success')
      noticia = 'Nota fue exitosamente creada'
    else
      noticia = 'Error de ingreso: Nota vacía'
    end

    redirect_to @bck_rdrccn, notice: noticia
  end

  # GET /notas/1/edit
  def edit
  end

  # POST /notas or /notas.json
  def create
    @objeto = Nota.new(nota_params)
    set_bck_rdrccn

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to params[:bck_rdrccn], notice: "Nota fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notas/1 or /notas/1.json
  def update
    respond_to do |format|
      if @objeto.update(nota_params)
        format.html { redirect_to params[:bck_rdrccn], notice: "Nota fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notas/1 or /notas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @bck_rdrccn, notice: "Nota fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nota
      @objeto = Nota.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def nota_params
      params.require(:nota).permit(:ownr_type, :ownr_id, :app_perfil_id, :nota, :prioridad, :realizado, :fecha_gestion, :sin_fecha_gestion, :tarea_con_plazo)
    end
end
