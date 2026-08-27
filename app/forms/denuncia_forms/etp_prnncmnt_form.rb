module DenunciaForms
  class EtpPrnncmntForm < ApplicationForm
    attribute :fecha_recepcion_pronunciamiento, :date
    attribute :prnncmnt_vncd, :boolean
    attribute :prnncmnt, :string
    attribute :etapa, :string

#    validates :evlcn_dnnc, presence: true
    validates :prnncmnt, presence: true, if: -> { fecha_recepcion_pronunciamiento.present? }

    def save
      return false unless valid?

      denuncia.assign_attributes(slice_attributes)
      denuncia.save!
    end

    private

    def slice_attributes
      {
        prnncmnt_vncd: prnncmnt_vncd,
        fecha_recepcion_pronunciamiento: fecha_recepcion_pronunciamiento,
        prnncmnt: prnncmnt
      }
    end
  end
end