require 'uri'
require 'openssl'
require 'rest-client'

module Xgpush
  class General
    attr_accessor :settings

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
      RestClient.post(
        request_url(params),
        general_params(params).merge(business_params(params)).to_json,
        content_type: 'application/x-www-form-urlencoded')
    end

    def request_url(params)
      params[:param_encode] = true
      "#{PROTOCAL}://#{ROOT_URL}/#{VERSION}/#{params[:param_class]}/" \
      "#{params[:param_method]}#{params_string(params).gsub(/\&$/, '')}"
    end

    def general_params(params)
      base_params = { access_id: settings[:access_id],
                      timestamp: params[:timestamp],
                      valid_time: params[:valid_time] }
      base_params[:timestamp] ||= Time.now.to_i
      all_params = params.merge base_params
      base_params.merge(sign: param_sign(all_params))
    end

    def param_sign(params)
      sign_string = "POST#{ROOT_URL}/#{VERSION}/#{params[:param_class]}/" \
        "#{params[:param_method]}#{params_string(params).gsub(/\&/, '')}" \
        "#{params[:secret_key]}"
      OpenSSL::Digest::MD5.new(sign_string).to_s
    end

    private

    def business_params(params)
      params.reject { |k, _v| k.to_s =~ /param_.*/ || k == :secret_key }
    end

    def params_string(params)
      new_string = ''
      business_params(params).keys.map(&:to_s).sort.each do |key|
        next unless params[key] || params[key.to_sym]
        value = [params[key], params[key.to_sym]].compact.first
        new_value =
          params[:param_encode] ? URI.encode(value) : "#{value}&"
        new_string += "#{key}=#{new_value}" if new_value
      end
      new_string
    end
  end
end
