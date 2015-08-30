class Students::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }, on: :create
  
  before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    if request.format == "text/html"
      super
    else
      build_resource(sign_up_params)
      
      resource.save    
      yield resource if block_given?
      
      puts resource.persisted?
      puts resource.active_for_authentication?
      
      # Check if the email is signed up before
      if resource.persisted?
        
        create_records(resource)
        
        # Check if this account is already confirmed. In this case, only the second condition will be called.
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
          
          respond_to do |format|
            format.json {render json: {student: resource, status: "Created"}, status: 201}
          end
        else
          expire_data_after_sign_in!
          
          respond_to do |format|
            format.json {render json: {student: resource, status: "Created"}, status: 201}
          end
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_to do |format|
          format.json {render json: {student: resource, status: "Existed"}, status: 202}
        end
      end
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << :name <<:grade
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end
  
  private
  
  def create_records(stu)
    @current_record = initialize_current_record(stu)
    @learnt_words = initialize_learnt_words(stu)
    
    # review_time may need to be requested later
    @review_record = initialize_review_record(stu, "20:00:00")
    
    # Save the record
    if @current_record.save
      if @review_record.save
      else
        respond_to do |format|
          format.json {render json:@review_record.errors, status: :unprocessable_entity}
          format.html
        end
      end
    else
      respond_to do |format|
        format.json {render json: @current_record.errors, status: :unprocessable_entity}
        format.html
      end
    end
  end
  
  # Set up the initial current record to track the student's most recent schedule
  # Needs to be saved later, cos build won't save automatically like create
  def initialize_current_record(student)
    student.build_student_current_record(
      book_id: Book.first.id, 
      unit_id: Book.first.units.find_by(sequence_id: 1).id, 
      case_id: Book.first.units.find_by(sequence_id: 1).cases.find_by(sequence_id: 1).id, 
      video_id: Book.first.units.find_by(sequence_id: 1).cases.find_by(sequence_id: 1).videos.find_by(sequence_id: 1).id
    )
  end
  
  # Set up the initial learnt words for the new student
  # All the words that are lower than the student's current grade will be added as learnt words
  def initialize_learnt_words(student)
    words = Word.where("grade < ?", student.grade)
    
    words.each do |w|
      student.student_learnt_words.create(
        current_strength: 0.0,
        strength_history: "",
        test_interval: 0,
        test_date_array: "",
        word_id: w.id
      )
    end
    
    student.student_learnt_words
  end
  
  def initialize_review_record(student, review_time)
    student.build_student_review_record(
      streak: 1,
      next_test_date: Date.current().tomorrow(),
      review_history: '1',
      coins: 0,
      review_time: review_time
    )
  end
end
