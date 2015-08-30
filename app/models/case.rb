class Case < ActiveRecord::Base
  belongs_to :unit, inverse_of: :cases
  has_many :videos, inverse_of: :case
  has_many :exercises, inverse_of: :case
end
