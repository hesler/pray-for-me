require 'active_model/validations'

class Admin::Invite
  include ::Virtus.model
  include ::ActiveModel::Validations

  attribute :email, String

  attr_reader :admin

  validates :email, presence: true
  validates :email, format: { with: Devise.email_regexp, message: 'is wrong' }
  validate :email, :email_uniqueness

  def call
    @admin = Admin.new(attributes.merge(invitation_token: generate_invitation_token))
    validate!
    @admin.save!
    send_invitation_mail
    true
  rescue ActiveModel::ValidationError
    raise CommonErrors::CommandValidationFailed
  rescue ActiveRecord::RecordInvalid => e
    raise CommonErrors::CommandValidationFailed, e.record.errors.full_messages
  end

  private

  def email_uniqueness
    raise CommonErrors::AdminAlreadyExists if Admin.where(email: @email).exists?
  end

  def generate_invitation_token
    Generators::AdminInvitationTokenService.new.call
  end

  def send_invitation_mail
    Admin::AdminMailer.invitation_mail(@admin.email, @admin.invitation_token).deliver_now
  end
end
