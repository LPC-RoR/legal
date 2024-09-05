class CreateKrnLstMedidas < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_lst_medidas do |t|
      t.references :ownr, polymorphic: true, null: false
      t.string :emisor
      t.string :tipo

      t.timestamps
    end
  end
end
