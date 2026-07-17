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
                                  .distinct

    procesadas = 0
    creadas = 0
    actualizadas = 0
    errores = 0
    sin_archivo = 0

    causas_con_app_archivo.find_each do |causa|

      app_archivo = causa.app_archivos.find_by(app_archivo: 'Denuncia')

      # Verificar si realmente tiene un archivo
      unless app_archivo && archivo_existe?(app_archivo)
        sin_archivo += 1
        puts "  Causa #{causa.id}: AppArchivo sin archivo adjunto"
        next
      end

      # Buscar o crear el ActArchivo de denuncia
      act_archivo = causa.act_archivos.find_or_initialize_by(act_archivo: 'denuncia')
      
      # Verificar si el archivo ya existe en Active Storage
      if act_archivo.pdf.attached?
        actualizadas += 1
        puts "  Causa #{causa.id}: ActArchivo ya tiene PDF adjunto, omitiendo..."
        next
      end

      # Migrar el archivo
      if migrar_archivo(app_archivo, act_archivo)
        creadas += 1
        puts "  ✓ Causa #{causa.id}: PDF de denuncia migrado correctamente"
      else
        errores += 1
        puts "  ✗ Causa #{causa.id}: Error al migrar el archivo"
      end
      
      procesadas += 1        

    end

    redirect_to root_path, notice: "procesadas #{procesadas}, creadas #{creadas}, actualizadas #{actualizadas}, sin archivos #{sin_archivo} y errores #{errores}"
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

    # ************** Migracion de AppArchivo a ActArchivo
    def archivo_existe?(app_archivo)
      return false unless app_archivo.archivo.present?
      
      # Verificar de múltiples formas
      archivo = app_archivo.archivo
      
      # 1. Verificar si tiene un archivo subido
      return false unless archivo.file.present?
      
      # 2. Verificar el path
      if archivo.path.present?
        return File.exist?(archivo.path)
      end
      
      # 3. Verificar URL para archivos remotos
      if archivo.url.present?
        return true
      end
      
      # 4. Verificar el identificador en la base de datos
      if app_archivo.archivo_identifier.present?
        return true
      end
      
      false
    rescue => e
      Rails.logger.error "Error al verificar archivo: #{e.message}"
      false
    end
  
    def migrar_archivo(app_archivo, act_archivo)
      archivo = app_archivo.archivo
      
      # Intentar obtener el contenido del archivo
      contenido = obtener_contenido_archivo(archivo)
      return false unless contenido
      
      filename = obtener_nombre_archivo(archivo)
      
      # Adjuntar a Active Storage
      act_archivo.pdf.attach(
        io: contenido,
        filename: filename,
        content_type: 'application/pdf'
      )
      
      act_archivo.save!
      true
    rescue => e
      Rails.logger.error "Error al migrar archivo: #{e.message}"
      false
    end
  
    def obtener_contenido_archivo(archivo)
      # Método 1: Usar el path si existe
      if archivo.path.present? && File.exist?(archivo.path)
        return File.open(archivo.path, 'rb')
      end
      
      # Método 2: Usar el file de CarrierWave
      if archivo.file.respond_to?(:read)
        temp = Tempfile.new(['migracion', File.extname(archivo.path || '.pdf')])
        temp.binmode
        temp.write(archivo.file.read)
        temp.rewind
        return temp
      end
      
      # Método 3: Usar URL remota
      if archivo.url.present?
        require 'open-uri'
        temp = Tempfile.new(['migracion', '.pdf'])
        temp.binmode
        
        URI.open(archivo.url) do |remote_file|
          temp.write(remote_file.read)
          temp.rewind
        end
        return temp
      end
      
      # Método 4: Usar el identificador para buscar en el almacenamiento
      if archivo.identifier.present?
        # Esto es más complejo y depende de tu configuración de CarrierWave
        Rails.logger.warn "No se pudo obtener el archivo usando métodos convencionales"
        return nil
      end
      
      nil
    rescue => e
      Rails.logger.error "Error al obtener contenido: #{e.message}"
      nil
    end
  
    def obtener_nombre_archivo(archivo)
      return archivo.filename if archivo.respond_to?(:filename) && archivo.filename.present?
      return File.basename(archivo.path) if archivo.path.present?
      return archivo.identifier if archivo.identifier.present?
      "denuncia_#{Time.current.to_i}.pdf"
    end
    # ************** Migracion de AppArchivo a ActArchivo (final)

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
