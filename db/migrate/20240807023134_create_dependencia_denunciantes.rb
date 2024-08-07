class CreateDependenciaDenunciantes < ActiveRecord::Migration[7.1]
  def change
    create_table :dependencia_denunciantes do |t|
      t.string :dependencia_denunciante

      t.timestamps
    end
  end
end
