class Generators::AdminInvitationTokenService
  def initialize
    @random_token = nil
  end

  def call
    @random_token = loop do
      token = SecureRandom.urlsafe_base64(16, false)
      break token unless Admin.exists?(invitation_token: token)
    end
  end
end
