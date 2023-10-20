class AddPresupuestoToMItem < ActiveRecord::Migration[5.2]
  def change
    add_column :m_items, :presupuesto, :decimal
  end
end
