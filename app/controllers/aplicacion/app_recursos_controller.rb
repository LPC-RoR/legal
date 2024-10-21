class Aplicacion::AppRecursosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :inicia_sesion, only: [:administracion, :procesos, :home]

  include Tarifas

  helper_method :sort_column, :sort_direction

  def index
  end

  def ayuda
  end

  def usuarios
    set_tabla('usuarios', Usuario.all, true)
  end

  def administracion
  end

  def procesos
    i= 1

#    TarFacturacion.all.each do |tf|
#      tf.ownr_type = tf.owner_class
#      tf.ownr_id = tf.owner_id
#      tf.save
#      i += 1
#    end

#    TarValorCuantia.all.each do |tvc|
#      tvc.ownr_type = tvc.owner_class
#      tvc.ownr_id = tvc.owner_id
#      tvc.save
#      i += 1
#    end

#    TarCalculo.all.each do |tc|
#      puts "_______________________________________________________________________"
#      tc.cliente_id = tc.clnt_id
#      tc.ownr_type = tc.ownr_clss
#      tc.save
#    end

#    TarFacturacion.all.each do |tf|
#      if tf.ownr_type == 'Causa' and tf.tar_pago_id.blank? and tar_cuota_id.present?
#        tf.tar_pago_id = tf.tar_cuota.tar_pago.id
#        tf.save
#      end
#    end

#    Borré los campos antes de  migrar los enlaces
#    TarUfFacturacion.delete_all

    KrnEmpresaExterna.all.each do |ee|
      ee.ownr_type = ee.cliente_id.present? ? 'Cliente' : 'Empresa'
      ee.ownr_id = ee.cliente_id.present? ? ee.cliente_id : ee.empresa_id
      ee.save
    end

    KrnTipoMedida.all.each do |tm|
      tm.ownr_type = tm.cliente_id.present? ? 'Cliente' : 'Empresa'
      tm.ownr_id = tm.cliente_id.present? ? tm.cliente_id : tm.empresa_id
      tm.save
    end

    KrnInvestigador.all.each do |inv|
      inv.ownr_type = inv.cliente_id.present? ? 'Cliente' : 'Empresa'
      inv.ownr_id = inv.cliente_id.present? ? inv.cliente_id : inv.empresa_id
      inv.save
    end

    redirect_to root_path
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
    # Use callbacks to share common setup or constraints between actions.

    def sort_column
      Publicacion.column_names.include?(params[:sort]) ? params[:sort] : "Author"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
