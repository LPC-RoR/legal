# app/controllers/admin/base_controller.rb
module Admin
  class BaseController < ApplicationController
    # Aquí puedes agregar:
    # - Autenticación de administradores
    # - Autorización (verificar que el usuario sea admin)
    # - Layouts específicos para admin
    # - Before actions comunes para todo el namespace admin
    
    before_action :authenticate_user!  # Si usas Devise
    before_action :require_admin       # Tu método de autorización
  end
end