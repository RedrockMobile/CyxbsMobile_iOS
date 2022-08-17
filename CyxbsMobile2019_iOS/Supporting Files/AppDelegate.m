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
#import "DynamicDetailMainVC.h"
#import <AFNetworkReachabilityManager.h>
#include "ArchiveTool.h"
#import <sqlite3.h>
#import <Bugly/Bugly.h>

#define BUGLY_APP_ID @"41e7a3c1b3"
#define SQLITE_THREADSAFE 1

extern CFAbsoluteTime StartTime;
@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@property(nonatomic, strong)AFNetworkReachabilityManager* reaManager;
@end

@implementation AppDelegate
- (void)addReaManager {
    AFNetworkReachabilityManager* man = [AFNetworkReachabilityManager sharedManager];
    self.reaManager = man;
    [man setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //把网络状态写入缓存
        [NSUserDefaults.standardUserDefaults setInteger:status forKey:@"AFNetworkReachabilityStatus"];
        [NSUserDefaults.standardUserDefaults synchronize];
        
        //发送网络发送变化的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AFNetworkReachabilityStatusChanges" object:@(status)];
    }];
    [man startMonitoring];
}
/*
- (void)netStatusChanges:(NSNotification*)noti {
    AFNetworkReachabilityStatus status = [noti.object longValue];
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            CCLog(@"AFNetworkReachabilityStatusUnknown");
            break;
        case AFNetworkReachabilityStatusNotReachable:
            CCLog(@"AFNetworkReachabilityStatusNotReachable");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            CCLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            CCLog(@"AFNetworkReachabilityStatusReachableViaWiFi");
            break;
    }
}
*/
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);
    
    [UserDefaultTool saveValue:hexToken forKey:kUMDeviceToken];
    
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    //传入的devicetoken是系统回调didRegisterForRemoteNotificationsWithDeviceToken的入参，切记
    //[UMessage registerDeviceToken:deviceToken];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Bugly startWithAppId:BUGLY_APP_ID];
    // Override point for customization after application launch.
    
    if (sqlite3_config(SQLITE_CONFIG_SERIALIZED)!=SQLITE_OK) {
        CCLog(@"Failure");
    }
    sqlite3_initialize();
    CCLog(@"%d", sqlite3_threadsafe());
    
    if ([UserDefaultTool getStuNum]) {
        [UMessage addAlias:[UserDefaultTool getStuNum] type:@"cyxbs" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            NSLog(@"%@", responseObject);
        }];
    }
    
    // 如果打开应用时有学号密码，但是没有token，退出登录
    if (([UserDefaultTool getStuNum] && ![UserItemTool defaultItem].token) || ![UserDefaultTool getStuNum]) {
        [UserItemTool logout];
    }
    [self addReaManager];
    // 打开应用时刷新token
    //开始监测网络状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([self.reaManager isReachable]){
            //如果网络可用，刷新token
            [UserItemTool refresh];
        }
    });
    //刷新token内部作了错误码判断，只有NSURLErrorBadServerResponse情况下才会要求重新登录
//    [UserItemTool refresh];
    if ([UserDefaultTool getStuNum] && [UserItemTool defaultItem].token && [ArchiveTool getPersonalInfo]) {
////         刷新志愿信息
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
//        [responseSerializer setRemovesKeysWithNullValues:YES];
//        [responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]];
//
//        manager.responseSerializer = responseSerializer;
//
//        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserItemTool defaultItem].token]  forHTTPHeaderField:@"Authorization"];
//
        VolunteerItem *volunteer = [[VolunteerItem alloc] init];

        
        [HttpTool.shareTool
         request:Discover_POST_volunteerRequest_API
         type:HttpToolRequestTypePost
         serializer:HttpToolRequestSerializerHTTP
         bodyParameters:nil
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *dict in object[@"record"]) {
                VolunteeringEventItem *volEvent = [[VolunteeringEventItem alloc] initWithDictinary:dict];
                [temp addObject:volEvent];
            }
            volunteer.eventsArray = temp;
            [volunteer sortEvents];

            NSInteger hour = 0;
            int count = 0;
            for (VolunteeringEventItem *event in volunteer.eventsArray) {
                hour += [event.hour integerValue];
                count++;
            }
            volunteer.hour = [NSString stringWithFormat:@"%ld", hour];
            volunteer.count = [NSString stringWithFormat:@"%d", count];
            [ArchiveTool saveVolunteerInfomationWith:volunteer];

        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];
        
        
