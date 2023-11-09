//
//  UserItemTool.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/24.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "UserItemTool.h"
#import "LoginVC.h"
#import <UMShare/UMShare.h>
#import "UserDefaultTool.h"
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
    LoginVC *loginVC = [[LoginVC alloc] init];
    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;

    UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if (tabBarVC.presentedViewController) {
        [tabBarVC dismissViewControllerAnimated:YES completion:^{
            [tabBarVC presentViewController:loginVC animated:YES completion:nil];
        }];
    } else {
        [tabBarVC presentViewController:loginVC animated:YES completion:nil];
    }
    
    //假销毁单例
    [[UserItem defaultItem] attemptDealloc];
    
    NSString *filePath = [self userItemPath];
    
    // 删除偏好设置，删除时保留baseURL的偏好信息
    NSDictionary *dic = [NSUserDefaults.standardUserDefaults dictionaryRepresentation];
    for (id key in dic) {
        if (![key  isEqual: @"baseURL"]) {
            [NSUserDefaults.standardUserDefaults removeObjectForKey:key];
        }
    }
    
    // 删除归档
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *err;
        [fileManager removeItemAtPath:filePath error:&err];
    }
    
    NSLog(@"%@", NSHomeDirectory());
    
//    [UserDefaultTool removeALLData];
    
//    NSLog(@"%@",[UserItemTool defaultItem]);
    
//    [UserItem attemptDealloc];
    
//    [UserItem defaultItem].token = nil;
    
//    [ArchiveTool deleteFile];
//    [PostArchiveTool removePostModel];
//    [PostArchiveTool removeGroupModel];
//    [PostArchiveTool removeHotWordModel];
//    [PostArchiveTool removePostCellHeight];
    
    //清除课表数据和备忘数据
    [[NSFileManager defaultManager] removeItemAtPath:remAndLesDataDirectoryPath error:nil];
    
    //清除所有已有的本地通知
//    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
//    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    
    // 退出后停止umeng统计发送数据
//    [MobClick profileSignOff];
    
    // 退出后移除友盟推送别名
//    [UMessage removeAlias:[UserItemTool defaultItem].stuNum type:@"cyxbs" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//        
//    }];
    
    // 退出后把隐私政策的已读设置成未读（有可能是另外的人和账号登录）
    [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"ReadPrivacyTip"];
}

+ (void)refresh {
    __block UserItem *item = [UserItemTool defaultItem];
    NSString *userDefaultRefreshToken = UserDefaultTool.getRefreshToken;
    if ((!item.refreshToken)) {
        if ([userDefaultRefreshToken isNotBlank]) {
            item.refreshToken = userDefaultRefreshToken;
        }else{
            [self LoginAgain];
        }
        return;
    }
    
    NSDictionary *params = @{
        @"refreshToken":item.refreshToken
    };
    
    [HttpTool.shareTool request:Mine_POST_refreshToken_API
                           type:HttpToolRequestTypePost
                     serializer:HttpToolRequestSerializerJSON
                 bodyParameters:params
                       progress:nil
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        if ([object[@"status"] intValue] == 10000) {
            //表示刷新 token 接口正常 statusBall 为绿色
            [NSUserDefaults.standardUserDefaults setInteger:-1 forKey:IS_TOKEN_URL_ERROR_INTEGER];
            
            //取出 token 和 refreshToken
            NSString *token = object[@"data"][@"token"];
            NSString *refreshToken = object[@"data"][@"refreshToken"];
            
            // 解析数据
            NSString *payload_BASE64 = [token componentsSeparatedByString:@"."][0];
            NSData *payloadData = [[NSData alloc] initWithBase64EncodedString:payload_BASE64 options:0];
            NSError *error;
            NSMutableDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:&error];
            
            // json字符串转换字典
            jsonObject[@"token"] = token;
            jsonObject[@"refreshToken"] = refreshToken;
            
            // 归档
            item = [UserItem mj_objectWithKeyValues:jsonObject];
            [UserItemTool archive:item];
            // 保存token和refreshToken
            [NSUserDefaults.standardUserDefaults setValue:token forKey:@"token"];
            [NSUserDefaults.standardUserDefaults setValue:refreshToken forKey:@"refreshToken"];
            
            NSLog(@"token刷新成功, token 为:%@", [UserItemTool defaultItem].token);
        }else{
            NSLog(@"token刷新失败,错误码:%d,%@",[object[@"status"] intValue],object[@"info"]);
            [self LoginAgain];
        }
    }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self LoginAgain];
    }];
}

///重新登陆
+ (void)LoginAgain {
    // token刷新失败，可能是用户token过期或者出了别的什么问题，提示用户重新登录
    UIAlertController *loginAlertController = [UIAlertController alertControllerWithTitle:@"登录已过期" message:@"登录验证信息失效，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 直接退出登录
        [self logout];
    }];
    [loginAlertController addAction:loginAction];
    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [loginAlertController addAction:closeAction];
    
    UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if (tabBarVC.presentedViewController) {
        [tabBarVC dismissViewControllerAnimated:YES completion:^{
            [tabBarVC presentViewController:loginAlertController animated:YES completion:nil];
        }];
    } else {
        [tabBarVC presentViewController:loginAlertController animated:YES completion:nil];
    }
}

+ (void)checkVisibleAPI:(void (^)(NSString *url))success {
    [HttpTool.shareTool
     request:Cyxbs_check_API_Get
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSString *baseURL = [NSString stringWithFormat:@"https://%@/", object[@"data"][@"base_url"]];
        if (success) {
            success(baseURL);
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+ (BOOL)tokenExpired {
    // 获取当前时间戳
    NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
    
    // 获取令牌过期时间戳
    NSTimeInterval expTimestamp = [UserItem.defaultItem.exp doubleValue];
    
    // 检查令牌是否过期，这里使用了当前时间戳和过期时间戳进行比较
    if (expTimestamp - currentTimestamp < 0) {
        return YES; // 令牌已过期
    } else {
        return NO; // 令牌未过期
    }
}

@end
