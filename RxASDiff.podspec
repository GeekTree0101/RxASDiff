Pod::Spec.new do |s|
  s.name             = 'RxASDiff'
  s.version          = '1.0.0'
  s.summary          = 'Reactive Diff Library on Texture built on DeepDiff'

  s.description      = 'Texture x RxSwift x Paul Heckel Diff Algorithm'

  s.homepage         = 'https://github.com/Geektree0101/RxASDiff'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Geektree0101' => 'h2s1880@gmail.com' }
  s.source           = { :git => 'https://github.com/Geektree0101/RxASDiff.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'RxASDiff/Classes/**/*'
  
  s.dependency 'Texture', '~> 2.7'
  s.dependency 'RxSwift', '~> 4.0'
  s.dependency 'RxCocoa', '~> 4.0'
  s.dependency 'DeepDiff', '~> 1.2'
end
