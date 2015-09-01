$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'xgpush/general'

describe 'General methods' do
  before do
    @request = Xgpush::General.new
    @request.settings = { access_id: '123' }
  end

  it 'can generate sign by params' do
    # http://developer.xg.qq.com/index.php/Rest_API
    new_params = { param_class: 'push', param_method: 'single_device',
                   timestamp: 1386691200, secret_key: 'abcde',
                   'Param1' => 'Value1', 'Param2' => 'Value2' }
    params = @request.general_params(new_params)
    expect(params[:sign]).to eq('ccafecaef6be07493cfe75ebc43b7d53')
  end
end
