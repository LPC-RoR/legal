module DenunciaForms
  class EtpPrnncmntForm < ApplicationForm
    attribute :fecha_recepcion_pronunciamiento, :date
    attribute :prnncmnt_vncd, :boolean
    attribute :etapa, :string

#    validates :evlcn_dnnc, presence: true
#    validates :fecha_dnnc_crrgd, presence: true, if: -> { evlcn_dnnc == 'Con observaciones' }

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
      }
    end
  end
end