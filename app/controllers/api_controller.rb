class ApiController < ApplicationController
  def require_login
    authenticate_token || render_unauthorized("Access Denied")
  end

  def current_user
    @current_user ||= authenticate_token
  end

  protected
    def render_unauthorized(message)
      errors = { errors: [ {detail: message} ]}
      render json: errors, status: :unauthorized
    end
  private
    def authenticate_token
      authenticate_with_http_token do |token, options|
        # compare token to prevent timing attack
        ActiveSupport::SecurityUtils.secure_compare(
                                    ::Digest::SHA256.hexdigest(token),
                                    ::Digest::SHA256.hexdigest(user.token))
        User.find_by(token: token)
      end
    end
end
