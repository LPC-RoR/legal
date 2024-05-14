class AddCheckToStEstado < ActiveRecord::Migration[5.2]
  def change
    add_column :st_estados, :check, :string
    add_index :st_estados, :check
  end
end
