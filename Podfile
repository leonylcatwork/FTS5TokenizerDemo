platform :ios, '12.0'

use_frameworks!
inhibit_all_warnings!

def import_pods
  pod 'GRDB.swift/SQLCipher'
  pod 'SQLCipher', '~> 4.0'
end

target 'FTS5' do
  import_pods

  target 'FTS5Tests' do
    inherit! :search_paths
  end
end


# remove pod specific ios deployment target
# so that all pods use default ios deployment taget
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
