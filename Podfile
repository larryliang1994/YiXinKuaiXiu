source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.3'
use_frameworks!

target 'YiXinKuaiXiu' do
    pod 'SwiftyJSON', '~> 2.3.2'
end

pod 'SWXMLHash', '~> 2.5.1'

pod 'Alamofire', '~> 3.4.2’

pod 'HanekeSwift', '~> 0.10.1'

pod 'UMengAnalytics', '~> 4.1.0'

pod 'Bugly', '~> 2.4.0'

pod 'KYDrawerController', '~> 1.1.5'

pod 'BaiduMapKit', '~> 3.0.0' #百度地图SDK

pod 'SwiftyTimer', '~> 1.4.1'

pod 'UsefulPickerView', '~> 0.1.2'

pod 'ReachabilitySwift', '~> 2.4'

pod 'EasyAnimation', '~> 1.0.5'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
