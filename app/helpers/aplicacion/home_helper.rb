module Aplicacion::HomeHelper

  # Genera el código QR del documento como SVG inline (no requiere gema extra)
  def codigo_qr_svg(url, size: 96)
    qr = RQRCode::QRCode.new(url.to_s)
    qr.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true,
      viewbox: true
    ).html_safe
  end
end