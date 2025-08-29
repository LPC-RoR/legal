# config/initializers/rack_attack.rb
class Rack::Attack
  # Limita envíos al endpoint de registro
  throttle('register_by_ip', limit: 5, period: 20.seconds) do |req|
    req.ip if req.post? && req.path.match?(%r{^/register$})
  end

  # Limita requests globales (opcional)
  throttle('req/ip', limit: 300, period: 5.minutes) { |req| req.ip }

  # (Opcional) safelist de tu IP o de health checks
  # safelist('allow-localhost') { |req| ['127.0.0.1', '::1'].include?(req.ip) }
end