source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.3'
use_frameworks!

target 'YiXinKuaiXiu' do
    pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
end

pod 'SWXMLHash'

pod 'Alamofire'

pod 'HanekeSwift'

pod 'UMengAnalytics'

pod 'Bugly'

pod 'KYDrawerController'

pod 'ReachabilitySwift'

pod 'BaiduMapKit' #百度地图SDK

pod 'EasyAnimation'

pod 'XLRefreshSwift'

pod 'SwiftyTimer'

pod 'UsefulPickerView'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings[‘ENABLE_BITCODE‘] = ‘NO‘
        end
    end
end