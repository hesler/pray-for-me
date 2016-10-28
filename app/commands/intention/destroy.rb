class Intention::Destroy
  include ::Virtus.model

  attr_reader :intention

  def initialize(intention)
    @intention = intention
  end

  def call
    @intention.destroy!
    true
  end
end
