//
//  HttpClient.m
//  Demo
//
//  Created by 李展 on 2016/11/13.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import "HttpClient.h"
#import "UIImage+Helper.h"
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
- (id)init{
    self = [super init];
    if(self)
    {
        self.httpSessionManager = [AFHTTPSessionManager manager];
        self.httpRequestOperationManager = [AFHTTPRequestOperationManager manager];
        
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        requestSerializer.timeoutInterval = 15.0;
        [self.httpSessionManager setRequestSerializer:requestSerializer];
        [self.httpRequestOperationManager setRequestSerializer:requestSerializer];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        [responseSerializer setRemovesKeysWithNullValues:YES];
        [responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]];
        [self.httpSessionManager setResponseSerializer:responseSerializer];
        [self.httpRequestOperationManager setResponseSerializer:responseSerializer];
        
        
    }
    return self;
}

- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock) prepare
               progress:(void (^)(NSProgress * progress))progress
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    NSString *token = [UserItem defaultItem].token;
    if (token) {
        [self.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token]  forHTTPHeaderField:@"authorization"];
    }
    switch (method) {
        case HttpRequestGet:
            [self.httpSessionManager GET:url parameters:parameters success:success failure:failure];
            break;
        case HttpRequestPost:
            [self.httpSessionManager POST:url parameters:parameters success:success failure:failure];
            break;
        case HttpRequestPut:
            [self.httpSessionManager PUT:url parameters:parameters success:success failure:failure];
            break;
        case HttpRequestDelete:
            [self.httpSessionManager DELETE:url parameters:parameters success:success failure:failure];
            break;
        default:
            break;
    }
}

- (void)requestWithJson:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock) prepare
               progress:(void (^)(NSProgress * progress))progress
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *token = [UserItem defaultItem].token;
    if (token) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token]  forHTTPHeaderField:@"authorization"];
    }
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
}



//- (void)requestWithHead:(NSString *)url
//                 method:(NSInteger)method
//             parameters:(id)parameters
//                   head:(NSDictionary *)head
//         prepareExecute:(PrepareExecuteBlock) prepare
//               progress:(void (^)(NSProgress * progress))progress
//                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
//                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    for (int i = 0; i < head.count; i++) {
//        [manager.requestSerializer setValue:head.allValues[i]  forHTTPHeaderField:head.allKeys[i]];
//    }
//    
//    switch (method) {
//        case HttpRequestGet:
//            
//            [manager GET:url parameters:parameters success:success failure:failure];
//            break;
//        case HttpRequestPost:
//            [manager POST:url parameters:parameters success:success failure:failure];
//            
//            break;
//        case HttpRequestPut:
//            [manager PUT:url parameters:parameters success:success failure:failure];
//            break;
//        case HttpRequestDelete:
//            [manager DELETE:url parameters:parameters success:success failure:failure];
//            break;
//        default:
//            break;
//    }
//    
//}

- (void)uploadImageWithJson:(NSString *)url
                     method:(NSInteger)method
                 parameters:(id)parameters imageArray:(NSArray<UIImage  *> *)imageArray imageNames:(NSArray<NSString *> *)imageNames
             prepareExecute:(PrepareExecuteBlock) prepare
                   progress:(void (^)(NSProgress * progress))progress
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *token = [UserItem defaultItem].token;
    if (token) {
        [self.httpRequestOperationManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token]  forHTTPHeaderField:@"authorization"];
    }
    //发送网络请求
    [self.httpRequestOperationManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < imageArray.count; i++) {
            UIImage *image = imageArray[i];
            UIImage *image1 = [image cropEqualScaleImageToSize:image.size isScale:YES];
            NSData *data = UIImageJPEGRepresentation(image1, 0.8);
            [formData appendPartWithFileData:data name:imageNames[i] fileName:@"tmp.png" mimeType:@"image/png"]; }
        
    } success:success failure:failure];
}

- (void)cancelRequest
{
        if ([self.httpSessionManager.tasks count] > 0) {
                NSLog(@"返回时取消网络请求");
                [self.httpSessionManager.tasks makeObjectsPerformSelector:@selector(cancel)];
                //NSLog(@"tasks = %@",manager.tasks);
            }
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
