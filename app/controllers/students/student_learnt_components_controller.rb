class Students::StudentLearntComponentsController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }, on: :create
  
  before_action :authenticate_student!
  
  def index
    if request.format == "text/html"
      
    else
      if current_student.student_learnt_components
        respond_to do |format|
          format.json {render json: {learnt_components: current_student.student_learnt_components}, status: 200 }
        end
      else
        respond_to do |format|
          format.json {render json: {message: "Learnt Components Not Found."}, status: 404 }
        end
      end
    end
  end
  
  def new
    
  end
  
  def create
    if request.format == "text/html"
      
    else
      return_message = ""   # variables to record component conditions to return message
    
      # If a hash is in another hash, the sub-hash needs to be read as |key, value|
      request.params[:learnedComponents].each do |key, value|
        if current_student.student_learnt_components.find_by(component_id: value[:component_id])
          return_message << "Component #{value[:component_id]} Already Learnt!\n"
        else
          # The default next_test_date is null, just add the test_interval to the current date
          next_test_date = Date.current().advance(:days => +value[:test_interval].to_i)

          new_component = current_student.student_learnt_components.new(
            component_id: value[:component_id],
            current_strength: value[:current_strength],
            strength_history: value[:current_strength].to_s,
            test_interval: value[:test_interval],
            test_date_array: value[:test_interval].to_s,
            next_test_date: next_test_date
          )
          
          if new_component.save
            return_message << "Component #{value[:component_id]} Is Learnt!\n"
          else
            return_message << "Component #{value[:component_id]} Creation Failure!\n"
          end
        end
      end
    
      respond_to do |format|
        format.json {render json: {message: return_message}, status: :created}
      end
    end
  end
  
  def update
    if request.format == "text/html"
      
    else
      component_id = request.params[:learnedComponents][:component_id]
      if lcomponent = @current_student.student_learnt_components.find_by(component_id: component_id)
      
        # Check the learned component id and the passed in edit id
        if lcomponent.id.to_i == request.params[:id].to_i
        
          # Append the new strength and test interval to histories accordingly
          strength_history = lcomponent.strength_history
          test_date_array = lcomponent.test_date_array 
        
          # If the component record is updated today already, override the history
          if lcomponent.updated_at.beginning_of_day() == DateTime.current().beginning_of_day()
            # If the history is not nil, try to find the last element start with ','.
            # If nothing found, there's only one record in history, set the history to nil directly
            if !(strength_history.nil? || strength_history == "")
              begin 
                strength_history[/\s*,\s*/, -1] = ""
              rescue Exception => e
                strength_history = ""
              end
            end
          end
          # If the history is nil or has nothing, don't append ','
          if !(strength_history.nil? || strength_history == "")
            strength_history << ','
          end
          strength_history << request.params[:learnedComponents][:current_strength].to_s

        
          # If the component record is updated today already, override the history
          if lcomponent.updated_at.beginning_of_day() == DateTime.current().beginning_of_day()
            # If the history is not nil, try to find the last element start with ','.
            # If nothing found, there's only one record in history, set the history to nil directly
            if !(test_date_array.nil? || test_date_array == "")
              begin
                test_date_array[/\s*,\s*/, -1] = ""
              rescue
                test_date_array = ""
              end
            end
          end
          # If the history is nil or has nothing, don't append ','
          if !(test_date_array.nil? || test_date_array == "")
            test_date_array << ','
          end
          test_date_array << request.params[:learnedComponents][:test_interval].to_s
          
          
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
end
