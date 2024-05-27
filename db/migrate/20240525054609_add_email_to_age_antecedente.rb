class AddEmailToAgeAntecedente < ActiveRecord::Migration[5.2]
  def change
    add_column :age_antecedentes, :email, :string
  end
end
