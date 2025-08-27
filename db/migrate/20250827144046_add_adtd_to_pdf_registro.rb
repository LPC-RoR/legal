class AddAdtdToPdfRegistro < ActiveRecord::Migration[8.0]
  def change
    add_column :pdf_registros, :audtd, :boolean
  end
end
