module DenunciaForms
  class EtpMddsSncnsForm < ApplicationForm
    attribute :causal_establecida, :boolean
    attribute :etapa, :string

#    validates :evlcn_dnnc, presence: true
#    validates :prnncmnt, presence: true, if: -> { fecha_recepcion_pronunciamiento.present? }

    def save
      return false unless valid?

      denuncia.assign_attributes(slice_attributes)
      denuncia.save!
    end

    private

    def slice_attributes
      {
        causal_establecida: causal_establecida
      }
    end
  end
end