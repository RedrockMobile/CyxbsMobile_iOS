//
//  UserItemTool.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/24.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "UserItemTool.h"
#import "LoginViewController.h"

@interface UserItemTool ()

@property (nonatomic, strong) UserItem *item;

@end

@implementation UserItemTool

#pragma mark - 单例
// 该单例对象不能在其他类中获取，因为获取了以后没什么卵用
static UserItemTool *instance;
+ (UserItemTool *)defaultTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserItemTool alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

#pragma mark - 工具类方法
+ (NSString *)userItemPath {
    return [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), @"UserItem.data"];
}

+ (UserItem *)defaultItem {
    UserItem *item = [UserItem defaultItem];
    UserItemTool *tool = [UserItemTool defaultTool];
    [tool addObserver:tool forKeyPath:@"item" options:NSKeyValueObservingOptionNew context:nil];
    
    return item;
}

+ (void)archive:(UserItem *)item {
    [NSKeyedArchiver archiveRootObject:item toFile:[UserItemTool userItemPath]];
}

/// 退出登录（清除用户缓存）
+ (void)logout {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if (tabBarVC.presentedViewController) {
        [tabBarVC dismissViewControllerAnimated:YES completion:^{
            [tabBarVC presentViewController:loginVC animated:YES completion:nil];
        }];
    } else {
        [tabBarVC presentViewController:loginVC animated:YES completion:nil];
    }
    
    NSString *filePath = [self userItemPath];
    
    // 删除偏好设置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults dictionaryRepresentation];
    for (id key in dic) {
        [defaults removeObjectForKey:key];
    }
    // 删除归档
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *err;
        [fileManager removeItemAtPath:filePath error:&err];
    }
}

+ (void)refresh {
    __block UserItem *item = [UserItemTool defaultItem];
    
    NSDictionary *params = @{
        @"refreshToken": item.refreshToken
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 这个请求需要上传json
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:REFRESHTOKENAPI parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
        
        NSLog(@"%@", [UserItemTool defaultItem].token);

        if (error) {
            NSLog(@"%@", error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - KVO监听相关
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [UserItemTool archive:change[@"new"]];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"item" context:nil];
}

@end
