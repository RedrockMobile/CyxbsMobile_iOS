# source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

platform :ios,'11.0'

use_frameworks!

install! 'cocoapods', :disable_input_output_paths => true

target 'CyxbsMobile2019_iOS' do
    inherit! :search_paths

    pod 'YYKit',:inhibit_warnings => true

    # pod 'TZImagePickerController','~> 3.3.2'
    # pod 'YBImageBrowser',:inhibit_warnings => true
    # pod 'NudeIn'
    pod 'SDWebImage'
    pod 'AFNetworking', '~> 4.0'
    # pod 'MBProgressHUD', '~> 0.9.2'
    
    pod 'Masonry'
    pod 'MJRefresh'
    # pod 'AMapLocation-NO-IDFA'
    # pod 'AMap3DMap-NO-IDFA'
    pod 'MJExtension'
    # pod 'SDCycleScrollView'

	#pod 'UMCommon'    # 必须集成 不支持arm64，去死吧
	# pod 'UMDevice'    # 必须集成
	# pod 'UMPush'	# 必选，推送组件，由原来的UMCPush变为UMPush
    
    # pod 'UMCSecurityPlugins','~> 1.0.6'
    # pod 'UMCCommonLog','~> 1.0.0'
    # pod 'UMCPush','~> 3.2.4'
    # pod 'UMCAnalytics','~> 6.0.5'
    # pod 'UMCErrorCatch','~> 1.0.0'
    # pod 'UMCShare/UI','~> 6.9.6'
    # pod 'UMCShare/Social/ReducedWeChat','~> 6.9.6'
    # pod 'UMCShare/Social/ReducedQQ','~> 6.9.6'
    
    # pod 'IQKeyboardManager'
    # pod 'Bugly'
    pod 'LookinServer', :configurations => ['Debug']
    pod 'FluentDarkModeKit'
    pod 'IGListKit' # SSR引入，暂时无项目使用
    pod 'WCDB'
    pod 'hpple'
    # pod 'CocoaMarkdown'
    pod 'MarkDownEditor'
    pod 'JGProgressHUD'
    
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'SnapKit'
    pod 'SwiftySwift'

    target 'CyxbsMobile2019_iOSTests' do
        inherit! :search_paths
    end

    target 'CyxbsMobile2019_iOSUITests' do
    end
    
end

target 'CyxbsWidgetExtension' do
    pod 'WCDB'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    # pod 'AFNetworking'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        config.build_settings['HEADER_SEARCH_PATHS'] = '$(PROJECT_DIR)/**'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
        config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
        config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
        config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
    end
end