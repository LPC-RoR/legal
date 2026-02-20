# config/initializers/flipper.rb (o en development.rb)
if Rails.env.development?
  Flipper.enable(:use_new_platform_mailers)
end