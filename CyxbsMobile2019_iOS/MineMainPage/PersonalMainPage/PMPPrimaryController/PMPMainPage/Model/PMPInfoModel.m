//
//  PMPInfoModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/24.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPInfoModel.h"

// 获取信息
#define GetInfo @"magipoke/person/info"
// 关注
#define FocusUser @"magipoke-loop/user/focus"
// 换背景图片
#define UploadBackground @"magipoke/person/background_url"

@implementation PMPInfoModel

+ (void)getDataWithRedid:(NSString *)redid
                 Success:(void (^)(PMPInfoModel * _Nonnull))success
                 failure:(void (^)(void))failure {
    NSDictionary * parameters = @{
        @"redid" : redid
    };
    [[HttpClient defaultClient]
     requestWithPath:[CyxbsMobileBaseURL_1 stringByAppendingString:GetInfo]
     method:HttpRequestGet
     parameters:parameters
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
        PMPInfoModel * infoModel = [PMPInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        success(infoModel);
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
        failure();
    }];
}

+ (void)uploadbackgroundImage:(UIImage *)backgroundImage
                      success:(void (^)(NSDictionary * _Nonnull))success
                      failure:(void (^)(NSError * _Nonnull))failure {
    [HttpTool.shareTool
     form:[CyxbsMobileBaseURL_1 stringByAppendingString:UploadBackground]
     type:(HttpToolRequestTypePut)
     parameters:nil
     bodyConstructing:^(id<AFMultipartFormData>  _Nonnull body) {
        if (backgroundImage) {
            [body
             appendPartWithFileData:UIImagePNGRepresentation(backgroundImage)
             name:@"pic"
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

+ (void)focusWithRedid:(NSString *)redid
               success:(nonnull void (^)(BOOL))success
               failure:(nonnull void (^)(void))failure {
    NSDictionary * parameters = @{
        @"redid" : redid
    };
    [[HttpClient defaultClient]
     requestWithPath:[CyxbsMobileBaseURL_1 stringByAppendingString:FocusUser]
     method:HttpRequestPost
     parameters:parameters
     prepareExecute:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
        BOOL result = [responseObject[@"info"] isEqualToString:@"success"];
        success(result);
    }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (NSString*)getUserWithTailURL:(NSString*)tailURL {
    return [[NSUserDefaults.standardUserDefaults objectForKey:@"baseURL"] stringByAppendingPathComponent:tailURL];
}

@end
