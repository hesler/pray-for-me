require 'active_model/validations'

class Intention::Reject
  include ::Virtus.model
  include ::ActiveModel::Validations

  attr_reader :intention

  def initialize(intention)
    @intention = intention
  end

  def call
    @intention.update!(status: Intention.statuses[:rejected])
  end
end
