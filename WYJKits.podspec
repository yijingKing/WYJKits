Pod::Spec.new do |s|
  s.name             = 'WYJKits'
  s.version          = '1.3.2'
  s.summary          = 'WYJKits 类扩展,功能集合'
  s.description      = <<-DESC
                            ...
                       DESC

  s.homepage         = 'https://github.com/MemoryKing/WYJKits.git'
  #s.license         = { :type => 'MIT', :file => 'LICENSE' }
  s.license          = 'MIT'
  s.author           = { '╰莪呮想好好宠Nǐつ ' => '1091676312@qq.com' }
  s.source           = { :git => 'https://github.com/MemoryKing/WYJKits.git', :tag => s.version.to_s }
  #s.pod_target_xcconfig = {'SWIFT_VERSION' => '5.0'}
  s.swift_versions   = '5.0'
  s.platform         = :ios, "11.0"
  s.frameworks       = 'UIKit','Foundation','QuartzCore','CoreGraphics','AssetsLibrary','AVFoundation','Accelerate'
  s.dependency 'MJRefresh'
  s.dependency 'DZNEmptyDataSet'
  s.dependency 'SnapKit'
  s.dependency 'MBProgressHUD'
  s.dependency 'Alamofire'
  s.dependency 'IQKeyboardManagerSwift'
  s.dependency 'SwiftyRSA'
  s.resource_bundles = { 'WYJResources' => 'WYJKits/Resource/*' }
  
  s.source_files = 'WYJKits/**/*.swift'

s.requires_arc = true
end
