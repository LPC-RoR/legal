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
    
    # ⏱️ TIMEOUTS - Solo opciones válidas para Grover 1.2.3
    timeout: 120000,              # Aumentar a 120 segundos para HTML pesado
    wait_for_timeout: 10000,       # Timeout para wait_for_function (default: small)
    
    # 🚀 Estrategia de espera más agresiva
    wait_until: 'domcontentloaded', # Más rápido: solo espera DOM, no recursos externos
    
    print_background: true,
    prefer_css_page_size: true,
    display_header_footer: true,
    
    # 🔧 Args de Chrome (dentro de options, no launch_args)
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--disable-gpu',
      '--disable-software-rasterizer',
      '--disable-extensions',
      '--disable-background-networking',
      '--disable-background-timer-throttling',
      '--disable-backgrounding-occluded-windows',
      '--disable-breakpad',
      '--disable-client-side-phishing-detection',
      '--disable-component-update',
      '--disable-default-apps',
      '--disable-features=TranslateUI',
      '--disable-hang-monitor',
      '--disable-ipc-flooding-protection',
      '--disable-popup-blocking',
      '--disable-prompt-on-repost',
      '--disable-renderer-backgrounding',
      '--force-color-profile=srgb',
      '--metrics-recording-only',
      '--safebrowsing-disable-auto-update',
      '--enable-automation',
      '--password-store=basic',
      '--use-mock-keychain',
      '--headless=new'  # Nuevo modo headless más estable
    ]
  }
end