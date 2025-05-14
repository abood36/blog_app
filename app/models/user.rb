class User < ApplicationRecord
  has_secure_password
  has_one_attached :image

  # العلاقات
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # التحقق من البيانات
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || password.present? }
  validates :image, content_type: ['image/png', 'image/jpeg', 'image/jpg'],
                   size: { less_than: 5.megabytes }

  # Callbacks
  before_save :downcase_email
  before_create :generate_verification_token

  # Scopes
  scope :active, -> { where(active: true) }

  private

  def downcase_email
    self.email = email.downcase
  end

  def generate_verification_token
    self.verification_token = SecureRandom.hex(20)
  end
end
