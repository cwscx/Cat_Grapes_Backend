class Book < ActiveRecord::Base
  has_many :units, inverse_of: :book
  validates_associated :units
end
