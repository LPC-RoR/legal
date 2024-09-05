class CreateKrnLstModificaciones < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_lst_modificaciones do |t|
      t.references :ownr, polymorphic: true, null: false
      t.string :emisor

      t.timestamps
    end
  end
end
