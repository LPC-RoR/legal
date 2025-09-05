# app/helpers/companies_helper.rb
module AppLogoHelper
  def company_logo_tag(company, size: [160, 160], classes: "img-fluid")
    return image_tag("logo/fallback_logo.png", class: classes) unless company&.logo&.attached?

    if company.logo.variable?
      image_tag company.logo.variant(resize_to_limit: size), class: classes
    else
      # SVG u otro no “variable”
      image_tag url_for(company.logo), class: classes
    end
  end
end