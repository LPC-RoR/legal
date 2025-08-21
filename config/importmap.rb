# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

#pin_all_from "app/javascript/controllers", under: "controllers", preload: true
#pin_all_from "app/javascript/controllers", under: "controllers", to: "controllers"
pin "controllers/application", to: "controllers/application.js"
pin "controllers/conditional_fields", to: "controllers/conditional_fields_controller.js"
pin "controllers/prtcpnts_fields", to: "controllers/prtcpnts_fields_controller.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.7/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"


pin "echarts", to: "echarts.min.js"
pin "echarts/theme/dark", to: "echarts/theme/dark.js"