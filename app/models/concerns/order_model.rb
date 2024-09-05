module OrderModel
  extend ActiveSupport::Concern

  def n_list
    self.list.count
  end

  def siguiente
    self.list.find_by(orden: self.orden + 1)
  end

  def anterior
    self.list.find_by(orden: self.orden - 1)
  end

end