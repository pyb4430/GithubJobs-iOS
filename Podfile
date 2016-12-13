platform :ios, '8.0'
use_frameworks!

target 'GithubJobApp' do
	use_frameworks!
    pod 'SwiftyJSON', '~> 2.3.1'
    pod 'RealmSwift'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3'
    end
  end
end