//
//  UserItemTool.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/24.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "UserItemTool.h"
//#import "LoginViewController.h"
#import <UMPush/UMessage.h>
#import "ArchiveTool.h"

#import "PostArchiveTool.h"
#import "掌上重邮-Swift.h"        // 将Swift中的类暴露给OC
@interface UserItemTool ()

@property (nonatomic, strong) UserItem *item;

@end


@implementation UserItemTool

#pragma mark - 工具类方法
+ (NSString *)userItemPath {
    return [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), @"UserItem.data"];
}

+ (UserItem *)defaultItem {
    UserItem *item = [UserItem defaultItem];
    return item;
}

+ (void)archive:(UserItem *)item {
    [NSKeyedArchiver archiveRootObject:item toFile:[UserItemTool userItemPath]];
}

/// 退出登录（清除用户缓存）
+ (void)logout {
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if (tabBarVC.presentedViewController) {
        [tabBarVC dismissViewControllerAnimated:YES completion:^{
            [tabBarVC presentViewController:navController animated:YES completion:nil];
        }];
    } else {
        [tabBarVC presentViewController:navController animated:YES completion:nil];
    }
    
    NSString *filePath = [self userItemPath];
    
    // 删除偏好设置，删除时保留baseURL的偏好信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults dictionaryRepresentation];
    for (id key in dic) {
        if (![key  isEqual: @"baseURL"]) {
            [defaults removeObjectForKey:key];
        }
    }
    
    // 删除归档
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *err;
        [fileManager removeItemAtPath:filePath error:&err];
    }
    
    
    [ArchiveTool deleteFile];
    [PostArchiveTool removePostModel];
    [PostArchiveTool removeGroupModel];
    [PostArchiveTool removeHotWordModel];
    [PostArchiveTool removePostCellHeight];
    
    //清除课表数据和备忘数据
    [[NSFileManager defaultManager] removeItemAtPath:remAndLesDataDirectoryPath error:nil];
    
    //清除所有已有的本地通知
    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    
    // 退出后停止umeng统计发送数据
    [MobClick profileSignOff];
    
    // 退出后移除友盟推送别名
    [UMessage removeAlias:[UserItemTool defaultItem].stuNum type:@"cyxbs" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        
    }];
}

+ (void)refresh {
    __block UserItem *item = [UserItemTool defaultItem];
    
    if (!item.refreshToken) {
        return;
    }
    
    NSDictionary *params = @{
        @"refreshToken": item.refreshToken
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 这个请求需要上传json
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[UserDefaultTool getStuNum] forHTTPHeaderField:@"STU-NUM" ];
    [manager POST:REFRESHTOKENAPI parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:IS_TOKEN_URL_ERROR_INTEGER];
        NSString *token = responseObject[@"data"][@"token"];
        NSString *payload_BASE64 = [token componentsSeparatedByString:@"."][0];
        
        // json字符串转换字典
        NSData *payloadData = [[NSData alloc] initWithBase64EncodedString:payload_BASE64 options:0];
        NSError *error;
        NSMutableDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:&error];
        jsonObject[@"token"] = responseObject[@"data"][@"token"];
        jsonObject[@"refreshToken"] = responseObject[@"data"][@"refreshToken"];
        
        item = [UserItem mj_objectWithKeyValues:jsonObject];
        [UserItemTool archive:item];
        // 保存token和refreshToken
        [UserDefaultTool saveToken:responseObject[@"data"][@"token"]];
        [UserDefaultTool saveRefreshToken:responseObject[@"data"][@"refreshToken"]];
        
        NSLog(@"token:%@", [UserItemTool defaultItem].token);

        if (error) {
            NSLog(@"tokenError1%@", error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:IS_TOKEN_URL_ERROR_INTEGER];
        NSLog(@"tokenError2：%@", error);
//        if (error.code == NSURLErrorBadServerResponse) {
        
        //获取上次登录的时间戳(和1970.1.1的秒间隔)
        double lastLogInTime = [[NSUserDefaults standardUserDefaults] doubleForKey:LastLogInTimeKey_double];
        
        //如果错误码是400或者403，并且上次登录的时间是30天前(2592000秒)，那么提示需要重新登录
        if (([error.localizedDescription hasSuffix:@"(400)"]||[error.localizedDescription hasSuffix:@"(403)"])&&(NSDate.nowTimestamp - lastLogInTime > 2592000)) {
            
            // token刷新失败，可能是用户token过期或者出了别的什么问题，提示用户重新登录
            UIAlertController *loginAlertController = [UIAlertController alertControllerWithTitle:@"登录已过期" message:@"登录验证信息失效，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 直接退出登录
                [self logout];
            }];
            
            
            [loginAlertController addAction:loginAction];
            
            UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            if (tabBarVC.presentedViewController) {
                [tabBarVC dismissViewControllerAnimated:YES completion:^{
                    [tabBarVC presentViewController:loginAlertController animated:YES completion:nil];
                }];
            } else {
                [tabBarVC presentViewController:loginAlertController animated:YES completion:nil];
            }
        }
    }];
}

@end
