class Sentence < ActiveRecord::Base
  has_and_belongs_to_many :components
  has_and_belongs_to_many :words
end
