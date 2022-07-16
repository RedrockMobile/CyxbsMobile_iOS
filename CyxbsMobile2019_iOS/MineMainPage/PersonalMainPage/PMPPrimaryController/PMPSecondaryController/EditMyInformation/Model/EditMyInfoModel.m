//
//  EditMyInfoModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoModel.h"

// 修改信息
#define PutPersonInfo @"magipoke/person/info"

// 修改头像
#define PutUploadAvatar @"magipoke/upload/avatar"

@implementation EditMyInfoModel

+ (void)uploadProfile:(UIImage *)profile
              success:(void (^)(NSDictionary * _Nonnull))success
              failure:(void (^)(NSError * _Nonnull))failure {
    [HttpTool.shareTool
     form:[CyxbsMobileBaseURL_1 stringByAppendingString:PutUploadAvatar]
     type:(HttpToolRequestTypePut)
     parameters:nil
     bodyConstructing:^(id<AFMultipartFormData>  _Nonnull body) {
        if (profile) {
            [body
             appendPartWithFileData:UIImagePNGRepresentation(profile)
             name:@"fold"
             fileName:[NSString stringWithFormat:@"%ld.png", [NSDate nowTimestamp]]
             mimeType:@"image/png"];
            [body
             appendPartWithFormData:[[UserDefaultTool getStuNum] dataValue]
             name:@"stunum"];
        }
    }
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        success(object);
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)uploadUserInfo:(NSDictionary *)userInfo
               success:(void (^)(NSDictionary * _Nonnull))success
               failure:(void (^)(NSError * _Nonnull))failure {
    [HttpTool.shareTool
     form:[CyxbsMobileBaseURL_1 stringByAppendingString:PutPersonInfo]
     type:(HttpToolRequestTypePut)
     parameters:nil
     bodyConstructing:^(id<AFMultipartFormData>  _Nonnull body) {
        for (NSString * key in userInfo) {
            [body
             appendPartWithFormData:userInfo[key]
             name:key];
        }
    }
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        success(object);
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (NSString*)getUserWithTailURL:(NSString*)tailURL {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"baseURL"] stringByAppendingPathComponent:tailURL];
}

@end
