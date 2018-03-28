class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :created_at, :updated_at
  belongs_to :user
end
