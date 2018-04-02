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

  # This method is not available in has_secure_token
  def invalidate_token
    self.update_columns(token: nil)
  end
end
