class BooksController < ApiController
  before_action :set_book, only: [:show, :require_login]
  before_action :require_login, only: [:update, :destroy, :create]

  # GET /books
  def index
    #debugger
    if params[:filter_by_id]
      @books = Book.where(user_id: params[:filter_by_id]);
    elsif params[:filter_by_keyword]

    else
      @books = Book.all
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def book_params
      params.require(:book).permit(:title, :author, :user_id)
      params.permit(:filter_by_id, :filter_by_keyword)
    end
end
