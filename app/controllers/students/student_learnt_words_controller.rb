class Students::StudentLearntWordsController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }, on: :create
  
  before_action :authenticate_student!
  
  def index
    if request.format == "text/html"
      
    else
      if current_student.student_learnt_words
        respond_to do |format|
          format.json {render json: {learnt_words: current_student.student_learnt_words}, status: 200 }
        end
      else
        respond_to do |format|
          format.json {render json: {message: "Learnt Words Not Found."}, status: 404 }
        end
      end
    end
  end

  
  def create
    if request.format == "text/html"
      
    else
      return_message = ""   # variables to record word conditions to return message
    
      # If a hash is in another hash, the sub-hash needs to be read as |key, value|
      request.params[:learnedWords].each do |key, value|
        if current_student.student_learnt_words.find_by(word_id: value[:word_id])
          return_message << "Word #{value[:word_id]} Already Learnt!\n"
        else
          # The default next_test_date is null, just add the test_interval to the current date
          next_test_date = Date.current().advance(:days => +value[:test_interval].to_i)

          new_word = current_student.student_learnt_words.new(
            word_id: value[:word_id],
            current_strength: value[:current_strength],
            strength_history: value[:current_strength].to_s,
            test_interval: value[:test_interval].to_i,
            test_date_array: value[:test_interval].to_s,
            next_test_date: next_test_date
          )
          
          if new_word.save
            return_message << "Word #{value[:word_id]} Is Learnt!\n"
          else
            return_message << "Word #{value[:word_id]} Creation Failure\n"
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
      return_message = ""   # variables to record word conditions to return message
      
      request.params[:learnedWords].each do |key, value|
        # Check the word is created or not
        if lword = current_student.student_learnt_words.find_by(word_id: value[:word_id])
          
          # Append the new strength and test interval to histories accordingly
          strength_history = lword.strength_history
          test_date_array = lword.test_date_array  
          
          ###########################Update Strength###########################
          # If the word record is updated today already, override the history
          if lword.updated_at.beginning_of_day() == DateTime.current().beginning_of_day()
            # If the history is not nil, try to find the last element start with ',', and clear it.
            # If nothing found, there's only one record in history, set the history to nil directly
            if !(strength_history.nil? || strength_history == "")
              # If there's no ',' in the string, clear the strength history directly
              if strength_history.match(/\s*,\s*/).nil?
                strength_history = ""
              else
                strength_history = strength_history.sub(/,\p{Digit}*\z/, "")
              end
            else
              raise "Strength History Invalid!"
            end
          end
          
          # If the strength history is nil or has nothing, don't append ','
          if !(strength_history.nil? || strength_history == "")
            strength_history << ','
          end
          strength_history << value[:current_strength].to_s
          ######################################################################
          
          
          ############################Update dates##############################
          # If the word record is updated today already, override the history
          if lword.updated_at.beginning_of_day() == DateTime.current().beginning_of_day()
            # If the history is not nil, try to find the last element start with ','.
            # If nothing found, there's only one record in history, set the history to nil directly
            # Also update the next_test_date
            if !(test_date_array.nil? || test_date_array == "")
              if test_date_array.match(/\s*,\s*/).nil?
                lword.next_test_date = lword.next_test_date.advance(:days => -test_date_array.to_i)
                test_date_array = ""
              else
                lword.next_test_date = lword.next_test_date.advance(:days => -test_date_array.match(/\p{Digit}*\z/)[0].to_i)
                test_date_array = test_date_array.sub(/,\p{Digit}*\z/, "")
              end
            else
              raise "Test Date History Invalid!"
            end
          end
          
          # If the test date history is nil or has nothing, don't append ','
          if !(test_date_array.nil? || test_date_array == "")
            test_date_array << ','
          end
          test_date_array << value[:test_interval].to_s
          ######################################################################
          
          
          # If the next_test_date is nil or earlier than current date, add the interval to the current time
          # Else add the interval to the recorded next test date
          next_test_date = Date.current()
          if(lword.next_test_date.nil? || lword.next_test_date < next_test_date)
            next_test_date = next_test_date.advance(:days => +value[:test_interval].to_i)
          else
            next_test_date = lword.next_test_date.advance(:days => +value[:test_interval].to_i)
          end
          
          # Update the student Learned Word
          if StudentLearntWord.update(
              lword.id,
              current_strength: value[:current_strength],
              strength_history: strength_history,
              test_interval: value[:test_interval],
              test_date_array: test_date_array,
              next_test_date: next_test_date
            )
            return_message << "Word #{value[:word_id]} Condition Updated!\n"
          else
            return_message << "Word #{value[:word_id]} Condition Update Failure!\n"
          end
        else
          return_message << "Word #{value[:word_id]} Isn't Learnt!\n"
        end
      end
      
      respond_to do |format|
        format.json {render json: {message: return_message}, status: 200}
      end
    end
  end
end
