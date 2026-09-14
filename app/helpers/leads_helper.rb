module LeadsHelper
  def badge_color(estado)
    {
      "nuevo"        => "primary",
      "contactado"   => "info",
      "calificado"   => "warning",
      "convertido"   => "success",
      "descartado"   => "dark"
    }.fetch(estado, "secondary")
  end
end