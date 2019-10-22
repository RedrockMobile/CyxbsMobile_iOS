//
// Created by RainyTunes on 12/8/15.
// Copyright (c) 2015 We.Can. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIImageView+AFNetworking.h"

@interface HCHttp : NSObject
//+ (void)requestImageWithId:(NSString *)id imageView:(UIImageView *)imageView delegate:(UIViewController *)delegate;

+ (void)requestImageFrom:(NSString *)URLString completionHandler:(void (^)(UIImage *, NSError *))completionHandler;

+ (void)requestStringFrom:(NSString *)URLString completionHandler:(void (^)(NSString *, NSError *))completionHandler;
@end
