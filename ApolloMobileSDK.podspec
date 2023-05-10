#
# Be sure to run `pod lib lint ATTORMRetailSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ApolloMobileSDK'
  s.version          = '0.10.6' 
  s.summary          = 'AT&T Apollo SDK for OEMs.'
  s.swift_version    = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

#  s.description      = <<-DESC
# TODO: Add long description of the pod here.
#                       DESC

  s.homepage         = 'https://example.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AT&T' => 'dm835j@att.com' }
  s.source           = { :git => 'https://github.com/pariveshahm/ApolloIOSSDKSource.git', :tag => s.version.to_s, :branch => 'main' }

  s.ios.deployment_target = '13.0'

  s.source_files = 'ApolloMobileSDK/Classes/**/*'

   s.resource_bundles = {
     'Resources' => ['ApolloMobileSDK/Assets/**/*.{xcassets,storyboard,xcconfig,plist,strings}'],
     'Fonts' => ['ApolloMobileSDK/Assets/Fonts/**/*.{ttf}'],
     'Data' => ['ApolloMobileSDK/Assets/Data/**/*.{json}']
   }


   #s.resource = 'Resources/ATTORMRetailSDKResources.bundle'


  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'SwiftUI'
  s.dependency 'Alamofire', '~> 5.0.5'

  s.pod_target_xcconfig = {
        'PAYMENTS_SERVICES_BASE_URL' => '$(PAYMENTS_SERVICES_BASE_URL)'
  }
#  s.info_plist = {
#    'PAYMENTS_SERVICES_BASE_URL' => '$(PAYMENTS_SERVICES_BASE_URL)',
#    'PRODUCTS_SERVICES_BASE_URL' => '$(PRODUCTS_SERVICES_BASE_URL)',
#    'CONSENTS_SERVICES_BASE_URL' => '$(CONSENTS_SERVICES_BASE_URL)',
#    'SUBSCRIPTIONS_SERVICES_BASE_URL' => '$(SUBSCRIPTIONS_SERVICES_BASE_URL)'
#  }


end
