class ResponsableNota < ApplicationRecord
  belongs_to :nota
  belongs_to :usuario
end
