class Modelos::MRegistrosController < ApplicationController
  before_action :set_m_registro, only: %i[ show edit update destroy asigna asigna_factura libera_factura ]

  # GET /m_registros or /m_registros.json
  def index
    @coleccion = MRegistro.all
  end

  # GET /m_registros/1 or /m_registros/1.json
  def show
    init_tabla('tar_facturas', @objeto.tar_facturas.order(:documento), false)

    @facturadas = TarFactura.where(estado: 'facturada').order(:documento)
  end

  # GET /m_registros/new
  def new
    @objeto = MRegistro.new
  end

  # GET /m_registros/1/edit
  def edit
  end

  # POST /m_registros or /m_registros.json
  def create
    @objeto = MRegistro.new(m_registro_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Registro fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_registros/1 or /m_registros/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_registro_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Registro fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # Asigna registro a un item del modelo
  def asigna
    @objeto.m_item_id = params[:iid]
    @objeto.save

    redirect_to "/m_modelos?id=p_#{@objeto.m_periodo.id}"
  end

  # asigna factura a un registro
  # params[:asigna_factura][:tar_factura_id] : id de la factura
  # params[:asigna_factura][:tipo_monto] : {'factura', 'disponible', 'monto'}
  # params[:asigna_factura][:monto] : monto especifico
  def asigna_factura
    factura_id = params[:asigna_factura][:tar_factura_id]
    tipo_monto = params[:asigna_factura][:tipo_monto]
    monto = params[:asigna_factura][:monto].to_i
    unless factura_id.blank?
      factura = TarFactura.find(factura_id)
      if factura.pagada?
        factura.estado = 'pagada'
        factura.save
        noticia = 'Error en la asignación: Factura ya está pagada pagada'
      else
        case tipo_monto
        when 'Factura'
          unless factura.disponible > @objeto.disponible
            @objeto.m_reg_facts.create(tar_factura_id: factura.id, monto: factura.monto_pesos)
            factura.estado = 'pagada'
            factura.save
            noticia = 'La factura ha sido exitósamente asignada al registro'
          else
            noticia = 'Error en la asignación: Monto de la factura excede abono disponible'
          end
        when 'Disponible'
          unless factura.disponible < @objeto.disponible
            @objeto.m_reg_facts.create(tar_factura_id: factura.id, monto: @objeto.disponible)
            if factura.pagada?
              factura.estado = 'pagada'
              factura.save
            end
            noticia = 'Disponible del abono ha sido exitósamente asignado a la factura'
          else
            noticia = 'Error en la asignación: Dsiponible del abono excede disponible de la factura'
          end
        when 'Monto'
          unless monto.blank?
            if monto > factura.disponible
              noticia = 'Error en la asignación: Monto asignado excede monto por pagar en la factura'
            elsif monto > @objeto.disponible
              noticia = 'Error en la asignación: Monto asignado excede monto disponible en el abono'
            else
              @objeto.m_reg_facts.create(tar_factura_id: factura.id, monto: monto)
              if factura.pagada?
                factura.estado = 'pagada'
                factura.save
              end
              noticia = 'Monto del abono ha sido exitósamente asignado a la factura'
            end
          else
            noticia = 'Error en la asignación: No se ingreso monto para pagar factura'
          end
        end
      end
    else
      noticia = 'Error en la asignación: No se seleccionó factura'
    end

    redirect_to "/m_modelos?id=p_#{@objeto.m_periodo.id}", notice: noticia
  end

  def libera_factura
    factura = TarFactura.find(params[:fid])

    @objeto.tar_facturas.delete(factura)

    redirect_to "/m_modelos?id=p_#{@objeto.m_periodo.id}", notice: 'Factura fue liberada exitósamente'
  end

  # DELETE /m_registros/1 or /m_registros/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Registro fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_registro
      @objeto = MRegistro.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.periodo
    end

    # Only allow a list of trusted parameters through.
    def m_registro_params
      params.require(:m_registro).permit(:m_registro, :orden, :m_conciliacion_id, :fecha, :glosa_banco, :glosa, :documento, :monto, :cargo_abono, :saldo, :m_item_id)
    end
end
