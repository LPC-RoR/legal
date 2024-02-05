class AddDiaSemanaToCalDia < ActiveRecord::Migration[5.2]
  def change
    add_column :cal_dias, :dia_semana, :string
    add_index :cal_dias, :dia_semana
  end
end
