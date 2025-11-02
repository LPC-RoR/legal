class CreateResponsableNotas < ActiveRecord::Migration[8.0]
  def change
    create_table :responsable_notas do |t|
      t.references :nota, null: false, foreign_key: true
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
