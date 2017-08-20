# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'gratiptude' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for gratiptude
  pod 'TesseractOCRiOS', :git => 'https://github.com/gali8/Tesseract-OCR-iOS.git'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['ENABLE_BITCODE'] = 'NO'
          end
      end
  end
  
  target 'gratiptudeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'gratiptudeUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