//        [manager POST:Discover_POST_volunteerRequest_API parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:10];
//            for (NSDictionary *dict in responseObject[@"record"]) {
//                VolunteeringEventItem *volEvent = [[VolunteeringEventItem alloc] initWithDictinary:dict];
//                [temp addObject:volEvent];
//            }
//            volunteer.eventsArray = temp;
//            [volunteer sortEvents];
//
//            NSInteger hour = 0;
//            int count = 0;
//            for (VolunteeringEventItem *event in volunteer.eventsArray) {
//                hour += [event.hour integerValue];
//                count++;
//            }
//            volunteer.hour = [NSString stringWithFormat:@"%ld", hour];
//            volunteer.count = [NSString stringWithFormat:@"%d", count];
//            [ArchiveTool saveVolunteerInfomationWith:volunteer];
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        }];
    }
//
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
    //初始化umenge功能
    [UMConfigure setLogEnabled:NO];
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
            
        } else {
            
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
    
    // 完成创建文件/文件夹的操作
    [self setFile];
    
    // 完成每天晚上推送课表的相关操作
    [self pushSchedulEveryday];
    [self checkVersion];
    //设置存储、更换baseURL的操作
    [self settingBaseURL];
    [self addNotification];
    [self requestUserInfo];
    return YES;
}

- (void)addNotification {
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(requestUserInfo) name:@"Login_LoginSuceeded" object:nil];
}
- (void)requestUserInfo {
    [[UserItem defaultItem] getUserInfo];
}

///设置存储、更换baseURL
- (void)settingBaseURL{
#ifdef DEBUG
    [NSUserDefaults.standardUserDefaults setObject:@"https://be-prod.redrock.team/" forKey:@"baseURL"];
#else
    //如果最开始无baseURL，则设置为学校服务器
    NSString *baseURL= [NSUserDefaults.standardUserDefaults objectForKey:@"baseURL"];
    if (baseURL == nil || [baseURL isEqualToString:@""]) {
//        baseURL = @"https://be-prod.redrock.team/";
        baseURL = @"https://be-prod.redrock.cqupt.edu.cn/";
        [NSUserDefaults.standardUserDefaults setObject:baseURL forKey:@"baseURL"];
    }
    //更新baseURL
    [[HttpClient defaultClient] baseUrlRequestSuccess:^(NSString *str) {
        [NSUserDefaults.standardUserDefaults setObject:str forKey:@"baseURL"];
    }];
//    @"https://be-dev.redrock.cqupt.edu.cn/"
//    NS，，，，，，，，Log(@"baseURL%@",CyxbsMobileBaseURL_1);
#endif
    
}

///检查是否有最新的掌邮，并提示用户获取
-(void)checkVersion{
    //这个模块已重构
}

/// 完成创建文件/文件夹的操作
- (void)setFile{
    //如果存储备忘/课表 数据的目录不存在那么创建一个
    if(![[NSFileManager defaultManager] fileExistsAtPath:remAndLesDataDirectoryPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:remAndLesDataDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:remDataDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:remDataDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//设置每日推送课表的本地通知
- (void)pushSchedulEveryday{
    //移除旧的每日推送课表
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[@"deliverSchedulEverday"]];
    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[@"deliverSchedulEverday"]];
    
    //真正的当前周数
    NSString *nowWeek = getNowWeek_NSString;
    
    //如果没有打开每日推送课表开关，或者当前已配置的推送的周 和 当前真正的周相同，那么return
    if([NSUserDefaults.standardUserDefaults valueForKey:@"Mine_RemindEveryDay"]==nil || [NSUserDefaults.standardUserDefaults valueForKey:@"当前每天晚上推送的课表对应的周"]==nowWeek){
        return;
    }
    //更新已配置的推送的周
    [NSUserDefaults.standardUserDefaults setValue:nowWeek forKey:@"当前每天晚上推送的课表对应的周"];
    //下面的代码，功能是完成一周7天的通知配置
    
    //week[j][k]代表（星期j+1）的（第k+1节大课
    NSArray *week = [self getSchedulToPushAtWeek:nowWeek.intValue];
    
    //配置component
    NSDateComponents *component = [[NSDateComponents alloc] init];
    //推送时间
    component.hour = 22;
    
    //通过component配置trigger
    UNCalendarNotificationTrigger *trigger;
    
    //配置content
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = @"明日课表已送达";
    [content setSound:[UNNotificationSound defaultSound]];
    
    
    NSString *bodyStr;//通知主体
    NSString *str; //某一节课的内容
    NSString *requestIDStr; //本地通知的通知ID
    UNNotificationRequest *request; //通知请求
    int i=1;
    for (NSArray *day in week) {
        bodyStr = @"明天的课程有：";
        requestIDStr = [NSString stringWithFormat:@"每天晚上推送课表%d",i];
        //周几推送
        component.weekday = i++;
//        i++;
        for (NSArray *course in day) {
            //如果count==0说明该节课是无课
            if(course.count==0)continue;
            //拼接出单节课的str
            for (NSDictionary *courseDict in course) {
                str = [NSString stringWithFormat:@"%@ 在 %@ 上 %@\n",courseDict[@"lesson"],courseDict[@"classroom"],courseDict[@"course"]];
            }
            //将str拼接到bodyStr后面
            bodyStr = [NSString stringWithFormat:@"%@\n%@",bodyStr,str];
        }
        //如果equal，说明明天没课了
        if([bodyStr isEqualToString:@"明天的课程有："]){
            bodyStr = @"明天没课了哦～";
        }
        
        //设置推送的主体文字
        content.body = bodyStr;
        
        //配置trigger
        trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:NO];
        
        //通过trigger和content配置request
        request = [UNNotificationRequest requestWithIdentifier:requestIDStr content:content trigger:trigger];
        
        //通过request添加本地通知
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"添加%@成功",requestIDStr);
        }];
    }
    
    /**
     {
     "begin_lesson" = 1;
     classroom = 3212;
     course = "\U5927\U5b66\U751f\U804c\U4e1a\U53d1\U5c55\U4e0e\U5c31\U4e1a\U6307\U5bfc1";
     "course_num" = B1220060;
     day = "\U661f\U671f\U4e00";
     "hash_day" = 0;
     "hash_lesson" = 0;
     lesson = "\U4e00\U4e8c\U8282";
     period = 2;
     rawWeek = "1-8\U5468";
     teacher = "\U9648\U65ed";
     type = "\U5fc5\U4fee";
     week =                 (
     1,
     2,
     3,
     4,
     5,
     6,
     7,
     8
     );
     weekBegin = 1;
     weekEnd = 8;
     weekModel = all;
     }
     */
}


