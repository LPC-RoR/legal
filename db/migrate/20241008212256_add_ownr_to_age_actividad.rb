class AddOwnrToAgeActividad < ActiveRecord::Migration[7.1]
  def change
    add_column :age_actividades, :ownr_type, :string
    add_index :age_actividades, :ownr_type
    add_column :age_actividades, :ownr_id, :integer
    add_index :age_actividades, :ownr_id
  end
end
