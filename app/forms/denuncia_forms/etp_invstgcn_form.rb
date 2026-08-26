module DenunciaForms
  class EtpInvstgcnForm < ApplicationForm
    attribute :evlcn_dnnc, :string
    attribute :fecha_dnnc_crrgd, :date
    attribute :vrfccn_dts_tstgs, :boolean
    attribute :fecha_termino_investigacion, :date
    attribute :etapa, :string

    validates :evlcn_dnnc, presence: true
    validates :fecha_dnnc_crrgd, presence: true, if: -> { evlcn_dnnc == 'Con observaciones' }

    def save
      return false unless valid?

      denuncia.assign_attributes(slice_attributes)
      denuncia.save!
    end

    private

    def slice_attributes
      {
        vrfccn_dts_tstgs: vrfccn_dts_tstgs,
        evlcn_dnnc: evlcn_dnnc,
        fecha_dnnc_crrgd: fecha_dnnc_crrgd,
        fecha_termino_investigacion: fecha_termino_investigacion
      }
    end
  end
end