require 'active_model/validations'

class Intention::Publish
  include ::Virtus.model
  include ::ActiveModel::Validations

  attr_reader :intention

  def initialize(intention)
    @intention = intention
  end

  def call
    @intention.update!(status: Intention.statuses[:published])
  end
end
