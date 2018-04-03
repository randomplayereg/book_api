class UsersController < ApiController
  # before_action :set_user, only: [:show, :update, :destroy, :check_admin]
  before_action :set_user, except: [:index, :create]
  before_action :require_login, only: [:update, :destroy, :check_admin, :require_either_admin_or_same_user]
  before_action :require_either_admin_or_same_user, only: [:update, :destroy]
  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/1
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    debugger
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    if @user.destroy
      render json: {}, status: :ok
    end
  end

  # GET /users/1/check_admin
  def check_admin
    if @user.admin
      render json: {admin: true}, status: :ok
    else
      render json: {admin: false}, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      #params.require(:user).permit(:username, :email, :password)
      params.permit(:username, :email, :password)
    end

    def require_either_admin_or_same_user
      debugger
      if @user.id != current_user.id && current_user.admin == false
        render_unauthorized("Access denied!")
      end
    end
end
