class Intention < ActiveRecord::Base
  enum status: [:pending, :published, :rejected]
end
