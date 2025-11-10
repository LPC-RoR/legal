class TokenCounter
  # Aproximación: 1 token ≈ 0.75 caracteres en español
  RATIO = 0.75
  
  def self.count(text)
    (text.length.to_f / RATIO).ceil
  end
  
  def self.safe_truncation(text, max_tokens: 9000)
    max_chars = (max_tokens * RATIO).to_i
    text[0...max_chars]
  end
end