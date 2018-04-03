class SessionsController < ApiController
  #skip_before_action :require_login, only: [:create], raise: false
  before_action :require_login, only: [:destroy]
  def create
    if user = User.valid_login?(params[:email], params[:password])
      user.renew_token
      send_token_and_user_id(user)
    else
      render_unauthorized("Invalid email or password!")
    end
  end

  def destroy
    current_user.logout
    head :ok
  end

  private
    def send_token_and_user_id(user)
      render json: { token: user.token, user_id: user.id, username: user.username }
    end
end
