class Dts::ValoresController < ApplicationController
  before_action :set_valor, only: %i[ show edit update destroy ]

  # GET /valores or /valores.json
  def index
    @coleccion = Valor.all
  end

  # GET /valores/1 or /valores/1.json
  def show
  end

  # GET /valores/new
  def new
    @objeto = Valor.new
  end

  #[t: Texto, p: Párrafo, n: Número, b: Booleano, ps: Pesos, u: UF]
  def nuevo
    ownr = params[:oclss].constantize.find(params[:oid])
    variable = Variable.find_by(variable: params[:v])
    variable_id = variable.id
    c_t = params[:t].blank? ? nil : params[:t]
    c_p = params[:p].blank? ? nil : params[:p]
    c_n = params[:n].blank? ? nil : params[:n]
    c_b = params[:b].blank? ? nil : (params[:b] == 't' ? true : false)
    c_f = params[:f].blank? ? nil : params[:f]
    Valor.create(ownr_type: params[:oclss], ownr_id: params[:oid], c_string: c_t, c_text: c_p, c_numero: c_n, c_booleano: c_b, c_fecha: c_f, variable_id: variable_id )

    case params[:oclss]
    when 'KrnDenuncia'
      rdrcn = ownr
    end

    redirect_to rdrcn
  end

  # GET /valores/1/edit
  def edit
  end

  # POST /valores or /valores.json
  def create
    @objeto = Valor.new(valor_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Valor fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /valores/1 or /valores/1.json
  def update
    respond_to do |format|
      if @objeto.update(valor_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Valor fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /valores/1 or /valores/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Valor fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_valor
      @objeto = Valor.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.owner
    end

    # Only allow a list of trusted parameters through.
    def valor_params
      params.require(:valor).permit(:owner_class, :owner_id, :variable_id, :c_string, :c_text, :c_fecha, :c_numero)
    end
end
