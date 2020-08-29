//
//  AppDelegate.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/22.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "AppDelegate.h"
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>
#import <UMShare/UMShare.h>
#import <UMAnalytics/MobClick.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import "VolunteeringEventItem.h"
#import "VolunteerItem.h"

extern CFAbsoluteTime StartTime;
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 如果打开应用时有学号密码，但是没有token，退出登录
    if ([UserDefaultTool getStuNum] && ![UserItemTool defaultItem].token) {
        [UserItemTool logout];
    }
    
    // 打开应用时刷新token
    [UserItemTool refresh];
 
    // 刷新志愿信息
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setRemovesKeysWithNullValues:YES];
    [responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]];
    
    manager.responseSerializer = responseSerializer;
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic enNjeTpyZWRyb2Nrenk="]  forHTTPHeaderField:@"Authorization"];
    
    VolunteerItem *volunteerItem = [[VolunteerItem alloc] init];
    
    NSDictionary *requestParams = @{
        @"uid": [volunteerItem aesEncrypt:[UserDefaultTool getStuNum]]
    };
    
    volunteerItem.uid = [volunteerItem aesEncrypt:[UserDefaultTool getStuNum]];
    
    [manager POST:VOLUNTEERREQUEST parameters:requestParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:10];
        for (NSDictionary *dict in responseObject[@"record"]) {
            VolunteeringEventItem *volEvent = [[VolunteeringEventItem alloc] initWithDictinary:dict];
            [temp addObject:volEvent];
        }
        volunteerItem.eventsArray = temp;
        [volunteerItem sortEvents];
        
        NSInteger hour = 0;
        for (VolunteeringEventItem *event in volunteerItem.eventsArray) {
            hour += [event.hour integerValue];
        }
        volunteerItem.hour = [NSString stringWithFormat:@"%ld", hour];
        
        [volunteerItem archiveItem];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
    //初始化umenge功能
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:@"573183a5e0f55a59c9000694" channel:nil];
    
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
    
    //配置统计场景，E_UM_NORMAL为普通场景
    [MobClick setScenarioType:E_UM_NORMAL];//支持普通场景
    
    //umeng推送设置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else
        {
        }
    }];
    
    [UMessage openDebugMode:YES];
    [UMessage setWebViewClassString:@"UMWebViewController"];
    [UMessage addLaunchMessage];
    //请求获取通知权限
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            //获取用户是否同意开启通知
            if (granted) {
                NSLog(@"request authorization successed!");
            }
        }];
    } else {
        // Fallback on earlier versions
    }
//    // Share's setting
//    [self setupUSharePlatforms];   // required: setting platforms on demand
//    [self setupUShareSettings];
//

    double launchTime = (CFAbsoluteTimeGetCurrent() - StartTime);
    NSLog(@"double======%f",launchTime);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppDelegate_applicationDidBecomeActive" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
        
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
        //如果点击的是每日推送课表的消息，那么延时0.2秒后发送通知，让DiscoverViewController弹出课表
        //0.2秒用于加载UI，不延时会导致发送通知时DiscoverViewController还未加载完成
        //用se2模拟器模拟下只延时0.05s也不会有什么问题，保险起见延时0.2s后发送通知
        if([response.notification.request.identifier
            isEqualToString:@"deliverSchedulEverday"]
           || [response.notification.request.identifier
              isEqualToString:@"remindBeforeCourseBegin"]
           ){
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DiscoverVCShouldPresentMySchedul" object:nil];
            });
        }
    }
}
@end

