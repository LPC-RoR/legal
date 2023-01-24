class CreateTipoCausas < ActiveRecord::Migration[5.2]
  def change
    create_table :tipo_causas do |t|
      t.string :tipo_causa

      t.timestamps
    end
    add_index :tipo_causas, :tipo_causa
  end
end
