class CreateKrnInvestigadores < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_investigadores do |t|
      t.string :krn_investigador
      t.string :rut
      t.string :email

      t.timestamps
    end
  end
end
