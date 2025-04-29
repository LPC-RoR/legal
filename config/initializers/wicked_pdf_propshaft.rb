# Fix for WickedPDF + Propshaft in Rails 7+
require 'mime/types'

if defined?(Propshaft)
  module WickedPdfAssetFix
    class PropshaftAsset
      def initialize(path)
        @asset = Rails.application.assets.load_path.find(path)
        raise "Asset #{path} not found" unless @asset
      end

      def content
        File.read(@asset.path)
      end

      def to_s
        content
      end

      def to_base64
        mime_type = MIME::Types.type_for(@asset.path).first.content_type
        "data:#{mime_type};base64,#{Base64.strict_encode64(content)}"
      end
    end
  end

  # Patch WickedPDF assets handling
  WickedPdf::WickedPdfHelper::Assets.module_eval do
    def asset_instance(path)
      WickedPdfAssetFix::PropshaftAsset.new(path)
    end
  end
end