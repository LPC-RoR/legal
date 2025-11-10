class CircuitBreaker
  STATES = %i[closed open half_open].freeze
  
  def initialize(threshold: 2, timeout: 600)
    @failure_threshold = threshold
    @timeout = timeout
    @failure_count = 0
    @last_failure_time = nil
    @state = :closed
    @mutex = Mutex.new
  end
  
  def call(&block)
    check_state
    
    begin
      result = block.call
      on_success
      result
    rescue OpenAIRateLimitError, Faraday::TooManyRequestsError => e
      on_failure
      raise e
    end
  end
  
  private
  
  def check_state
    @mutex.synchronize do
      case @state
      when :open
        if time_to_retry?
          @state = :half_open
          Rails.logger.warn("[CircuitBreaker] 🟡 Abierto → Medio-abierto")
        else
          remaining = @timeout - (Time.current - @last_failure_time)
          raise OpenAIRateLimitError, "Circuito ABIERTO. Espera #{remaining.ceil}s"
        end
      end
    end
  end
  
  def time_to_retry?
    return true unless @last_failure_time
    (Time.current - @last_failure_time) > @timeout
  end
  
  def on_success
    @mutex.synchronize do
      @failure_count = 0
      @state = :closed
      Rails.logger.info("[CircuitBreaker] ✅ Éxito. Circuito CERRADO")
    end
  end
  
  def on_failure
    @mutex.synchronize do
      @failure_count += 1
      @last_failure_time = Time.current
      
      if @failure_count >= @failure_threshold
        @state = :open
        Rails.logger.error("[CircuitBreaker] 🔴 ABIERTO por #{@timeout}s (#{@failure_count} fallos)")
      end
    end
  end
end