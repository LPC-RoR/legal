class CreateTarDetCuantiaControles < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_det_cuantia_controles do |t|
      t.integer :tar_detalle_cuantia_id
      t.integer :control_documento_id

      t.timestamps
    end
    add_index :tar_det_cuantia_controles, :tar_detalle_cuantia_id
    add_index :tar_det_cuantia_controles, :control_documento_id
  end
end
