#
# Be sure to run `pod lib lint SwipeViewModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwipeViewModule'
  s.version          = '0.2.0'
  s.summary          = '侧滑弹窗'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ShiKaiMing/SwipeViewModule'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ShiKaiMing' => '1054776982@qq.com' }
  s.source           = { :git => 'https://github.com/ShiKaiMing/SwipeViewModule.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'SwipeViewModule/Classes/*'

  s.subspec 'SwipeModel' do |ss|
    ss.source_files = 'SwipeViewModule/Classes/SwipeModel/*.{h,m}'
  end

  # s.resource_bundles = {
  #   'SwipeViewModule' => ['SwipeViewModule/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
    s.dependency 'QMUIKit'
    s.dependency 'FDFullscreenPopGesture'
    s.dependency 'AppLord'
    s.dependency 'YYKit'
end
