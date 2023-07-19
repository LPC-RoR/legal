class CreateBlgTemas < ActiveRecord::Migration[5.2]
  def change
    create_table :blg_temas do |t|
      t.string :blg_tema

      t.timestamps
    end
  end
end
