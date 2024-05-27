class AddFieldsToAgeAntecedente < ActiveRecord::Migration[5.2]
  def change
    add_column :age_antecedentes, :nota, :string
    add_column :age_antecedentes, :tipo, :string
  end
end
