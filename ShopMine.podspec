Pod::Spec.new do |s|
  s.name             = 'ShopMine'
  s.version          = '1.0.0'
  s.summary          = '我的业务组件'
  s.description      = 'ShopMine provides MineViewController, MineViewModel, Target_Mine, and route registration for the mine (profile) flow.'
  s.homepage         = 'https://github.com/inhua/ShopMine'
  s.license          = { :type => 'MIT' }
  s.author           = { 'inhua' => 'dev@inhua.com' }
  s.source           = { :git => 'https://github.com/inhua/ShopMine.git', :tag => s.version.to_s }

  s.platform              = :ios, '18.1'
  s.swift_version         = '5.0'

  s.source_files = 'Sources/**/*.swift'

  s.dependency 'ShopBase'
  s.dependency 'ShopRouter'
  s.dependency 'ShopMediator'
  s.dependency 'ShopBusinessBase'
end
