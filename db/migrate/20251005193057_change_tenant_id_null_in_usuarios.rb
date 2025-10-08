class ChangeTenantIdNullInUsuarios < ActiveRecord::Migration[8.0]
  def change
    change_column_null :usuarios, :tenant_id, true
  end
end
