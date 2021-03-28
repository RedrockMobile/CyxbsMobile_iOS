//
//  FollowGroupModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "FollowGroupModel.h"

@implementation FollowGroupModel

- (void)FollowGroupWithName:(NSString *)name {
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *dic = @{@"topic_name":name};
    [client requestWithPath:NEW_QA_STARGROUP method:HttpRequestPost parameters:dic prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"关注圈子成功");
        NSDictionary *dict = @{@"GroupName":name};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickedFollowGroupBtn" object:nil userInfo:dict];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"关注圈子失败");
    }];
}

@end
