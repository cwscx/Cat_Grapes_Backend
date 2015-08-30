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
      component_id = request.params[:learnedComponents][:component_id]
      if lcomponent = current_student.student_learnt_components.find_by(component_id: component_id)
      
        # Check the learned component id and the passed in edit id
        if lcomponent.id.to_i == request.params[:id].to_i
          # Append the new strength and test interval to histories accordingly
          strength_history = test_date_array = ""  
          if lcomponent.strength_history.nil? || lcomponent.strength_history == ""
            strength_history = lcomponent.strength_history << request.params[:learnedComponents][:current_strength].to_s
          else
            strength_history = lcomponent.strength_history << ',' << request.params[:learnedComponents][:current_strength].to_s
          end
        
          if lcomponent.test_date_array.nil? || lcomponent.test_date_array == ""
            test_date_array = lcomponent.test_date_array << request.params[:learnedComponents][:test_interval].to_s
          else
            test_date_array = lcomponent.test_date_array << ',' << request.params[:learnedComponents][:test_interval].to_s
          end
          
          
          # If the next_test_date is nil or earlier than current date, add the interval to the current time
          # Else add the interval to the recorded next test date
          next_test_date = Date.current()
          if(lcomponent.next_test_date.nil? || lcomponent.next_test_date < next_test_date)
            next_test_date = next_test_date.advance(:days => +request.params[:learnedComponents][:test_interval].to_i)
          else
            next_test_date = lcomponent.next_test_date.advance(:days => +request.params[:learnedComponents][:test_interval].to_i)
          end
      
          # Update the student Learned Component
          StudentLearntComponent.update(
            request.params[:id],
            current_strength: request.params[:learnedComponents][:current_strength],
            strength_history: strength_history,
            test_interval: request.params[:learnedComponents][:test_interval],
            test_date_array: test_date_array,
            next_test_date: next_test_date
          )
        
          respond_to do |format|
            format.json {render json: {message: "The component's learning condition is updated"}, status: 200}
          end
        else
          respond_to do |format|
            format.json {render json: {message: "The passed in component_id and learnt component id doesn't match"}, status: 400}
          end
        end
      else
        respond_to do |format|
          format.json {render json: {message: "The component is not even learnt yet"}, status: 304}
        end
      end
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
