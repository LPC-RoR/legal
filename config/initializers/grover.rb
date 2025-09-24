# config/initializers/grover.rb
Grover.configure do |config|
  config.options = {
    format: 'A4',
    print_media_type: false,
    prefer_css_page_size: true,
    launch_args: ['--no-sandbox', '--disable-setuid-sandbox']
  }
end