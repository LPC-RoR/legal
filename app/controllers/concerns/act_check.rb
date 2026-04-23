module ActCheck
  extend ActiveSupport::Concern

  def excluir
    @objeto.excluir = !!@objeto.excluir ? false : true
    @objeto.save

    redirect_to act_archivo_rdrccn(@objeto), notice: 'Modificación exitosa'
  end

end