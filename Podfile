# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
 use_frameworks!

target 'Simple' do
pod 'HPReorderTableView', '~> 0.2'
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'Locksmith'
#pod "CRNetworkButton"
end

target 'Just Do It' do
    pod 'SwiftyJSON'
    pod 'Alamofire'
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
