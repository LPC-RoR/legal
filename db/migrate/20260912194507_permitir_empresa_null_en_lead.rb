class PermitirEmpresaNullEnLead < ActiveRecord::Migration[8.0]
  def up
    change_column_null :leads, :empresa_id, true
    # Aprovechamos: los leads nuevos deberían entrar como "nuevo", no con estado NULL
    change_column_default :leads, :estado, 0
    Lead.where(estado: nil).update_all(estado: 0)
  end

  def down
    # Solo reversible si no hay leads sin empresa
    raise ActiveRecord::IrreversibleMigration if Lead.where(empresa_id: nil).exists?

    change_column_default :leads, :estado, nil
    change_column_null :leads, :empresa_id, false
  end
end
