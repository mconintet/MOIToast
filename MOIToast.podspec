Pod::Spec.new do |spec|
  spec.name         = 'MOIToast'
  spec.version      = '0.0.1'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/mconintet/MOIToast'
  spec.authors      = { 'mconintet' => 'mconintet@gmail.com' }
  spec.summary      = 'Simple toast in Object-C for iOS'
  spec.source       = { :git => 'https://github.com/mconintet/MOIToast.git', :tag => '0.0.1' }
  spec.source_files = 'MOIToast'
  spec.ios.deployment_target = '9.0'
end