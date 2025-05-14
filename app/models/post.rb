class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :body, presence: true, length: { minimum: 10 }
  validate :at_least_one_tag

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :with_tags, -> { includes(:tags) }
  scope :with_comments, -> { includes(:comments) }
  scope :with_author, -> { includes(:user) }

  # Callbacks
  after_create :schedule_deletion

  private

  def at_least_one_tag
    errors.add(:tags, "must have at least one tag") if tags.empty?
  end

  def schedule_deletion
    PostDeletionJob.set(wait: 24.hours).perform_later(id)
  end
end
