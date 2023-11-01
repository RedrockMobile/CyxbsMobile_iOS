source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

platform :ios,'11.0'
use_frameworks!

# 请阅读《Pod & 第三方库》
target 'CyxbsMobile2019_iOS' do
	pod 'TZImagePickerController','~> 3.3.2'
	pod 'YBImageBrowser',:inhibit_warnings => true
	pod 'NudeIn'
	pod 'SDWebImage'
	pod 'AFNetworking'
	pod 'FMDB'
	pod 'MBProgressHUD', '~> 0.9.2'
	pod 'YYKit',:inhibit_warnings => true
	pod 'YYImage',:inhibit_warnings => true
	pod 'Masonry'
	pod 'MJRefresh'
	pod 'AMapLocation-NO-IDFA'
	pod 'AMap3DMap-NO-IDFA'
	pod 'MJExtension'
	pod 'SDCycleScrollView'
	#umeng
	pod 'UMCCommon','~> 2.1.1'
    	pod 'UMCSecurityPlugins','~> 1.0.6'
    	pod 'UMCCommonLog','~> 1.0.0'
    	pod 'UMCPush','~> 3.2.4'
	pod 'UMCAnalytics','~> 6.0.5'
	pod 'UMCErrorCatch','~> 1.0.0'
	# U-Share SDK UI模块（分享面板，建议添加）
    	pod 'UMCShare/UI','~> 6.9.6'
	# 集成微信(精简版0.2M)
    	pod 'UMCShare/Social/ReducedWeChat','~> 6.9.6'
	# 集成QQ/QZone/TIM(精简版0.5M)
    	pod 'UMCShare/Social/ReducedQQ','~> 6.9.6'
	pod 'IQKeyboardManager'
	pod 'Bugly'
	pod 'LookinServer', :configurations => ['Debug']

	# 基于iOS11.0的黑暗适配
	pod 'FluentDarkModeKit'

	pod 'IGListKit' # SSR引入，暂时无项目使用
	pod 'WCDB'
      
  # For Swift:
  
  pod 'Alamofire', '~> 5.2'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'RxSwift', '~> 5.1.1'
  pod 'RxCocoa', '~> 5.1.1'
  pod 'SnapKit'
  pod 'JXSegmentedView'

    post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
    config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    config.build_settings['VALID_ARCHS'] = 'arm64 arm64e armv7 armv7s x86_64 i386'
    config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    config.build_settings['HEADER_SEARCH_PATHS'] = '$(PROJECT_DIR)/**'
    end
    end
  
end
