# app/services/pdfs/pdf_ferrum_engine.rb
module Pdfs
  class PdfFerrumEngine
    FERRUM_TIMEOUT = 60
    PAGE_TIMEOUT   = 45
    PDF_TIMEOUT    = 45

    # Logos por contexto
    LOGO_DEFAULT_PATH = Rails.root.join('app', 'assets', 'images', 'logo', 'tyc_60.png').freeze
    LOGO_INVESTIGACIONES_FALLBACK = Rails.root.join('app', 'assets', 'images', 'logo', 'logo_60.png').freeze

    class << self
      def generate(html, options = {})
        browser = nil
        tempfile = nil
        
        begin
          browser_path = detect_browser_path
          
          browser = Ferrum::Browser.new(
            headless: true,
            browser_path: browser_path,
            timeout: FERRUM_TIMEOUT,
            window_size: [1280, 1024],
            args: chrome_args
          )

          page = browser.create_page
          page.timeout = PAGE_TIMEOUT

          tempfile = Tempfile.new(['pdf_reporte', '.html'])
          tempfile.write(html)
          tempfile.flush
          
          file_url = "file://#{tempfile.path}"
          
          Rails.logger.info "[FerrumEngine] Cargando: #{tempfile.path}, HTML: #{html.length} chars"
          
          page.go_to(file_url)
          page.network.wait_for_idle(timeout: PAGE_TIMEOUT)
          sleep 1.5

          header_template = build_header_template(options[:header_logo_data_url])
          footer_template = build_footer_template(options[:empresa])

          Rails.logger.info "[FerrumEngine] Generando PDF con header logo"

          pdf_data = page.pdf(
            paper_width:  options[:paper_width]  || 8.5,
            paper_height: options[:paper_height] || 11.0,
            margin_top:    options[:margin_top]    || 0.79,
            margin_bottom: options[:margin_bottom] || 0.98,
            margin_left:   options[:margin_left]   || 0.39,
            margin_right:  options[:margin_right]  || 0.39,
            print_background: true,
            display_header_footer: true,
            header_template: header_template,
            footer_template: footer_template,
            encoding: :binary,
            timeout: PDF_TIMEOUT
          )

          pdf_data.force_encoding('ASCII-8BIT')
          
          Rails.logger.info "[FerrumEngine] PDF generado: #{pdf_data.length} bytes, válido: #{pdf_data.start_with?('%PDF')}"
          
          pdf_data

        rescue => e
          Rails.logger.error "[FerrumEngine] Error: #{e.class} - #{e.message}"
          raise
        ensure
          page&.close
          tempfile&.close
          tempfile&.unlink
          browser&.quit
        end
      end

      # ============================================
      # RESOLVER LOGO POR CONTEXTO
      # ============================================
      def resolve_header_logo(contexto, empresa = nil)
        case contexto
        when :invstgcns
          # Investigaciones: logo de empresa, o fallback logo_60.png
          logo_empresa_data_url(empresa) || logo_investigaciones_fallback
        else
          # Plataforma, Finanzas, Servicios: logo fijo tyc_60
          logo_default_data_url
        end
      end

      private

      def build_header_template(logo_data_url)
        return default_header_template if logo_data_url.blank?

        <<~HTML
          <style>
            #header { padding: 0 !important; margin: 0 !important; }
          </style>
          <div style="width: 100%; padding: 5mm 10mm 2mm 10mm; margin: 0;">
            <div style="text-align: left;">
              <img src="#{logo_data_url}" style="height: 30px; width: auto;" alt="Logo">
            </div>
          </div>
        HTML
      end

      def default_header_template
        '<div></div>'
      end

      def build_footer_template(empresa)
        razon_social = empresa&.respond_to?(:razon_social) ? empresa.razon_social : "Empresa"
        fecha = I18n.l(Time.current, format: :long)

        <<~HTML
          <div style="font-size: 8pt; font-family: 'Open Sans', sans-serif; 
                      width: 100%; padding: 0 15mm; margin-bottom: 10mm;">
            <span style="color: #adb5bd;">#{razon_social}</span>
            <span style="color: #adb5bd; float: right; font-size: 7pt;">#{fecha}</span>
          </div>
        HTML
      end

      def logo_default_data_url
        @logo_default_data_url ||= path_to_data_url(LOGO_DEFAULT_PATH)
      end

      def logo_investigaciones_fallback
        @logo_investigaciones_fallback ||= path_to_data_url(LOGO_INVESTIGACIONES_FALLBACK)
      end

      def logo_empresa_data_url(empresa)
        return nil unless empresa&.respond_to?(:logo) && empresa.logo&.attached?

        descargar_blob_a_data_url(empresa.logo)
      rescue => e
        Rails.logger.error "[FerrumEngine] Error leyendo logo empresa: #{e.message}"
        nil
      end

      def path_to_data_url(path)
        return nil unless File.exist?(path)

        data = File.binread(path)
        mime_type = Marcel::MimeType.for(Pathname.new(path)) || 'image/png'
        base64 = Base64.strict_encode64(data)
        
        "data:#{mime_type};base64,#{base64}"
      rescue => e
        Rails.logger.error "[FerrumEngine] Error convirtiendo logo: #{e.message}"
        nil
      end

      def descargar_blob_a_data_url(blob)
        extension = blob.filename.extension || 'png'
        tempfile = Tempfile.new(['logo_empresa', ".#{extension}"])
        tempfile.binmode
        
        blob.download do |chunk|
          tempfile.write(chunk)
        end
        tempfile.rewind
        
        data = File.binread(tempfile.path)
        mime_type = Marcel::MimeType.for(Pathname.new(tempfile.path)) || 'image/png'
        base64 = Base64.strict_encode64(data)
        
        "data:#{mime_type};base64,#{base64}"
      ensure
        tempfile&.close
        tempfile&.unlink
      end

      def chrome_args
        [
          "--no-sandbox",
          "--disable-dev-shm-usage",
          "--disable-gpu",
          "--disable-software-rasterizer",
          "--disable-extensions",
          "--disable-background-networking",
          "--disable-sync",
          "--disable-translate",
          "--disable-default-apps",
          "--mute-audio",
          "--no-first-run",
          "--memory-pressure-off",
          "--max_old_space_size=4096"
        ]
      end

      def detect_browser_path
        candidates = [
          '/usr/bin/google-chrome-stable',
          '/usr/bin/google-chrome',
          '/usr/bin/chromium-browser',
          '/usr/bin/chromium',
          '/mnt/c/Program Files/Google/Chrome/Application/chrome.exe'
        ]
        
        candidates.find { |path| File.exist?(path) } || 
          raise("No se encontró Chrome/Chromium")
      end
    end
  end
end