class HomeController < ApplicationController
  def index
    if request.format == "text/html"
      
    else
      respond_to do |format|
        format.json {render json: {status: "Login Failure"}, status: 202}
      end
    end
  end
end
