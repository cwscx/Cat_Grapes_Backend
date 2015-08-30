class CasesController < ApplicationController
  def index
    # Parse all the parameteres id to find resources
    book_id = params[:caseInfo][:book_id]
    unit_id = params[:caseInfo][:unit_number]
    case_id = params[:caseInfo][:case_number]
    
    # Try to find resources in cases
    begin book_res = Book.find(book_id)
      begin unit_res = book_res.units.find(unit_id)
        begin case_res = unit_res.cases.find(case_id)
          
          i = 0                         # Counter to count exercise No. in this case
          exercise_resource = Array.new  # Hash to store sub-resources like words and components in this case
          
          # Store words and components in this Hash to pass
          if case_res
            case_res.exercises.each do |e|
              i = i + 1
              exercise_resource << {
                "body" => e, 
                "words" => e.words, 
                "components" => e.components
              }
            end
          end
          
          respond_to do |format|
            format.json {render json: 
              {
                vedio_resource: case_res.videos,
                exercise_resources: exercise_resource
              }, 
              status: 200 }
          end
        # If case not found, return 404
        rescue Exception => e
          respond_to do |format|
            format.json {render json: {message: e.message, reason: "Case Not Found"}, status: 404 }
          end
        end
      # If unit not found, return 404
      rescue Exception => e
        respond_to do |format|
          format.json {render json: {message: e.message, reason: "Unit Not Found"}, status: 404 }
        end
      end
    # If book not found, return 404
    rescue Exception => e
      respond_to do |format|
        format.json {render json: {message: e.message, reason: "Book Not Found"}, status: 404 }
      end
    end
  end
end
