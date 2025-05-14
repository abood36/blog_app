class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :tags, :created_at
  belongs_to :user
  has_many :comments
end
