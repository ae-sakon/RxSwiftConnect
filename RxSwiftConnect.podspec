Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "RxSwiftConnect"
s.summary = "RxSwiftConnect is similar Retrofit on Android and we can call Retrofit iOS."
s.requires_arc = true

# 2
s.version = "2.6.0"

# 3
s.license = { :type => "Apache License 2.0", :file => "/Users/sakon/iOS/Libraries/RxSwiftConnect/license.txt" }

# 4 - Replace with your name and e-mail address
s.author = { "Keegan Rush" => "sakon@megazy.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/ae-sakon/RxSwiftConnect"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/ae-sakon/RxSwiftConnect.git",
:tag => "#{s.version}" }

# 7
#s.framework = "UIKit"
s.dependency 'RxSwift', '~> 5'
s.dependency 'RxCocoa', '~> 5'
s.dependency 'SwiftyGif'

# 8
s.source_files = "RxSwiftConnect/*.{swift}"

# 9
s.resources = "RxSwiftConnect/Resource/*"

# 10
s.swift_version = "5.0"

end
