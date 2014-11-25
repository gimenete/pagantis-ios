Pod::Spec.new do |s|

  s.name         = "PagantisSDK"
  s.version      = "1.0.0"
  s.summary      = "iOS SDK for using Pagantis.com"

  s.description  = <<-DESC
                   This iOS SDK encapsules the Pagantis.com REST API
                   DESC

  s.homepage     = "https://github.com/pagantis/pagantis-ios"
  s.license      = "MIT"
  s.author       = "Pagantis"

  s.platform     = :ios
  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/pagantis/pagantis-ios.git", :tag => "1.0.0" }

  s.source_files  = "Pagantis/Pagantis/PagantisSDK", "Pagantis/Pagantis/PagantisSDK/**/*.{h,m}"

  s.dependency 'AFNetworking', '~> 2.1.0'

end
