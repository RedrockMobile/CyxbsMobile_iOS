//
//  LoginModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/23.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "LoginModel.h"
#import "UserItem.h"


@implementation LoginModel
//
//- (void)loginWithStuNum:(NSString *)stuNum
//               andIdNum:(NSString *)idNum
//              succeeded:(void (^)(NSDictionary * _Nonnull))succeeded
//                 failed:(void (^)(NSError * _Nonnull))failed {
//    NSDictionary *params = @{
//        @"stuNum": stuNum,
//        @"idNum": idNum
//    };
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    // 这个请求需要上传json
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//
//    [manager POST:LOGINAPI parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        // 返回的responseObject[@"data"][@"token"]是一个base64编码的字符串
//        // 以'.'分隔为前后两段。
//        // 前半段base64解码为用户信息的json字符串，后面半段为签名。
//        NSString *token = responseObject[@"data"][@"token"];
//        NSString *payload_BASE64 = [token componentsSeparatedByString:@"."][0];
//
//        // 这里要把json字符串转换为字典
//        NSData *payloadData = [[NSData alloc] initWithBase64EncodedString:payload_BASE64 options:0];
//        NSError *error;
//        NSMutableDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:&error];
//        jsonObject[@"token"] = responseObject[@"data"][@"token"];
//        jsonObject[@"refreshToken"] = responseObject[@"data"][@"refreshToken"];
//
//        // 执行回调
//        succeeded(jsonObject);
//        if (error) {
//            failed(error);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failed(error);
//    }];
//}

- (void)loginWithStuNum:(NSString *)stuNum
               andIdNum:(NSString *)idNum
              succeeded:(void (^)(NSDictionary * _Nonnull))succeeded
                 failed:(void (^)(NSError * _Nonnull))failed {
    NSDictionary *parameters = @{
                                 @"stuNum": stuNum,
                                 @"idNum": idNum
                                 };
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithJson:LOGINAPI method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *token = responseObject[@"data"][@"token"];
        NSString *payload_BASE64 = [token componentsSeparatedByString:@"."][0];
        
        // 这里要把json字符串转换为字典
        NSData *payloadData = [[NSData alloc] initWithBase64EncodedString:payload_BASE64 options:0];
        NSError *error;
        NSMutableDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:&error];
        jsonObject[@"token"] = responseObject[@"data"][@"token"];
        jsonObject[@"refreshToken"] = responseObject[@"data"][@"refreshToken"];
        
        // 执行回调
        succeeded(jsonObject);
        if (error) {
            failed(error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(error);
    }];
}

@end
