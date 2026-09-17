class AddEstadoToCliAprobaciones < ActiveRecord::Migration[8.0]
  def change
    add_column :cli_aprobaciones, :estado, :integer, default: 0, null: false
    add_index  :cli_aprobaciones, :estado
  end
end
