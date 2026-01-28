class DropMTables < ActiveRecord::Migration[8.0]
  def change
   drop_table :m_bancos
   drop_table :m_campos
   drop_table :m_conceptos
   drop_table :m_conciliaciones
   drop_table :m_cuentas
   drop_table :m_datos
   drop_table :m_elementos
   drop_table :m_formatos
   drop_table :m_items
   drop_table :m_modelos
   drop_table :m_movimientos
   drop_table :m_periodos
   drop_table :m_registros
  end
end
