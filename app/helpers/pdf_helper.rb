require 'mime/types'
require 'rqrcode'
require 'chunky_png'

module PdfHelper
  def pdf_asset_base64(path)
    asset = find_asset(path)
    content = File.read(asset.path.to_s)
    mime_type = MIME::Types.type_for(asset.path.to_s).first&.content_type || 'application/octet-stream'
    "data:#{mime_type};base64,#{Base64.strict_encode64(content)}"
  rescue => e
    raise "Failed to process #{path}: #{e.message}"
  end

  def pdf_stylesheet(path)
    asset = find_asset("#{path}.scss")
    "<style>#{File.read(asset.path.to_s)}</style>".html_safe
  rescue => e
    raise "Failed to load stylesheet #{path}.scss: #{e.message}"
  end

  # Made public for debugging purposes
  def find_asset(path)
    asset = Rails.application.assets.load_path.find(path)
    unless asset
      available = Rails.application.assets.load_path.entries.flat_map { |lp| lp.entries.map(&:logical_path) }
      raise "Asset not found: #{path}. Available assets: #{available.join(', ')}"
    end
    asset
  end

  def qr_code_as_base64(text, size: 200)
    qrcode = RQRCode::QRCode.new(text)
    png = qrcode.as_png(
      resize_gte_to: false,
      resize_exactly_to: false,
      fill: 'white',
      color: 'black',
      size: size,
      border_modules: 1,
      module_px_size: 6
    )
    
    # Convierte el PNG a base64
    "data:image/png;base64,#{Base64.strict_encode64(png.to_s)}"
  end

end