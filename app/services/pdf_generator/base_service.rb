module PdfGenerator
  class BaseService
    include ActionView::Helpers::NumberHelper
    
    def initialize(registro, opciones = {})
      @registro = registro
      @opciones = opciones
    end

    def generar_y_guardar
      raise NotImplementedError, "Implementar en #{self.class.name}"
    end
    
    protected
    
def renderizar_template(template_nombre, assigns = {})
  # ✅ 1. Crear controller
  controller = ActionController::Base.new
  
  # ✅ 2. Crear request con hash básico (solo un argumento)
  request = ActionDispatch::TestRequest.create({
    "REQUEST_METHOD" => "GET",
    "HTTP_HOST" => "#{host}:#{puerto}",
    "rack.url_scheme" => protocol
  })
  
  # ✅ 3. CRÍTICO: Inyectar Warden mock DIRECTAMENTE al env
  if defined?(Warden)
    request.env['warden'] = Warden::Proxy.new({}, Warden::Manager.new({}))
  end
  
  # ✅ 4. Asignar request al controller
  controller.instance_variable_set(:@_request, request)
  
  # ✅ 5. Incluir helpers
  controller.class.include(Rails.application.routes.url_helpers)
  
  # ✅ 6. Renderizar (antes de esto, definir mocks si el template usa helpers)
  definir_devise_mocks(controller) if defined?(Devise)
  
  html = controller.render_to_string(
    template: "rprts/pdf_reportes/templates/#{template_nombre}",
    layout: 'rprts/pdf_reportes/layouts/pdf',
    assigns: base_assigns.merge(assigns)
  )
  
  # ✅ 7. Preprocesar
  host_url = "#{protocol}://#{host}:#{puerto}/"
  Grover::HTMLPreprocessor.process(html, host_url, protocol)
end

def generar_pdf(html, extra_options = {})
  host_url = "#{protocol}://#{host}:#{puerto}/"
  
  opciones = {
    display_url: host_url,
    format: 'A4',
    print_background: true,
    margin: { top: '30px', right: '25px', bottom: '50px', left: '25px' },
    display_header_footer: true,
    footer_template: footer_template
  }.merge(extra_options)
  
  Rails.logger.info "🎯 Grover.new llamado con opciones: #{opciones.inspect}"
  
  # ✅ Llamada con splat operator explícito
  grover = Grover.new(html, **opciones)
  
  Rails.logger.info "🎯 grover.to_pdf llamado"
  result = grover.to_pdf
  Rails.logger.info "✅ PDF generado (#{result.bytesize} bytes)"
  
  result
end
    
    def guardar_en_act_archivo(pdf_content, tipo = nil)
      tipo ||= nombre_clase
      
      act_archivo = @registro.act_archivo || @registro.build_act_archivo(
        act_archivo: tipo
      )
      
      act_archivo.pdf.purge if act_archivo.pdf.attached?
      
      act_archivo.pdf.attach(
        io: StringIO.new(pdf_content),
        filename: nombre_archivo,
        content_type: 'application/pdf'
      )
      
      act_archivo.save!
    end
    
    private
    
    def mock_request
      ActionDispatch::TestRequest.create(
        "HTTP_HOST" => "#{host}:#{puerto}",
        "rack.url_scheme" => protocol
      )
    end
    
    def define_devise_mocks(view)
      # ✅ Definir mocks si el template usa Devise helpers
      if defined?(Devise)
        view.define_singleton_method(:current_user) { nil } # o User.first si necesitas un usuario
        view.define_singleton_method(:user_signed_in?) { false }
        view.define_singleton_method(:current_admin) { nil } # si usas Devise con múltiples modelos
      end
    end
    
    def base_assigns
      { record: @registro, opciones: @opciones }
    end
    
    def pdf_options
      {}
    end
    
    def nombre_clase
      @registro.class.name.underscore
    end
    
    def nombre_archivo
      "#{nombre_clase}_#{@registro.id}_#{Time.current.strftime('%Y%m%d_%H%M%S')}.pdf"
    end
    
def definir_devise_mocks(controller)
  # ✅ Definir helpers antes de renderizar (asegura que no llamen a request.env)
  controller.define_singleton_method(:current_user) { nil }
  controller.define_singleton_method(:user_signed_in?) { false }
  controller.define_singleton_method(:current_admin) { nil } if defined?(Admin)
end

def host
  Rails.application.routes.default_url_options[:host] || 'localhost'
end

def puerto
  Rails.application.routes.default_url_options[:port] || 3000
end

def protocol
  Rails.application.routes.default_url_options[:protocol] || 'http'
end

    def display_url
      "#{protocol}://#{host}:#{puerto}/"
    end
    
    def footer_template
      '<div style="font-size: 10px; text-align: center; width: 100%; padding: 10px;">
        Página <span class="pageNumber"></span> de <span class="totalPages"></span>
      </div>'
    end
  end
end