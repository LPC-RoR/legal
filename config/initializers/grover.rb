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
    print_background: true, # <-- importante para Bootstrap
    launch_args: ['--no-sandbox', '--disable-setuid-sandbox']
  }
end