//
// Created by RainyTunes on 12/8/15.
// Copyright (c) 2015 We.Can. All rights reserved.
//

#import "HCHttp.h"
#import "AFURLSessionManager.h"


@implementation HCHttp

+ (void)requestImageFrom:(NSString *)URLString
        completionHandler:(nullable void (^)(UIImage *image,  NSError * _Nullable error))completionHandler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager  *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        UIImage *image = [UIImage imageWithData:responseObject];
        completionHandler(image, error);
    }];
    [dataTask resume];
}

+ (void)requestStringFrom:(NSString *)URLString
        completionHandler:(nullable void (^)(NSString *responseString,  NSError * _Nullable error))completionHandler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager  *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        completionHandler(string, error);
    }];
    [dataTask resume];
}
@end