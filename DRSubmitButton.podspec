#
#  Be sure to run `pod spec lint DRSubmitButton.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "DRSubmitButton"
  s.version      = "0.0.1"
  s.summary      = "A custom submit button with normal, loading, success and warning state."
  s.description  = <<-DESC
                   DESC
  s.homepage     = "http://EXAMPLE/DRSubmitButton"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"
  s.author             = { "Samuel" => "citysite1025@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "git@github.com:citysite102/DRSubmitButton.git", :tag => "#{s.version}" }
  s.source_files  = 'Source'
  s.requires_arc = true

end
