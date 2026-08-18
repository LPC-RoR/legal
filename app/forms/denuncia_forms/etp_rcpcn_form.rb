# app/forms/denuncia_forms/etp_rcpcn_form.rb
module DenunciaForms
  class EtpRcpcnForm < ApplicationForm
    attribute :ownr_type, :string
    attribute :ownr_id, :integer
    attribute :etapa, :string
    attribute :fecha_hora, :datetime
    attribute :identificador, :string
    attribute :motivo_denuncia, :string
    attribute :receptor_denuncia, :string
    attribute :krn_empresa_externa_id, :integer
    attribute :via_declaracion, :string
    attribute :tipo_declaracion, :string
    attribute :presentado_por, :string
    attribute :representante, :string
    attribute :lugar_ocurrencia, :string
    attribute :direccion_ocurrencia, :string
    attribute :dnncnt_optn_invstgcn, :string
    attribute :emprs_optn_invstgcn, :string
    attribute :vrfccn_dts_incmbnts, :boolean

    validates :fecha_hora, :identificador, :motivo_denuncia, :receptor_denuncia, :via_declaracion, :presentado_por,
      :lugar_ocurrencia, :direccion_ocurrencia, :dnncnt_optn_invstgcn, presence: true
    validates :krn_empresa_externa_id, presence: true, if: -> { receptor_denuncia == 'Empresa externa' }
    validates :tipo_declaracion, presence: true, if: -> { via_declaracion == 'Presencial' }
    validates :representante, presence: true, if: -> { presentado_por == 'Representante' }

    def save
      return false unless valid?

      # Precargamos ownr como objeto (como te sugerí antes)
      if ownr_type.present? && ownr_id.present?
        denuncia.ownr = ownr_type.constantize.find(ownr_id)
      end

      denuncia.assign_attributes(slice_attributes)
      denuncia.etapa = 'etp_rcpcn' if denuncia.new_record?
      denuncia.save!
    end

    private

    def slice_attributes
      {
        fecha_hora: fecha_hora,
        identificador: identificador,
        motivo_denuncia: motivo_denuncia,
        receptor_denuncia: receptor_denuncia,
        krn_empresa_externa_id: krn_empresa_externa_id,
        via_declaracion: via_declaracion,
        tipo_declaracion: tipo_declaracion,
        presentado_por: presentado_por,
        representante: representante,
        lugar_ocurrencia: lugar_ocurrencia,
        direccion_ocurrencia: direccion_ocurrencia,
        dnncnt_optn_invstgcn: dnncnt_optn_invstgcn,
        emprs_optn_invstgcn: emprs_optn_invstgcn,
        vrfccn_dts_incmbnts: vrfccn_dts_incmbnts
      }.compact  # .compact elimina los nils (campos vacíos opcionales)
    end

  end
end