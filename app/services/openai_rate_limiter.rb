# app/services/open_ai_rate_limiter.rb
class OpenaiRateLimiter
  include Singleton

  def initialize(requests_per_minute: 50)
    @mutex = Mutex.new
    @requests = []
    @limit = requests_per_minute
    Rails.logger.info("[OpenAIRateLimiter] 🔧 Initialized with #{requests_per_minute} requests per minute")
  end

  def wait_for_capacity
    @mutex.synchronize do
      now = Time.now
      @requests.reject! { |time| time < now - 60 }

      if @requests.size >= @limit
        sleep_until = @requests.first + 60
        sleep_time = [sleep_until - now, 0].max
        Rails.logger.info("[OpenAIRateLimiter] ⏳ Rate limit reached, sleeping for #{sleep_time.round(2)}s")
        sleep(sleep_time) if sleep_time > 0
        @requests.shift
      end

      @requests << now
      Rails.logger.info("[OpenAIRateLimiter] ✅ Capacity available, current requests in window: #{@requests.size}/#{@limit}")
    end
  end
end