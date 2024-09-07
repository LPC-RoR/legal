class CreateKrnMotivoDerivaciones < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_motivo_derivaciones do |t|
      t.string :krn_motivo_derivacion

      t.timestamps
    end
  end
end
