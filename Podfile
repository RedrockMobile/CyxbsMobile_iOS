source 'https://github.com/CocoaPods/specs'
source 'https://github.com/aliyun/aliyun-specs.git'

platform :ios, '13.0'
use_frameworks!

inhibit_all_warnings!

pod 'Alamofire'
pod 'SwiftyJSON'

target 'CyxbsMobile2019_iOS' do
  pod 'ProgressHUD',      '13.7.2'
	pod 'TZImagePickerController'
	pod 'YBImageBrowser'
	pod 'NudeIn'
	pod 'SDWebImage'
	pod 'AFNetworking'
	pod 'FMDB'
	pod 'MBProgressHUD', '~> 0.9.2'
	pod 'YYKit'
	pod 'YYImage'
	pod 'Masonry'
	pod 'MJRefresh'
	pod 'AMapLocation-NO-IDFA'
	pod 'AMap3DMap-NO-IDFA'
	pod 'MJExtension'
	pod 'SDCycleScrollView'
	
  pod 'UMCommon'
  pod 'UMDevice'
  pod 'UMVerify'
  pod 'UMCCommonLog',           :configurations => ['Debug']
  pod 'UMShare/Social/WeChat'
  pod 'UMShare/Social/QQ'
  
	pod 'IQKeyboardManager'
	pod 'Bugly'
	pod 'LookinServer',           :configurations => ['Debug']

	pod 'FluentDarkModeKit'
  pod 'MarkdownKit'
	pod 'AlicloudHTTPDNS'
  
  # pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SnapKit'
  pod 'TOCropViewController'
  
  pod 'JXPagingView'
  pod 'JXSegmentedView'
  pod 'JXBanner'
  
  pod 'RYTransitioningDelegateSwift'
  pod 'RYAngelWalker'
  
end

target 'CyxbsWidgetExtension' do
  
end

M1_VALID_ARCHS = ['Pods-CyxbsMobile2019_iOS']
M1_EXCLUDED_ARCHS_iphonesimulator = ['YYKit', 'UMDevice']

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "target #{target}"
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['HEADER_SEARCH_PATHS'] = '$(PROJECT_DIR)/**'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      
      if M1_VALID_ARCHS.include?(target.name)
        config.build_settings['VALID_ARCHS'] = 'x86_64'
      end
      
      if M1_EXCLUDED_ARCHS_iphonesimulator.include?(target.name)
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      end
    end
  end
end

=begin

如果你是 M1 芯片:
每次 pod install 之前，删除 podfile.lock 后再执行
真机子/发版:
注释掉这些地方:

# if M1_VALID_ARCHS.include?(target.name)
#   config.build_settings['VALID_ARCHS'] = 'x86_64'
# end

# if M1_EXCLUDED_ARCHS_iphonesimulator.include?(target.name)
  config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
# end

注意，`config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'` 并没有被注释掉
然后删除 podfile.lock 后再执行 pod install 就行，这样，你就可以正常在真机和发版的时候跑了

备注 XC 的 Ruby 来源：
https://www.rubydoc.info/github/CocoaPods/Xcodeproj/Xcodeproj/Project/Object/XCBuildConfiguration
这个文档对应的是下面这个 config 的属性

target.build_configurations.each do |config|
...
end

!!!: 适配指南

1. if target.name == 'Release'
  这个方法将导致 YYKit 内部判断出错

2. M1_EXCLUDED_ARCHS_iphonesimulator = [...]
  这个方法无法使 UMCommon 正常编译

3. M1_VALID_ARCHS = [...]
  这个方法只对 主.project 有用，并不对第三方库 Pods.project 有用

=end
