class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # Validations
  validates :content, presence: true, length: { minimum: 2, maximum: 1000 }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :with_author, -> { includes(:user) }

  # Callbacks
  after_create :notify_post_author

  private

  def notify_post_author
    return if user_id == post.user_id # Don't notify if commenter is the post author
    
    NotificationJob.perform_later(
      user_id: post.user_id,
      message: "#{user.name} commented on your post: #{post.title}"
    )
  end
end
