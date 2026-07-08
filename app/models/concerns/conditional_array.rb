# app/models/concerns/conditional_array.rb
module ConditionalArray
  extend ActiveSupport::Concern

  class_methods do
    # Códigos disponibles = (códigos que cumplen condición) - (códigos ya usados en TxtEditable)
    #
    # @param ownr [Object] objeto contra el que se evalúan condiciones
    # @param items [Array<Hash>] definición de códigos con condiciones
    # @param scope [ActiveRecord::Relation] scope opcional para filtrar TxtEditable (ej: del mismo ownr)
    # @return [Array<String>] códigos disponibles para crear
    def available_codes_for(ownr, items, scope: ownr.txt_editables)
      # 1. Filtrar por condiciones
      eligible = items.select do |item|
        condition = item[:condition]
        condition.nil? || condition.call(ownr)
      end.map { |item| item[:code] }

      # 2. Excluir los ya existentes en TxtEditable (dentro del scope)
#      used = scope.pluck(:codigo).uniq
#      eligible - used
      eligible
    end

    # Versión con hash de condiciones
    def available_codes_by(ownr, codes_with_conditions, scope: TxtEditable.all)
      eligible = codes_with_conditions.select do |_code, condition|
        condition.nil? || condition.call(ownr)
      end.keys

#      used = scope.pluck(:codigo).uniq
#      eligible - used
      eligible
    end

    # Versión con mappings (Symbol/Proc)
    def resolve_available_codes(ownr, mappings, scope: TxtEditable.all)
      eligible = mappings.select do |_code, check|
        case check
        when Symbol, String then ownr.public_send(check)
        when Proc then check.call(ownr)
        else true
        end
      end.keys

      used = scope.pluck(:codigo).uniq
      eligible - used
    end
  end
end