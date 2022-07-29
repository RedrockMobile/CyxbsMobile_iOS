//
//  PMPInfoModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/24.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPInfoModel.h"

@implementation PMPInfoModel

+ (void)getDataWithRedid:(NSString *)redid
                 Success:(void (^)(PMPInfoModel * _Nonnull))success
                 failure:(void (^)(void))failure {
    NSDictionary * parameters = @{
        @"redid" : redid
    };
    
    [HttpTool.shareTool
     request:MineMainPage_GET_getInfo_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:parameters
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        PMPInfoModel * infoModel = [PMPInfoModel mj_objectWithKeyValues:object[@"data"]];
        if (success) {
            success(infoModel);
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
        if (failure) {
            failure();
        }
    }];
    
//    [[HttpClient defaultClient]
//     requestWithPath:MineMainPage_GET_getInfo_API
//     method:HttpRequestGet
//     parameters:parameters
//     prepareExecute:nil
//     progress:nil
//     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
//        PMPInfoModel * infoModel = [PMPInfoModel mj_objectWithKeyValues:object[@"data"]];
//        if (success) {
//            success(infoModel);
//        }
//    }
//     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"failure");
//        if (failure) {
//            failure();
//        }
//    }];
}

+ (void)uploadbackgroundImage:(UIImage *)backgroundImage
                      success:(void (^)(NSDictionary * _Nonnull))success
                      failure:(void (^)(NSError * _Nonnull))failure {
    [HttpTool.shareTool
     form:MineMainPage_PUT_uploadBackground_API
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
        if (success) {
            success(object);
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)focusWithRedid:(NSString *)redid
               success:(nonnull void (^)(BOOL))success
               failure:(nonnull void (^)(void))failure {
    NSDictionary * parameters = @{
        @"redid" : redid
    };
    
    [HttpTool.shareTool
     request:MineMainPage_POST_focusUser_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:parameters
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        BOOL result = [object[@"info"] isEqualToString:@"success"];
        if (success) {
            success(result);
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
//    [[HttpClient defaultClient]
//     requestWithPath:MineMainPage_POST_focusUser_API
//     method:HttpRequestPost
//     parameters:parameters
//     prepareExecute:nil
//     progress:nil
//     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
//        BOOL result = [object[@"info"] isEqualToString:@"success"];
//        if (success) {
//            success(result);
//        }
//    }
//     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
}

- (NSString*)getUserWithTailURL:(NSString*)tailURL {
    return [[NSUserDefaults.standardUserDefaults objectForKey:@"baseURL"] stringByAppendingPathComponent:tailURL];
}

@end
