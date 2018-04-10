class BooksController < ApiController
  # before_action :set_book, only: [:show, :update, :destroy]
  before_action :set_book, except: [:index, :create, :total]
  before_action :require_login, only: [:update, :destroy, :create, :require_either_admin_or_same_user]
  before_action :require_either_admin_or_same_user, only: [:update, :destroy]

  # GET /books
  def index
    params.permit(:filter_by_id, :filter_by_keyword, :sort_by)

    if params[:filter_by_id]
      @books = Book.where(user_id: params[:filter_by_id]);
    elsif params[:filter_by_keyword]

    else
      @books = Book.all
    end

    if params[:sort_by] == "newest"
      @books.order!(updated_at: :desc)
    end
    if params[:sort_by] == "oldest"
      @books.order!(updated_at: :asc)
    end
    if params[:sort_by] == "title"
      @books.order!(title: :asc)
    end

    if params[:page]
      @books = @books.limit(5).offset((params[:page].to_i - 1) * 5)
    else
      @books = @books.limit(5)
    end

    render json: @books, status: :ok
  end
  # GET /books/1
  def show

    render json: @book, status: :ok#, serializer: BookSerialize
    # render json: @book,  fields: { books: [:title, :author, user: [:email, :username]] }
  end

  # POST /books
  def create

    @book = Book.new(book_params)
    @book.user_id = current_user.id

    if @book.save
      render json: @book, status: :created, location: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /books/1
  def update

    if @book.update(book_params)
      render json: @book, status: :ok
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # DELETE /books/1
  def destroy
    if @book.destroy
      render json: {}, status: :ok
    end
  end

  # GET /books/total
  def total
    render json: {total: Book.count}, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def book_params
      params.require(:book).permit(:title, :author)
    end

    def require_either_admin_or_same_user
      if @book.user_id != current_user.id && current_user.admin == false
        render_unauthorized("Access denied!")
      end
    end
end
