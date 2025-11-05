# app/policies/menu_item_policy.rb
class MenuItemPolicy < ApplicationPolicy
  def visible?(item_id)
    case item_id
    when 'actividades'        then user.admin? || user.operacion? || user.finanzas?
    when 'clientes'           then user.admin? || user.operacion?
    when 'causas'             then user.admin? || user.operacion?
    when 'asesorias'          then user.admin? || user.operacion?
    when 'cargos'             then user.admin? || user.operacion?
    when 'aprobaciones'       then user.admin? || user.finanzas? 
    when 'facturas'           then user.admin? || user.finanzas? 
    when 'repositorios'       then user.admin? || user.operacion? 
    when 'laborsafe'          then user.admin? || user.operacion?
    when 'empresas'           then user.admin? || user.finanzas? 
    when 'contactos'          then user.admin? || user.finanzas? 
    when 'productos'          then user.admin? || user.finanzas? 
    when 'com_documentos'     then user.admin? || user.finanzas? 
    when 'tablas'             then user.admin? || user.operacion? || user.finanzas?
    when 'tribunales_cortes'  then user.admin? || user.operacion?
    when 'etapas_tipos'       then user.admin?
    when 'cuantias'           then user.admin?
    when 'tarifas_generales'  then user.admin?
    when 'uf_regiones'        then user.admin? || user.finanzas? 
    when 'enlaces'            then user.admin? || user.operacion?  || user.finanzas? 
    when 'feriados'           then user.admin?
    when 'administracion'     then user.admin?
    when 'nomina'             then user.admin?
    when 'personalizacion'    then user.admin?
    when 'dog'                then user.dog?
    when 'versiones'          then user.dog?
    when 'slides'             then user.dog?
    when 'global_usuarios'    then user.dog?
    else
      false
    end
  end
end