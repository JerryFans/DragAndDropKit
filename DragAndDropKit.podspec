#
# Be sure to run `pod lib lint DragAndDropKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DragAndDropKit'
  s.version          = '0.2.0'
  s.summary          = 'A Swift Module Help You Drag Or Drop Source Between Different App In A Easy Way'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       *DragAndDropKit is a Swift Module  Help You Drag Or Drop Source (Like Image,Video,Text) In A Easy Way.
                       *Use iOS DragAndDrop Api, support iPhone In iOS 15 +, iPad In iOS 11 +
                       DESC

  s.homepage         = 'https://github.com/JerryFans/DragAndDropKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fanjiaorng919' => 'fanjiarong_haohao@163.com' }
  s.source           = { :git => 'https://github.com/JerryFans/DragAndDropKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'DragAndDropKit/Classes/**/*'
  
  s.swift_version = ['4.0']
  # s.resource_bundles = {
  #   'DragAndDropKit' => ['DragAndDropKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'JFPopup', '~> 1.4.0'
end
