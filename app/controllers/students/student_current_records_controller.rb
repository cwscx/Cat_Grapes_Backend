class Students::StudentCurrentRecordsController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }, on: :create
  
  def index
    if @current_student.student_current_record
      respond_to do |format|
        format.json {render json: {current_record: @current_student.student_current_record}, status: 200 }
      end
    else
      respond_to do |format|
        format.json {render json: {message: "Records Not Found."}, status: 404 }
      end
    end
  end
  
  def new
    
  end
  
  def create
    return_message = ""   # variables to record component conditions to return message
    
    # If a hash is in another hash, the sub-hash needs to be read as |key, value|
    request.params[:learnedComponents].each do |key, value|
      if @current_student.student_learnt_components.find_by(component_id: value[:component_id])
        return_message << "Component #{value[:component_id]} already learnt! "
      else
        # The default next_test_date is null, just add the test_interval to the current date
        next_test_date = Date.current().advance(:days => +value[:test_interval].to_i)

        @current_student.student_learnt_components.create(
          component_id: value[:component_id],
          current_strength: value[:current_strength],
          strength_history: value[:current_strength].to_s,
          test_interval: value[:test_interval],
          test_date_array: value[:test_interval].to_s,
          next_test_date: next_test_date
        )
        return_message << "Component #{value[:component_id]} is newly learnt! "
      end
    end
    
    respond_to do |format|
      format.json {render json: {message: return_message}, status: :created}
    end
  end
  
  def update
    component_id = request.params[:learnedComponents][:component_id]
    if lcomponent = @current_student.student_learnt_components.find_by(component_id: component_id)
      
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
