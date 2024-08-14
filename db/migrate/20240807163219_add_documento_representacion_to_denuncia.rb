class AddDocumentoRepresentacionToDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :denuncias, :documento_representacion, :string
  end
end
