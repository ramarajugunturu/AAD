# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'SEiOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SEiOS
  #pod 'ADALiOS'
  #pod 'ADALiOS', :git => 'https://github.com/AzureAD/azure-activedirectory-library-for-objc.git', :branch=> 'convergence'
  
  pod 'MSAL', :git => 'https://github.com/AzureAD/microsoft-authentication-library-for-objc', :tag => '0.1.3'

  pod 'NXOAuth2Client'
  pod 'Alamofire'
  pod "HockeySDK", :subspecs => ['AllFeaturesLib']

  target 'SEiOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SEiOSUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
