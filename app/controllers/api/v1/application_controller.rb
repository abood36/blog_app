class ApplicationController < ActionController::API
  before_action :authenticate_user

  private

  def authenticate_user
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded["user_id"]) if decoded
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
