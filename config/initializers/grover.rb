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
    executable_path: ENV.fetch('CHROME_PATH') do
      ['/usr/bin/google-chrome', 
       '/usr/bin/chromium',
       '/usr/bin/chromium-browser', 
       '/snap/bin/chromium'].find { |path| File.executable?(path) }
    end,
    
    # ⏱️ TIMEOUTS - Crítico para evitar el error
    timeout: 60000,              # 60 segundos para navegación (default: 30000)
    request_timeout: 30000,      # Timeout para requests de recursos
    convert_timeout: 60000,      # Timeout para conversión a PDF
    
    # 🚀 Optimizaciones para carga más rápida
    wait_until: 'networkidle2',  # Espera a que la red esté más inactiva (más rápido que networkidle0)
    # wait_until: 'domcontentloaded', # Alternativa más rápida si networkidle2 sigue lento
    
    print_background: true,
    prefer_css_page_size: true,
    display_header_footer: true,
    
    # 🔧 Launch args mejorados
    launch_args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',      # Evita problemas de memoria en Docker/VMs
      '--disable-gpu',
      '--disable-software-rasterizer',
      '--disable-extensions',         # Más rápido sin extensiones
      '--disable-images',             # Opcional: desactiva imágenes si no son críticas
    ],
    
    # 🐛 Debug (opcional - quitar en producción)
    raise_on_request_failure: true,   # Lanza error si falla carga de recursos (útil para debug)
    # display_url: 'http://localhost:3000' # Ayuda a resolver URLs relativas
  }
end