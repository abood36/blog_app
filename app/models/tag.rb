class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 30 }

  before_save :downcase_name

  private

  def downcase_name
    self.name = name.downcase
  end
end 