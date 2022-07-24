source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
inhibit_all_warnings!
use_frameworks!

def pods_project

  # UI

  pod 'SwiftLint'
  pod 'SnapKit', '5.6.0'
  pod 'IQKeyboardManagerSwift', '6.5.10'

  # Utils
  
  pod 'SwiftGen', '6.4.0'

end

target 'Art' do 
  pods_project
end

target 'ArtTests' do
  inherit! :search_paths
  # Pods for testing
end

target 'ArtUITests' do
   # Pods for testing
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

