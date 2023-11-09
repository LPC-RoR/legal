class Organizacion::ServiciosController < ApplicationController

  include Tarifas

  def aprobacion
    @objeto = TarAprobacion.find(params[:indice])
    init_tabla('tar_facturaciones', @objeto.tar_facturaciones, false)

  end

  def organizacion
    @objeto = Cliente.find(params[:oid])

    if params[:aid].blank?
      init_tabla('org_areas', @objeto.org_areas.order(:org_area), false)
      @padres_ids = nil
    else
      @area = FiloElemento.find(params[:aid])

      # limpieza de relacion con sub-elemento
      if @area.child_relations.count != @area.children.count
        children_ids = @area.children.ids
        @area.child_relations.each do |child_rel|
          child_rel.delete unless children_ids.include?(child_rel.child_id)
        end
      end

      init_tabla('org_areas', @area.children.order(:filo_elemento), false)
#      add_tabla('filo_especies', @area.filo_especies.order(:filo_especie), false)
      @padres_ids = @area.padres_ids.reverse()

      if @area.parent.blank?
        hermanos_ids = @objeto.org_areas.ids - [@area.id]
      else
        hermanos_ids = @objeto.parent.children.ids - [@area.id]
      end
      @hermanos = OrgArea.where(id: hermanos_ids).order(:org_area)

    end      
  end


  private

end
