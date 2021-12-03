source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

platform :ios,'11.0'
use_frameworks!


target 'CyxbsMobile2019_iOS' do
  pod 'MGJRouter'
  pod 'Bagel', '~> 1.3.2'
	pod 'TZImagePickerController'
	pod 'YBImageBrowser'
	pod 'NudeIn'
	pod 'SDWebImage'
	pod 'AFNetworking','~> 2.6.3'
	pod 'FMDB'
	pod 'MBProgressHUD'
	pod 'YYKit'
	pod 'YYImage'
	pod 'Masonry'
	pod 'MJRefresh'
	pod 'AMapLocation-NO-IDFA'
	pod 'AMap3DMap-NO-IDFA'
	pod 'MJExtension'
	pod 'SDCycleScrollView'
	#umeng
	pod 'UMCCommon'
    	pod 'UMCSecurityPlugins'
    	pod 'UMCCommonLog'
    	pod 'UMCPush'
	pod 'UMCAnalytics'
	pod 'UMCErrorCatch'
	# U-Share SDK UI模块（分享面板，建议添加）
    	pod 'UMCShare/UI'
	# 集成微信(精简版0.2M)
    	pod 'UMCShare/Social/ReducedWeChat'
	# 集成QQ/QZone/TIM(精简版0.5M)
    	pod 'UMCShare/Social/ReducedQQ'
      
  # For Swift:
  
  pod 'Alamofire', '~> 5.2'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'SnapKit'

    post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
    config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    config.build_settings['VALID_ARCHS'] = 'arm64 arm64e armv7 armv7s x86_64 i386'
    config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
    end
  
end
