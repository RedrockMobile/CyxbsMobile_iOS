//
//  StarPostModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "StarPostModel.h"

@implementation StarPostModel

- (void)starPostWithPostID:(NSNumber *)postID {
    HttpClient *client = [HttpClient defaultClient];
    NSDictionary *param = @{@"id":postID,@"model":@"1"};
    [client requestWithPath:NEW_QA_STAR method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"已点赞");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
    }];
}

@end
