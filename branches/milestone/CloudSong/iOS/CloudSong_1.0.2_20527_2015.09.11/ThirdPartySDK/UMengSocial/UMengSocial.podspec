#
#  Be sure to run `pod spec lint UMengSocial.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "UMengSocial"
  s.version      = "0.0.1"
  s.summary      = "A short description of UMengSocial."

  s.description  = <<-DESC
                   A longer description of UMengSocial in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "http://EXAMPLE/UMengSocial"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT (example)"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "Chunbo Zhou" => "zhouchunbo@ethank.com.cn" }
  # Or just: s.author    = "Chunbo Zhou"
  # s.authors            = { "Chunbo Zhou" => "zhouchunbo@ethank.com.cn" }
  # s.social_media_url   = "http://twitter.com/Chunbo Zhou"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source = { :http => "http://192.168.1.226/download/UMengSocial/umeng_ios_social_sdk_4.2.3_arm64_custom.zip"}

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_4.2.3/Header/*.h",
 "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Wechat/*.h",
 "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/*.h",
 "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/SinaSSO/*.h",
 "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Sina/*.h",
 "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Instagram/*.h",
 "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Line/*.h",
 "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Whatsapp/*.h",
 "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Tumblr/*.h",
 "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/LaiWang/*.h"
  s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  s.resources = "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_4.2.3/UMSocialSDKResourcesNew.bundle",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/TencentOpenApi_IOS_Bundle.bundle",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/SinaSSO/WeiboSDK.bundle",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_4.2.3/SocialSDKXib/*.xib",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_4.2.3/{en,zh-Hans}.lproj"

  s.preserve_paths = "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_4.2.3/libUMSocial_Sdk_4.2.3.a",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_4.2.3/libUMSocial_Sdk_Comment_4.2.3.a",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Wechat/libSocialWechat.a",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Wechat/libWeChatSDK.a",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/libSocialQQ.a",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/TencentOpenAPI.framework",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/SinaSSO/*.a",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Sina/libSocialSina.a",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Instagram/libSocialInstagram.a",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Line/libSocialLine.a",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Whatsapp/libSocialWhatsapp.a",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Tumblr/libSocialTumblr.a",
    "umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/LaiWang/libSocialLaiWang.a"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
s.frameworks = "SystemConfiguration",
    "MobileCoreServices",
    "TencentOpenAPI",
    "CoreGraphics",
    "CoreTelephony"

  # s.library   = "iconv"
  s.libraries = "UMSocial_Sdk_4.2.3",
    "UMSocial_Sdk_Comment_4.2.3",
    "SocialQQ",
    "SocialWechat",
    "z",
    "sqlite3",
    "stdc++",
    "iconv",
    "WeChatSDK",
    "SocialSina",
    "SocialInstagram",
    "SocialLine",
    "SocialWhatsapp",
    "SocialTumblr",
    "SocialLaiWang",
    "SocialSinaSSO",
    "WeiboSDK"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

s.xcconfig = { "LIBRARY_SEARCH_PATHS" => "$(PODS_ROOT)/UmengSocial/umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_4.2.3/** $(PODS_ROOT)/UmengSocial/umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/ $(PODS_ROOT)/UmengSocial/umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/SinaSSO/** $(PODS_ROOT)/UmengSocial/umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Wechat/** $(PODS_ROOT)/UmengSocial/umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Sina/** $(PODS_ROOT)/UmengSocial/umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Line/** $(PODS_ROOT)/UmengSocial/umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Whatsapp/** $(PODS_ROOT)/UmengSocial/umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Instagram/** $(PODS_ROOT)/UmengSocial/umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/Tumblr/** $(PODS_ROOT)/UmengSocial/umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/LaiWang/**", "FRAMEWORK_SEARCH_PATHS" => "$(PODS_ROOT)/UmengSocial/umeng_ios_social_sdk_4.2.3_arm64_custom/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/"}
  # s.dependency "JSONKit", "~> 1.4"

    
end
