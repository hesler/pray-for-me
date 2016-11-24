require 'active_model/validations'

class Admin::Create
  include ::Virtus.model
  include ::ActiveModel::Validations

  attribute :email, String
  attribute :password, String
  attribute :password_confirmation, String
  attribute :first_name, String
  attribute :last_name, String

  attr_reader :admin

  validates :email, :password, :password_confirmation, presence: true
  validates_confirmation_of :password
  validates_length_of :password, within: 8..128
  validates :email, format: { with: Devise.email_regexp, message: 'is wrong' }
  validate :email, :email_uniqueness

  def call
    @admin = Admin.new(attributes)
    validate!
    @admin.save!
  rescue ActiveModel::ValidationError
    raise CommonErrors::CommandValidationFailed
  rescue ActiveRecord::RecordInvalid => e
    raise CommonErrors::CommandValidationFailed, e.record.errors.full_messages
  end

  private

  def email_uniqueness
    raise CommonErrors::AdminAlreadyExists if Admin.where(email: @email).exists?
  end
end
