class PostDeletionJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find_by(id: post_id)
    return unless post

    post.destroy
  rescue ActiveRecord::RecordNotFound
    # Post was already deleted
  end
end 