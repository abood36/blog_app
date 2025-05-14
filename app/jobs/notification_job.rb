class NotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id:, message:)
    user = User.find_by(id: user_id)
    return unless user

    # Here you can implement your notification logic
    # For example, sending an email, push notification, or storing in database
    Rails.logger.info "Notification for user #{user_id}: #{message}"
  end
end 