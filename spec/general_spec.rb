$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'qqpush/general'

describe 'General methods' do
  before do
    @request = QQpush::General.new
  end

  it 'can generate sign by params' do
    # http://developer.xg.qq.com/index.php/Rest_API#.E9.80.9A.E7.94.A8.E5.8F.82.E6.95.B0
    @request.settings = { access_id: '123', secret_key: 'abcde' }
    new_params = { timestamp: '1386691200', param_request: 'post',
                   param_class: 'push', param_method: 'single_device',
                   'Param1' => 'Value1', 'Param2' => 'Value2' }
    params = @request.general_params(new_params)
    expect(params[:sign]).to eq('ccafecaef6be07493cfe75ebc43b7d53')
  end

  it 'can push to single device' do
    @request.request_params =
      { message_type: 1, message: {
          content: 'content', title: 'title',
          custom_content: { key: 'value' } } }
    response = @request.push_single_device
    expect(response['ret_code']).to eq(-1)
    expect(response['err_msg']).to eq('param device_token error!')
  end
end
