//
//  HttpClient.m
//  Demo
//
//  Created by 李展 on 2016/11/13.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import "HttpClient.h"
@implementation HttpClient

+ (HttpClient *)defaultClient
{
    static HttpClient *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock) prepare
               progress:(void (^)(NSProgress * progress))progress
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 以json格式向服务器发送请求
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    // 处理服务器返回null
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager setResponseSerializer:serializer];
    manager.responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]];
    switch (method) {
        case HttpRequestGet:
            //            [manager GET:url parameters:parameters progress:progress success:success failure:failure];
            [manager GET:url parameters:parameters success:success failure:failure];
            break;
        case HttpRequestPost:
            [manager POST:url parameters:parameters success:success failure:failure];
            //            [manager POST:url parameters:parameters progress:progress success:success failure:failure];
            break;
        case HttpRequestPut:
            [manager PUT:url parameters:parameters success:success failure:failure];
            break;
        case HttpRequestDelete:
            [manager DELETE:url parameters:parameters success:success failure:failure];
            break;
        default:
            break;
    }
    //超时时间30s
    manager.requestSerializer.timeoutInterval = 30.0;
}


- (void)requestWithJson:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock) prepare
               progress:(void (^)(NSProgress * progress))progress
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 请求需要json
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    switch (method) {
        case HttpRequestGet:
            [manager GET:url parameters:parameters success:success failure:failure];
            break;
        case HttpRequestPost:
            [manager POST:url parameters:parameters success:success failure:failure];
            break;
        case HttpRequestPut:
            [manager PUT:url parameters:parameters success:success failure:failure];
            break;
        case HttpRequestDelete:
            [manager DELETE:url parameters:parameters success:success failure:failure];
            break;
        default:
            break;
    }
    //超时时间30s
    manager.requestSerializer.timeoutInterval = 30.0;
}


- (void)requestWithPathInHEAD:(NSString *)url
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger HEAD:url parameters:parameters success:success failure:failure];
}


- (void)requestWithHead:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
                   head:(NSDictionary *)head
         prepareExecute:(PrepareExecuteBlock) prepare
               progress:(void (^)(NSProgress * progress))progress
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    for (int i = 0; i < head.count; i++) {
        [manager.requestSerializer setValue:head.allValues[i]  forHTTPHeaderField:head.allKeys[i]];
    }
    
    // 以json格式向服务器发送请求
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    // 处理服务器返回null
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager setResponseSerializer:serializer];
    manager.responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]];
    switch (method) {
        case HttpRequestGet:
            
            [manager GET:url parameters:parameters success:success failure:failure];
            break;
        case HttpRequestPost:
            [manager POST:url parameters:parameters success:success failure:failure];
            
            break;
        case HttpRequestPut:
            [manager PUT:url parameters:parameters success:success failure:failure];
            break;
        case HttpRequestDelete:
            [manager DELETE:url parameters:parameters success:success failure:failure];
            break;
        default:
            break;
    }
    
}

- (void)uploadImageWithJson:(NSString *)url
                 method:(NSInteger)method
                 parameters:(id)parameters imageArray:(NSArray<UIImage  *> *)imageArray 
         prepareExecute:(PrepareExecuteBlock) prepare
               progress:(void (^)(NSProgress * progress))progress
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 15.0;
    //发送网络请求
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < imageArray.count; i++) {
            UIImage *image = imageArray[i];
            NSData *data = UIImagePNGRepresentation(image);
//            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"photo[%d]",i] fileName:[NSString stringWithFormat:@"image%d.png",i] mimeType:@"image/png"]; }
         [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"photo%d",i] fileName:@"tmp.png" mimeType:@"image/png"]; }
        
    } success:success failure:failure];
}
//- (BOOL)isReachability{
//    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
//    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        if (status == AFNetworkReachabilityStatusNotReachable) {
//            
//        }
//        else{
//            
//        }
//    }];
//    [reachabilityManager startMonitoring];

//    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        if (status == AFNetworkReachabilityStatusNotReachable) {
//            return NO;
//            //网络无连接的提示
//        }
//    }];
//}
@end
