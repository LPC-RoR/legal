class Aplicacion::AppRecursosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :inicia_sesion, only: [:procesos]

  include Tarifas

  helper_method :sort_column, :sort_direction

  def index
  end

  def ayuda
  end

  def usuarios
    set_tabla('usuarios', Usuario.all, true)
  end

  def procesos
  end

  def migrar_cuantias
    Causa.where(code_causa: nil).each do |rcrd|
      if rcrd.cliente_id.nil?
        rcrd.delete
      elsif rcrd.tipo_causa.present?
        rcrd.code_causa = rcrd.tipo_causa.code_causa
        rcrd.save
      end
    end

    TarTarifa.where(code_causa: nil).each do |rcrd|
      if rcrd.tipo_causa.present?
        rcrd.code_causa = rcrd.tipo_causa.code_causa
        rcrd.save
      end
    end

    TarTipoVariable.where(code_causa: nil).each do |rcrd|
      if rcrd.tipo_causa.present?
        rcrd.code_causa = rcrd.tipo_causa.code_causa
        rcrd.save
      end
    end

    redirect_to root_path
  end

  def migrar_tenants
    u = Usuario.find_by(email: 'afiwugogida18@gmail.com')
    u.delete

    u = Usuario.find_by(email: 'luisvalcarcel.m@yahoo.com')
    safe_add_role(u, :admin, u.tenant)
    u.remove_role(:operacion, nil)

    u = Usuario.find_by(email: 'hugo@laborsafe.cl')
    safe_add_role(u, :admin, u.tenant)
    u.remove_role(:operacion, nil)

    redirect_to root_path
  end

  def purge_rep_archivos

    huerfanos = RepArchivo.where(ownr_type: nil)
    huerfanos.delete_all

    dnncnts = RepArchivo.where(ownr_type: 'KrnDenunciante')
    dnncnts.delete_all

    dnncds = RepArchivo.where(ownr_type: 'KrnDenunciado')
    dnncds.delete_all

    tstgs =  RepArchivo.where(ownr_type: 'KrnTestigo')
    tstgs.delete_all

    KrnDenuncia.all.each do |dnnc|
      dnnc.rep_archivos.delete_all
      dnnc.krn_denunciantes.each do |dnncnt|
        dnncnt.rep_archivos.delete_all
        dnncnt.krn_testigos.each do |tstg|
          tstg.rep_archivos.delete_all
        end
      end
      dnnc.krn_denunciados.each do |dnncd|
        dnncd.rep_archivos.delete_all
        dnncd.krn_testigos.each do |tstg|
          tstg.rep_archivos.delete_all
        end
      end
    end
    
    redirect_to root_path, notice: KrnDenuncia.all.count
  end

  def chck_estds
    Causa.all.each do |causa|
      if ['ingreso', 'pagada', 'tramitación'].include?(causa.estado)
        causa.estado = causa.get_estado
        causa.estado_pago = causa.get_estado_pago
        causa.save
      end
    end
    
    redirect_to root_path, notice: Causa.all.count
  end

  def migrar_notas
    Nota.all.each do |nota|
      nota.tarea_con_plazo = nota.sin_fecha_gestion ? false : true
      nota.save
    end
    
    redirect_to root_path, notice: Nota.all.count
  end

  def activar_fecha_en_notas
    Nota.all.each do |nota|
      if nota.ownr.class.name == 'Causa'
        nota.tarea_con_plazo = true
        nota.save
      end
    end
    
    redirect_to root_path, notice: Nota.all.count
  end

  def password_recovery
    if usuario_signed_in? or dog?
      @raw, hashed = Devise.token_generator.generate(Usuario, :reset_password_token)

      @user = Usuario.find(params[:uid])
      @user.reset_password_token = hashed
      @user.reset_password_sent_at = Time.now.utc
      @user.save
    end
  end

  private
    # helper local dentro de la task
    def safe_add_role(user, role_name, resource = nil)
      role = Role.find_or_create_by!(
        name: role_name.to_s,
        resource_type: resource&.class&.name,
        resource_id: resource&.id
      )
      user.add_role(role_name, resource)
    end

    # Use callbacks to share common setup or constraints between actions.

    def sort_column
      Publicacion.column_names.include?(params[:sort]) ? params[:sort] : "Author"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
