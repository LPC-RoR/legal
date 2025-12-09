# config/initializers/grover.rb
Grover.configure do |config|
  config.options = {
    format: 'A4',
    margin: {
      top: '1cm',
      bottom: '1cm',
      left: '1cm',
      right: '1cm'
    },
    # ✅ Ruta explícita de Chrome/Chromium
    executable_path: ENV.fetch('CHROME_PATH') do
      # Rutas comunes en diferentes sistemas
      ['/usr/bin/google-chrome', 
       '/usr/bin/chromium',
       '/usr/bin/chromium-browser', 
       '/snap/bin/chromium'].find { |path| File.executable?(path) }
    end,
    print_background: true, # <-- importante para Bootstrap
    launch_args: ['--no-sandbox', '--disable-setuid-sandbox'],
    prefer_css_page_size: true,
    display_header_footer: true # Habilita globalmente
  }
end