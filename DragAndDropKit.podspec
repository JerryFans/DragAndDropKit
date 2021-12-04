#
# Be sure to run `pod lib lint DragAndDropKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DragAndDropKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of DragAndDropKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/fanjiaorng919/DragAndDropKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fanjiaorng919' => 'fanjiarong_haohao@163.com' }
  s.source           = { :git => 'https://github.com/fanjiaorng919/DragAndDropKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'DragAndDropKit/Classes/**/*'
  
  s.swift_version = ['4.0']
  # s.resource_bundles = {
  #   'DragAndDropKit' => ['DragAndDropKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'JFPopup', '~> 1.4.0'
end
