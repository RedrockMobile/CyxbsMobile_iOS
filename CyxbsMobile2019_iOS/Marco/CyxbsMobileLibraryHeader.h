//
//  CyxbsMobileLibraryHeader.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/20.
//  Copyright © 2021 Redrock. All rights reserved.
//这里面放导入的第三方库的头文件

#ifndef CyxbsMobileLibraryHeader_h
#define CyxbsMobileLibraryHeader_h

#pragma mark - 头文件

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import <YYKit.h>
#import <Masonry.h>
#import <MBProgressHUD.h>
#import <MJExtension.h>
#import "HttpClient.h"
#import "UIColor+Helper.h"
#import "UITextView+Placeholder.h"
#import "UserDefaultTool.h"
#import "UserItemTool.h"
#import "BaseViewController.h"
#import "NSDate+Timestamp.h"
#import "URLController.h"
#import <UMAnalytics/MobClick.h>
#import "SDMask.h"
#import "CQUPTMapPlaceRect.h"   // 重邮地图里用的，很多文件都要导入这个，太麻烦了，直接写这里好了
#import "AESCipher.h"           // AES加密算法
#import <MGJRouter.h>
#import <SDWebImage/SDWebImage.h>

// Category
#import "UIView+Frame.h"
#import "NSDate+Day.h"

//自定义hud
#import "NewQAHud.h"

#import "MGDStatusBarHeight.h"
#import "UIColor+SYColor.h"


#pragma mark - Group共享
#define kAPPGroupID @"group.com.redrock.mobile"
#define kAppGroupShareNowDay @"nowDay"
#define kAppGroupShareThisWeekArray @"thisWeekArray"
#define kAPPUserDefaultLoginName @"name"
#define kAPPUserDefaultStudentID @"stuNum"



#pragma mark - 友盟
// 友盟DeciveToken
#define kUMDeviceToken @"kUMDeviceToken"


#pragma mark - MGJRouter用到的宏
// MGJRouter中用到的一些宏
// UserInfo的key：
#define kMGJNavigationControllerKey @"MGJNavigationControllerKey"


#endif /* CyxbsMobileLibraryHeader_h */
