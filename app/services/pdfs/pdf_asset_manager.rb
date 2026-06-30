# app/services/pdfs/pdf_asset_manager.rb
module Pdfs
  class PdfAssetManager
    ASSETS_CONFIG = {
      'usuarios_registrados' => {
        images: %w[logo.png header.png],
        fonts:  %w[OpenSans-Regular.ttf OpenSans-Bold.ttf],
        css:    %w[base.css pltfrm/usuarios.css]
      },
      'actividad_plataforma' => {
        images: %w[logo.png],
        fonts:  %w[OpenSans-Regular.ttf],
        css:    %w[base.css pltfrm/actividad.css]
      },
      'dnnc' => {
        images: %w[logo.png sign.png email_head.png email_sign.png],
        fonts:  %w[OpenSans-Regular.ttf OpenSans-Bold.ttf OpenSans-Italic.ttf],
        css:    %w[base.css invstgcns/denuncia.css]
      },
      'dclrcn' => {
        images: %w[logo.png sign.png],
        fonts:  %w[OpenSans-Regular.ttf OpenSans-Bold.ttf],
        css:    %w[base.css invstgcns/declaracion.css]
      },
      'txt_dclrcn' => {
        images: %w[logo.png],
        fonts:  %w[OpenSans-Regular.ttf],
        css:    %w[base.css invstgcns/texto.css]
      },
      'aprobacion' => {
        images: %w[logo.png],
        fonts:  %w[OpenSans-Regular.ttf OpenSans-Bold.ttf OpenSans-SemiBold.ttf],
        css:    %w[base.css fnnzs/aprobacion.css]
      },
      'balance_general' => {
        images: %w[logo.png],
        fonts:  %w[Roboto-Regular.ttf Roboto-Bold.ttf],
        css:    %w[base.css fnnzs/balance.css]
      },
      'doc_honorario' => {
        images: %w[logo.png],
        fonts:  %w[Roboto-Regular.ttf Roboto-Bold.ttf],
        css:    %w[base.css fnnzs/honorarios.css]
      },
      'ordenes_trabajo' => {
        images: %w[logo.png],
        fonts:  %w[OpenSans-Regular.ttf],
        css:    %w[base.css srvcs/ordenes.css]
      }
    }.freeze

    class << self
      def cargar_assets(reporte, contexto, empresa = nil)
        config = ASSETS_CONFIG[reporte.to_s] || default_assets
        
        {
          images: cargar_imagenes(config[:images], contexto, empresa),
          fonts:  cargar_fuentes(config[:fonts]),
          css:    cargar_css(config[:css], contexto)
        }
      end

      private

      def cargar_imagenes(nombres, contexto, empresa)
        resultado = {}
        
        nombres.each do |nombre|
          path = encontrar_imagen(nombre, contexto, empresa)
          resultado[nombre.sub(/\.[^.]+$/, '').to_sym] = path if path
        end
        
        resultado
      end

      def encontrar_imagen(nombre, contexto, empresa)
        # 1. Intentar logo/sign de la empresa (solo si responde al método)
        if empresa && nombre == 'logo.png' && empresa.respond_to?(:logo) && empresa.logo&.attached?
          return descargar_a_temporal(empresa.logo)
        end
        
        if empresa && nombre == 'sign.png' && empresa.respond_to?(:sign) && empresa.sign&.attached?
          return descargar_a_temporal(empresa.sign)
        end

        # 2. Buscar en directorio del contexto
        context_path = Rails.root.join('app', 'assets', 'pdfs', contexto.to_s, nombre)
        return context_path.to_s if File.exist?(context_path)

        # 3. Buscar en directorio genérico
        generic_path = Rails.root.join('app', 'assets', 'pdfs', 'shared', nombre)
        return generic_path.to_s if File.exist?(generic_path)

        # 4. Buscar en public
        public_path = Rails.root.join('public', 'mssgs', nombre)
        return public_path.to_s if File.exist?(public_path)

        nil
      end

      def cargar_fuentes(nombres)
        resultado = {}
        
        nombres.each do |nombre|
          path = Rails.root.join('app', 'assets', 'pdfs', 'fonts', nombre)
          resultado[nombre.sub(/\.[^.]+$/, '').to_sym] = path.to_s if File.exist?(path)
        end
        
        resultado
      end

      def cargar_css(nombres, contexto)
        nombres.map do |nombre|
          if nombre.include?('/')
            Rails.root.join('app', 'assets', 'pdfs', 'styles', nombre).to_s
          else
            Rails.root.join('app', 'assets', 'pdfs', 'styles', contexto.to_s, nombre).to_s
          end
        end.select { |p| File.exist?(p) }
      end

      def descargar_a_temporal(blob)
        extension = blob.filename.extension || 'png'
        tempfile = Tempfile.new(['pdf_asset', ".#{extension}"])
        tempfile.binmode
        
        blob.download do |chunk|
          tempfile.write(chunk)
        end
        tempfile.rewind
        
        tempfile.path
      ensure
        tempfile.close if tempfile.respond_to?(:close) && !tempfile.closed?
      end

      def default_assets
        { images: [], fonts: [], css: ['base.css'] }
      end
    end
  end
end