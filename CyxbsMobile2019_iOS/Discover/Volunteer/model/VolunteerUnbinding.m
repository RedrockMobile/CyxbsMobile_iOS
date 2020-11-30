//
//  VolunteerUnbinding.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/28.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "VolunteerUnbinding.h"
#import <AFNetworking.h>

@implementation VolunteerUnbinding

- (void)VolunteerUnbinding {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    [responseSerializer setRemovesKeysWithNullValues:YES];
    [responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]];

    manager.responseSerializer = responseSerializer;

    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserItemTool defaultItem].token]  forHTTPHeaderField:@"Authorization"];
    
    [manager POST:VOLUNTEERUNBINDING parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"解绑志愿者信息失败");
    }];
}

@end
