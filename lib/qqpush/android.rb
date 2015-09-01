module QQpush
  class Android < General
    def initialize(params = {})
      super
      @request_params[:message_type] = 1
      @request_params[:message] =
        { title: params[:param_title], content: params[:param_content] }
    end
  end
end
