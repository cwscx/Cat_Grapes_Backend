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
end
