#
#  Be sure to run `pod spec lint OpusKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "OpusKit"
  s.version      = "0.0.2"
s.summary      = "Opus decode and encode functions from swift."

  s.description  = <<-DESC
OpusKit is a simple way to use the opus decode and encode functions from swift.
                   DESC

  s.homepage     = "https://github.com/robertveringa89/OpusKit"


s.license  = { :type => 'public domain', :text => <<-LICENSE
Public Domain License
The OpusKit project is in the public domain.
LICENSE
}

  s.author    = "Robert Veringa"


s.ios.deployment_target = "12.0"

  s.source       = { :git => "https://github.com/robertveringa89/OpusKit.git", :tag => "#{s.version}" }
    s.source_files  = 'OpusKit/Classes/*.{h,m,swift}'
s.source_files  = 'OpusKit/lib/*.{h,m,swift}'
  s.swift_version = "4.2"
end
