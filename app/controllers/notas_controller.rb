class NotasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_nota, only: %i[ show edit update destroy swtch_realizada swtch_urgencia swtch_pendiente ]

  # GET /notas or /notas.json
  def index
    @coleccion = Nota.all
  end

  # GET /notas/1 or /notas/1.json
  def show
  end

  # GET /notas/new
  def new
    @objeto = Nota.new
  end

  def agrega_nota
    f_prms = params[:form_nota]    
    unless f_prms[:nota].blank?
      @objeto =Nota.create(ownr_clss: params[:clss], ownr_id: params[:oid], perfil_id: perfil_activo.id, nota: f_prms[:nota], prioridad: f_prms[:prioridad])
      noticia = 'Nota fue exitósamente creada'
    else
      noticia = 'Error de ingreso: Nota vacía'
    end

    set_redireccion
    redirect_to @redireccion, notice: noticia
  end

  # GET /notas/1/edit
  def edit
  end

  # POST /notas or /notas.json
  def create
    @objeto = Nota.new(nota_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Nota fue exitósamente creada." }
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
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Nota fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def swtch_realizada
    @objeto.realizado = @objeto.realizado ? false : true
    @objeto.save

    set_redireccion
    redirect_to @redireccion
  end

  # DELETE /notas/1 or /notas/1.json
  def destroy
    set_redireccion
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Nota fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nota
      @objeto = Nota.find(params[:id])
    end

    def set_redireccion
      case @objeto.owner.class.name
      when 'Asesoria'
        @redireccion  = asesorias_path
      when 'Causa'
        @redireccion  = causas_path
      when 'Cliente'
        @redireccion  = clientes_path
      when 'AgeActividad'
        @redireccion  = age_actividades_path
      end
    end

    # Only allow a list of trusted parameters through.
    def nota_params
      params.require(:nota).permit(:ownr_clss, :ownr_id, :perfil_id, :nota, :prioridad, :realizado)
    end
end
