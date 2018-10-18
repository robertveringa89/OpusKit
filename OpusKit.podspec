
Pod::Spec.new do |s|
s.name                      = "OpusKit"
s.version                   = "0.0.6"
s.summary                   = "OpusKit is a simple way to use the opus decode and encode functions from swift."
s.homepage                  = "https://github.com/robertveringa89/OpusKit"
s.license                   = 'MIT'
s.author                    = "Robert Veringa"
s.platform                  = :ios
s.ios.deployment_target     = "11.0"
s.source                    = { :git => "https://github.com/robertveringa89/OpusKit.git", :tag => "#{s.version}" }
s.source_files              = 'OpusKit/lib/*.{h,m,swift}'
s.vendored_libraries        = 'OpusKit/lib/*.a'
s.swift_version             = "4.2"
end
