# 腾讯信鸽推送

[![Gem Version](https://badge.fury.io/rb/qqpush.svg)](http://badge.fury.io/rb/qqpush)

## 示例

```ruby
# iOS
message = QQpush::Ios.new(device_token: 'a123b', param_content: 'joe')
message.settings = { access_id: '555', secret_key: '888' }
message.request_params[:environment] = 1 if Rails.env.production?
message.push_single_device

# Android
message = QQpush::Android.new(device_token: 'a123b', param_title: 'yo', param_content: 'joe')
message.settings = { access_id: '555', secret_key: '888' }
message.push_single_device
```

## 参考链接

- [官网](http://xg.qq.com)
- [文档](http://developer.xg.qq.com/index.php/Rest_API)
