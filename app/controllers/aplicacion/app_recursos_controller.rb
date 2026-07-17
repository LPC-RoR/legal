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

  def cargar_menu
    Menu.delete_all
    Menu.create!(key: :admin, enabled: true, items: helpers.h_menus[:admin][:items])

    redirect_to root_path
  end

  def migrar_cuantias

    causas_con_app_archivo = Causa.joins(:app_archivos)
                                .where(app_archivos: { app_archivo: 'Denuncia' })
                                .where.not(app_archivos: { archivo: nil })
                                .distinct      

    contador = { creados: 0, existentes: 0, errores: 0 }
    causas_con_app_archivo.find_each do |causa|

      app_archivo = causa.app_archivos.find_by(app_archivo: 'Denuncia')
      next unless app_archivo&.archivo&.present?
      
      act_archivo = causa.act_archivos.find_or_initialize_by(act_archivo: 'denuncia')
      
      if act_archivo.pdf.attached?
        contador[:existentes] += 1
        next
      end
      
      # Descargar archivo de CarrierWave y adjuntar a Active Storage
      archivo_path = app_archivo.archivo.path
      
      if File.exist?(archivo_path)
        act_archivo.pdf.attach(
          io: File.open(archivo_path),
          filename: File.basename(archivo_path),
          content_type: 'application/pdf'
        )
        act_archivo.save!
        contador[:creados] += 1
        puts "✓ Causa #{causa.id}: PDF migrado"
      else
        puts "✗ Causa #{causa.id}: Archivo no encontrado en #{archivo_path}"
        contador[:errores] += 1
      end
        
    end

    redirect_to root_path, notice: "creados #{contador[:creados]}, existentes #{contador[:existentes]} y errores #{contador[:errores]}"
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
