class Students::StudentCurrentRecordsController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }, on: :create
  
  before_action :authenticate_student!
  
  def index
    if request.format == "text/html"
      
    else
      if current_student.student_current_record
        record_valid?(current_student.student_current_record)
        
        respond_to do |format|
          format.json {render json: {
            current_record: {
              book_id: current_student.student_current_record.book_id,
              unit_id: current_student.student_current_record.unit_id,
              case_id: current_student.student_current_record.case_id,
              exercise_id: current_student.student_current_record.exercise_id,
              video_id: current_student.student_current_record.video_id,
            },
            status: 200}
          }
        end
      else
        respond_to do |format|
          format.json {render json: {message: "Records Not Found."}, status: 404 }
        end
      end
    end
  end
  
  def update
    if request.format == "text/html"
      
    else
      
    end
  end
  
  private

  def record_valid?(rec)
    if ((rec.exercise_id.nil? && rec.video_id.nil?) || (!rec.exercise_id.nil? && !rec.video_id.nil?))
      respond_to do |format|
        format.json {render json: {message: "Invalid Record"}, status: 500}
      end
    end
  end
end
