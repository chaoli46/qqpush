require 'uri'
require 'openssl'
require 'rest-client'
require 'json'
require 'yaml'

module QQpush
  # General REST API
  class General
    attr_accessor :settings, :request_params

    PROTOCAL = 'http'
    ROOT_URL = 'openapi.xg.qq.com'
    VERSION = 'v2'
    SERVICES = { push: %w(single_device single_account
                          account_list all_device tags_device) }

    SERVICES.each do |param_class, param_methods|
      param_methods.each do |param_method|
        define_method("#{param_class}_#{param_method}") do |params = {}|
          params = request_params unless params.any?
          params[:param_request] = 'get'
          request(
            params.merge(param_class: param_class,
                         param_method: param_method))
        end
      end
    end

    def initialize(params = {})
      @settings =
        File.exist?('settings.yml') ? YAML.load_file('settings.yml') : {}
      @request_params = params
    end

    def request(params = {})
      response = RestClient.send(
        params[:param_request], request_url(params))
      JSON.parse response
    end

    def request_url(params)
      params[:param_encode] = true
      all_params = params.merge(general_params(params))
      "#{PROTOCAL}://#{ROOT_URL}/#{VERSION}/#{params[:param_class]}/" \
      "#{params[:param_method]}?#{params_string(all_params).gsub(/\&$/, '')}"
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
      params.delete(:param_encode)
      sign_string = "#{params[:param_request].upcase}" \
        "#{ROOT_URL}/#{VERSION}/#{params[:param_class]}/" \
        "#{params[:param_method]}#{params_string(params)}" \
        "#{settings[:secret_key]}"
      OpenSSL::Digest::MD5.new(sign_string).to_s
    end

    private

    def params_string(params)
      new_string = ''
      business_params_string_keys(params).each do |key|
        next unless params[key] || params[key.to_sym]
        value = [params[key], params[key.to_sym]].compact.first
        value = param_string_value(value)
        new_value = params[:param_encode] ? "#{URI.encode(value)}&" : value
        new_string += "#{key}=#{new_value}"
      end
      new_string
    end

    def business_params_string_keys(params)
      params.reject { |k, _v| k.to_s =~ /param_.*/ }.keys.map(&:to_s).sort
    end

    def param_string_value(value)
      value.is_a?(Hash) ? value.to_json : value.to_s
    end
  end
end
