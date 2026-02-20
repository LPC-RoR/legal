# app/controllers/admin/mailer_previews_controller.rb
class Admin::MailerPreviewsController < Admin::BaseController
  before_action :set_context
  
  def index
    @mailers = context_mailer_classes.map do |mailer_class|
      {
        class: mailer_class,
        actions: mailer_class.action_methods,
        preview_samples: generate_preview_samples(mailer_class)
      }
    end
  end
  
  def preview
    mailer = params[:mailer].constantize
    @email = mailer.with(context_params).public_send(params[:action])
    render layout: 'mailer_preview'
  end
  
  private
  
  def set_context
    @context = params[:context] || 'investigations' # investigations|platform|support
  end
  
  def context_mailer_classes
    "Mailers::Contexts::#{@context.classify}::".constantize.constants
      .map { |c| "Mailers::Contexts::#{@context.classify}::#{c}".constantize }
      .select { |c| c < ApplicationMailer }
  end
end