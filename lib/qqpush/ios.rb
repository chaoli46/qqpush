module QQpush
  # iOS device
  class Ios < General
    def initialize(params = {})
      super
      @request_params[:environment] = 2
      @request_params[:message_type] = 0
      @request_params[:message] =
        { aps: { alert: params[:param_content] } }
        .merge(params[:params_custom])
    end
  end
end
