class OpenaiRateLimiter
  include Singleton
  
  MAX_REQUESTS = 30
  WINDOW_SECONDS = 60
  WAIT_TIME = 65  # Espera 65s para asegurar ventana nueva
  
  def initialize
    @mutex = Mutex.new
    @requests = []
  end
  
  def wait_for_capacity
    @mutex.synchronize do
      loop do
        cleanup_old_requests
        
        if @requests.size < MAX_REQUESTS
          @requests << Time.current
          Rails.logger.info("[OpenaiRateLimiter] ✅ Request allowed: #{@requests.size}/#{MAX_REQUESTS}")
          break
        end
        
        Rails.logger.warn("[OpenaiRateLimiter] 🚫 Rate limit reached: #{@requests.size}/#{MAX_REQUESTS}. Waiting #{WAIT_TIME}s")
        @mutex.sleep(WAIT_TIME)  # Espera sin liberar el mutex
        redo  # Vuelve al inicio del loop
      end
    end
  end
  
  private
  
  def cleanup_old_requests
    now = Time.current
    @requests.reject! { |timestamp| timestamp < now - WINDOW_SECONDS.seconds }
  end
end