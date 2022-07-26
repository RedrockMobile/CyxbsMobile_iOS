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
    [client requestWithPath:NewQA_POST_QAStarGroup_API method:HttpRequestPost parameters:dic prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self->_Block(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"关注圈子失败");
        self->_Block(error);
    }];
}

@end
