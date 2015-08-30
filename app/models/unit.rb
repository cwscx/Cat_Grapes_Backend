class Unit < ActiveRecord::Base
  belongs_to :book, inverse_of: :units
  has_many :cases, inverse_of: :unit
end
