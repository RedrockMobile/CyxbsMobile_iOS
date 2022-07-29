//
//  VolunteerUnbinding.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/28.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "VolunteerUnbinding.h"


@implementation VolunteerUnbinding

- (void)VolunteerUnbinding {
    [HttpTool.shareTool
    request:Discover_POST_volunteerBinding_API
    type:HttpToolRequestTypePost
    serializer:HttpToolRequestSerializerHTTP
    bodyParameters:nil
    progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"解绑志愿者信息失败");
    }];
    
}

@end
