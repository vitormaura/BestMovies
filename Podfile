platform :ios, '10.0'

use_frameworks!

def shared_pods
    
    pod 'Alamofire'
    pod 'Kingfisher'
    pod 'Spruce'
    pod 'lottie-ios'
    
end

target 'Best Movies' do
    
    shared_pods
    
end

post_install do |installer|
    
    installer.pods_project.targets.each do |target|
        
        target.build_configurations.each do |config|
            
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
            
        end
        
    end
    
end