/// 获取week周的需要推送的课表数据
/// @param week 某一周
- (NSArray*)getSchedulToPushAtWeek:(int)week{
    //防止数组越界
    if (week>24) {
        return nil;
    }
    //全部的25周的课表信息
    NSArray * orderlySchedulArray = [NSArray arrayWithContentsOfFile:parsedDataArrPath];
    
    //下周一的课
    NSArray *nextWeekMondySchedulArray = orderlySchedulArray[week+1][0];
    NSMutableArray *nowWeekSchedulArray = [orderlySchedulArray[week] mutableCopy];
    nowWeekSchedulArray[0] = nextWeekMondySchedulArray;
    //返回orderlySchedulArray[nowWeek],因为：
    //orderlySchedulArray[i][j][k]代表（第i周）的（星期j+1）的（第k+1节大课）
    return nowWeekSchedulArray;
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

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    NSString *urlStr = [url absoluteString];
    NSLog(@"%@",urlStr);
    UINavigationController *navigationController = ((UITabBarController *)(self.window.rootViewController)).selectedViewController;
    if ([urlStr hasPrefix:@"redrock.zscy.youwen.share://"]) {
        NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSString *str = [[urlStr componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
        DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
//        _item = [[PostItem alloc] initWithDic:self.tableArray[indexPath.row]];
        dynamicDetailVC.post_id = str;
        dynamicDetailVC.hidesBottomBarWhenPushed = YES;
//        ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
//        [self.navigationController pushViewController:dynamicDetailVC animated:YES];
        [navigationController pushViewController:dynamicDetailVC animated:YES];
    }
    return YES;
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        
        // 当前选中的控制器（三个都是导航控制器）
        UINavigationController *navigationController = ((UITabBarController *)(self.window.rootViewController)).selectedViewController;

        
        if ([userInfo[@"uri"] hasPrefix:@"http"]) {
            URLController * controller = [[URLController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.toUrl = userInfo[@"uri"];
            [navigationController pushViewController:controller animated:YES];
        } else if ([userInfo[@"uri"] hasPrefix:@"cyxbs"]) {
            
            // TODO: 使用RisingRouter
            
        }
        
        
    }else{
        //应用处于后台时的本地推送接受
        //如果点击的是每日推送课表的消息，那么延时0.2秒后发送通知，让DiscoverViewController弹出课表
        //0.2秒用于加载UI，不延时会导致发送通知时DiscoverViewController还未加载完成
        //用se2模拟器模拟下只延时0.05s也不会有什么问题，保险起见延时0.2s后发送通知
        BOOL is = [response.notification.request.identifier
          hasPrefix:@"每天晚上推送课表"]
        ||[response.notification.request.identifier
           isEqualToString:@"remindBeforeCourseBegin"];
        
        //如果本地通知信息是这两个且没有打开“启动APP时显示课表”的开关
        if(is&&[UserItem defaultItem].stuNum&&[NSUserDefaults.standardUserDefaults valueForKey:@"Mine_LaunchingWithClassScheduleView"]){
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DiscoverVCShouldPresentMySchedul" object:nil];
            });
        }
    }
}

@end

