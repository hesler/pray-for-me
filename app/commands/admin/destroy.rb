class Admin::Destroy
  include ::Virtus.model

  attr_reader :admin

  def initialize(admin)
    @admin = admin
  end

  def call
    @admin.destroy!
    true
  end
end
