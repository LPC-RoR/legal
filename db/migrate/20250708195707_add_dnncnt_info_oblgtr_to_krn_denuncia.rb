class AddDnncntInfoOblgtrToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :dnncnt_info_oblgtr, :boolean
  end
end
