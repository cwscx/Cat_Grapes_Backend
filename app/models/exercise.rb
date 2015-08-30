class Exercise < ActiveRecord::Base
  belongs_to :case, inverse_of: :exercises
  
  has_and_belongs_to_many :components
  has_and_belongs_to_many :words
end
