class SessionsController < ApiController
  skip_before_action :require_login, only: [:create], raise: false
  def create
    debugger
    if user = User.valid_login?(params[:email], params[:password])
      renew_token(user)
      send_token(user)
    else
      render_unauthorized("Invalid email or password!")
    end
  end

  def destroy

    head :ok
  end

  private
    def renew_token(user)
      user.regenerate_token
    end

    def send_token(user)
      render json: { token: user.token }
    end

    def logout
      current_user.invalidate_token
    end
end
