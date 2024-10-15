class RemoveOwnerToAgeActividad < ActiveRecord::Migration[7.1]
  def change
    remove_index :age_actividades, :owner_class
    remove_column :age_actividades, :owner_class, :string
    remove_index :age_actividades, :owner_id
    remove_column :age_actividades, :owner_id, :integer

    drop_table :age_antecedentes
  end
end