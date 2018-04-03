class User < ApplicationRecord
  has_secure_password
  has_secure_token
  has_many :books

  def self.valid_login?(email, password)
    user = User.find_by(email: email)
    if user && user.authenticate(password)
      user
    end
  end

  def logout
    invalidate_token
  end

  # Renew token + update new token creating time
  def renew_token()
    regenerate_token
    touch(:token_created_at)
  end

  # This method is not available in has_secure_token
  def invalidate_token
    self.update_columns(token: nil)
    touch(:token_created_at)
  end

  # Get relative time for last time token was created
  def self.with_unexpired_token(token, period)
    where(token: token).where('token_created_at >= ?', period).first
  end
end
