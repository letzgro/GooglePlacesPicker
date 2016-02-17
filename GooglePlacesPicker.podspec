Pod::Spec.new do |s|

  s.name         = "GooglePlacesPicker"
  s.version      = "0.1.2"
  s.summary      = "GooglePlacesPicker lets a user select an Google Places."
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.homepage = "http://letzgro.net"

  s.license = { :type => 'MIT', :file => 'LICENSE' }

  s.author = { "LETZGRO" => "welcome@lezgro.com" }

  s.source = { :git => "https://github.com/letzgro/GooglePlacesPicker.git", :tag => "0.1.2"}

  s.source_files  = "Classes/**/*.{swift,storyboard,xib}"

  s.resources = "*.{xcassets}"

  s.framework  = "UIKit"

end
