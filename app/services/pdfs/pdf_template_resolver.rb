# app/services/pdfs/pdf_template_resolver.rb
module Pdfs
  class PdfTemplateResolver
    def self.resolve(reporte, contexto = nil)
      ctx = contexto || ClssPdf.context_for(reporte)
      dir = ClssPdf::CONTEXT_DIRS[ctx]
      
      template_path = "pdfs/#{dir}/#{reporte}_pdf"
      template_path = "pdfs/#{dir}/generic_pdf" unless template_exists?(template_path)
      template_path = "pdfs/base/generic_pdf" unless template_exists?(template_path)
      
      template_path
    end

    def self.layout_for(reporte, contexto = nil)
      ctx = contexto || ClssPdf.context_for(reporte)
      dir = ClssPdf::CONTEXT_DIRS[ctx]
      
      # Rails busca layouts en app/views/layouts/
      # Por eso no incluimos 'layouts/' aquí, Rails lo agrega automáticamente
      layout_path = "pdfs/#{dir}/base"
      
      template_exists?(layout_path, :layout) ? layout_path : 'pdfs/base'
    end

    private

    def self.template_exists?(path, type = :template)
      if type == :layout
        # Los layouts están en app/views/layouts/
        full_path = Rails.root.join('app', 'views', 'layouts', "#{path}.html.erb")
      else
        full_path = Rails.root.join('app', 'views', "#{path}.html.erb")
      end
      
      File.exist?(full_path) || 
        ActionController::Base.view_paths.any? { |vp| File.exist?(File.join(vp, type == :layout ? 'layouts' : '', "#{path}.html.erb")) }
    end
  end
end