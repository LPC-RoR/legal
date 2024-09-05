class CreateRepDocControlados < ActiveRecord::Migration[7.1]
  def change
    create_table :rep_doc_controlados do |t|
      t.references :ownr, polymorphic: true, null: false
      t.string :rep_doc_controlado
      t.string :archivo
      t.string :tipo
      t.string :control
      t.integer :orden

      t.timestamps
    end
    add_index :rep_doc_controlados, :rep_doc_controlado
    add_index :rep_doc_controlados, :tipo
    add_index :rep_doc_controlados, :orden
  end
end
