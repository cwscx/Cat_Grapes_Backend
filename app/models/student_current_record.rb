class StudentCurrentRecord < ActiveRecord::Base
  belongs_to :student
  
  validates :video_id, presence: true, if: :no_exercise_id?
  validates :exercise_id, presence: true, if: :no_video_id?
  
  
  private
  
  def no_exercise_id?
    self.exercise_id.nil?
  end
  
  def no_video_id?
    self.video_id.nil?
  end
end
