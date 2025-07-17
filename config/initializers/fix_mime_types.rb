Rails.application.config.after_initialize do
  ActionDispatch::Static.class_eval do
    def initialize(app, path, index: 'index', headers: {})
      super(app, path, index: index, headers: headers)
      @file_handler = ActionDispatch::FileHandler.new(
        path,
        index: index,
        headers: headers.merge('Content-Type' => 'application/javascript')
      )
    end
  end
end