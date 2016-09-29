require 'active_model/validations'

class Intention::Create
  include ::Virtus.model
  include ::ActiveModel::Validations

  attribute :content, String
  attribute :city, String
  attribute :region, String
  attribute :country, String
  attribute :lat, Float
  attribute :lng, Float

  attr_reader :intention

  validates :content, :country, presence: true
  validates :lat, numericality: { greater_than: -90, less_than: 90 }, allow_blank: true
  validates :lng, numericality: { greater_than: -180, less_than: 180 },  allow_blank: true

  def call
    @intention = Intention.new(attributes.merge(status: Intention.statuses[:pending]))
    validate!
    @intention.save!
  rescue ActiveModel::ValidationError
    raise CommonErrors::CommandValidationFailed
  rescue ActiveRecord::RecordInvalid => e
    raise CommonErrors::CommandValidationFailed, e.record.errors.full_messages
  end
end
