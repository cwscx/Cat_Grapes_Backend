class Video < ActiveRecord::Base
  belongs_to :case, inverse_of: :videos
end
