module QQpush
  # Android device
  class Android < General
    def initialize(params = {})
      super
      @request_params[:message_type] = 1
      @request_params[:message] =
        { title: params[:param_title], content: params[:param_content],
          custom_content: params[:params_custom] }
    end
  end
end
