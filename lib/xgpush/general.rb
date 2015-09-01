require 'uri'
require 'openssl'
require 'rest-client'

module Xgpush
  class General
    ROOT_URL = 'openapi.xg.qq.com'
    PROTOCAL = 'http'
    VERSION = 'v2'
    SERVICES =
      { push: %w(single_device single_account
                 account_list all_device tags_device) }

    SERVICES.each do |param_class, param_methods|
      param_methods.each do |param_method|
        define_method("#{param_class}_#{param_method}") do |params = {}|
          request(params)
        end
      end
    end

    def request(params = {})
      RestClient.post
        request_url(params),
        general_params(params).merge(business_params(params)).to_json,
        content_type: 'application/x-www-form-urlencoded'
    end

    def request_url(params)
      params[:param_encode] = true
      "#{PROTOCAL}://#{ROOT_URL}/#{VERSION}/#{params[:param_class]}/" \
      "#{params[:param_method]}#{params_string(params).gsub(/\&$/, '')}"
    end

    def general_params(params)
      { access_id: settings[:access_id],
        timestamp: Time.now.to_i,
        valid_time: params[:valid_time],
        sign: param_sign(params) }
    end

    def param_sign(params)
      sign_string = "POST#{ROOT_URL}/#{VERSION}/#{params[:param_class]}/" \
        "#{params[:param_method]}#{params_string(params)}"
      OpenSSL::Digest::MD5.new(sign_string).to_s
    end

    private

    def business_params(params)
      params.reject { |k, _v| k.to_s.split('_')[0] == 'param' }
    end

    def params_string(params)
      new_string = ''
      business_params(params).keys.sort.each do |key|
        next unless params[key]
        value =
          params[:param_encode] ? URI.encode(params[key]) : "#{params[key]}&"
        new_string += "#{key}=#{value}"
      end
      new_string
    end
  end
end
