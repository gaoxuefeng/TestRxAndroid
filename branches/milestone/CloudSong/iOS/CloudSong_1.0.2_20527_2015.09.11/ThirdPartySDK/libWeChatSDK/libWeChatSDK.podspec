Pod::Spec.new do |s|

  s.name = "libWeChatSDK"
  s.version = "1.5"
  s.license = {
    :type => "Copyright",
    :text => "      Copyright (c) 2012 Tencent. All rights reserved.\n"
  }
  s.summary = "WeChatSDK for Cocoapods convenience."
  s.homepage = "https://open.weixin.qq.com/"
  s.authors = {
    "Tencent" => "weixinapp@qq.com"
  }
  s.source = {
    :http => "http://192.168.1.226/download/libWeChatSDK/libWeChatSDK.zip"
  }
  s.platform = :ios
  s.source_files = "*.h"
  s.public_header_files = "*.h"
  s.preserve_paths = "libWeChatSDK.a"
  s.vendored_libraries = "libWeChatSDK.a"
  s.xcconfig = {
    'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/libWeChatSDK"',
    'HEADER_SEARCH_PATHS' => '"$(PODS_ROOT)/libWeChatSDK"'
  }
  s.requires_arc = false
  s.frameworks = 'SystemConfiguration'
  s.libraries = 'z', 'sqlite3.0', 'c++'

end
