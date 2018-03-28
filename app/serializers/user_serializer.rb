class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :book_count
  has_many :books

  def book_count
    return object.books.count
  end
end
