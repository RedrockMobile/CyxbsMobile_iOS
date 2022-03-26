source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

platform :ios,'11.0'
use_frameworks!


target 'CyxbsMobile2019_iOS' do
  	pod 'MGJRouter'
	pod 'TZImagePickerController','~> 3.3.2'
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
      
  # For Swift:
  
  pod 'Alamofire', '~> 5.2'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'RxSwift', '~> 5.1.1'
  pod 'RxCocoa', '~> 5.1.1'
  pod 'SnapKit'

    post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
    config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    config.build_settings['VALID_ARCHS'] = 'arm64 arm64e armv7 armv7s x86_64 i386'
    config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
    end
  
end

#去除AFN中的UIWebView模块
pre_install do |installer|
    puts 'pre_install begin....'
    dir_af = File.join(installer.sandbox.pod_dir('AFNetworking'), 'UIKit+AFNetworking')
    Dir.foreach(dir_af) {|x|
      real_path = File.join(dir_af, x)
      if (!File.directory?(real_path) && File.exists?(real_path))
        if((x.start_with?('UIWebView') || x == 'UIKit+AFNetworking.h'))
          File.delete(real_path)
          puts 'delete:'+ x
        end
      end
    }
    puts 'end pre_install.'
    end
