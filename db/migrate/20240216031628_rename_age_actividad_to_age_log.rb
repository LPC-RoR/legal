class RenameAgeActividadToAgeLog < ActiveRecord::Migration[5.2]
  def self.up
    rename_column :age_logs, :age_actividad, :actividad
  end

  def self.down
    rename_column :age_logs, :actividad, :age_actividad
  end
end
