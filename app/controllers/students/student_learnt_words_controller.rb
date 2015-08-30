class StudentLearntWordsController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }, on: :create
  
  def index
    if request.format == "text/html"
      
    else
      if @current_student.student_learnt_words
        respond_to do |format|
          format.json {render json: {learnt_words: @current_student.student_learnt_words}, status: 200 }
        end
      else
        respond_to do |format|
          format.json {render json: {message: "Learnt Words Not Found."}, status: 404 }
        end
      end
    end
  end
  
  def new
    
  end
  
  def create
    if request.format == "text/html"
      
    else
      return_message = ""   # variables to record word conditions to return message
    
      # If a hash is in another hash, the sub-hash needs to be read as |key, value|
      request.params[:learnedWords].each do |key, value|
        if @current_student.student_learnt_words.find_by(word_id: value[:word_id])
          return_message << "Word #{value[:word_id]} already learnt! "
        else
          # The default next_test_date is null, just add the test_interval to the current date
          next_test_date = Date.current().advance(:days => +value[:test_interval].to_i)

          @current_student.student_learnt_words.create(
            word_id: value[:word_id],
            current_strength: value[:current_strength],
            strength_history: value[:current_strength].to_s,
            test_interval: value[:test_interval],
            test_date_array: value[:test_interval].to_s,
            next_test_date: next_test_date
          )
          return_message << "Word #{value[:word_id]} is newly learnt! "
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
      word_id = request.params[:learnedWords][:word_id]
      if lword = @current_student.student_learnt_words.find_by(word_id: word_id)
      
        # Check the learned word id and the passed in edit id
        if lword.id.to_i == request.params[:id].to_i
        
          # Append the new strength and test interval to histories accordingly
          strength_history = lword.strength_history
          test_date_array = lword.test_date_array  
        
        
          # If the word record is updated today already, override the history
          if lword.updated_at.beginning_of_day() == DateTime.current().beginning_of_day()
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
          strength_history << request.params[:learnedWords][:current_strength].to_s

        
          # If the word record is updated today already, override the history
          if lword.updated_at.beginning_of_day() == DateTime.current().beginning_of_day()
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
          test_date_array << request.params[:learnedWords][:test_interval].to_s

          
          
          # If the next_test_date is nil or earlier than current date, add the interval to the current time
          # Else add the interval to the recorded next test date
          next_test_date = Date.current()
          if(lword.next_test_date.nil? || lword.next_test_date < next_test_date)
            next_test_date = next_test_date.advance(:days => +request.params[:learnedWords][:test_interval].to_i)
          else
            next_test_date = lword.next_test_date.advance(:days => +request.params[:learnedWords][:test_interval].to_i)
          end
      
          # Update the student Learned Word
          StudentLearntWord.update(
            request.params[:id],
            current_strength: request.params[:learnedWords][:current_strength],
            strength_history: strength_history,
            test_interval: request.params[:learnedWords][:test_interval],
            test_date_array: test_date_array,
            next_test_date: next_test_date
          )
        
          respond_to do |format|
            format.json {render json: {message: "The word's learning condition is updated"}, status: 200}
          end
        else
          respond_to do |format|
            format.json {render json: {message: "The passed in word_id and learnt word id doesn't match"}, status: 400}
          end
        end
      else
        respond_to do |format|
          format.json {render json: {message: "The word is not even learnt yet"}, status: 304}
        end
      end
    end
  end
end
