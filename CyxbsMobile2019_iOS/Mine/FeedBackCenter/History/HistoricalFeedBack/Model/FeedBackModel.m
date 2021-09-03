//
//  FeedBackModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackModel.h"
// network
#import "HttpClient.h"

@implementation FeedBackModel

+ (void)getDataArySuccess:(void (^)(NSArray * _Nonnull))success
                  failure:(void (^)(void))failure {
    [[HttpClient defaultClient] requestWithPath:FeedBack_Center_History_List
                                         method:HttpRequestGet
                                     parameters:@{@"product_id" : @1}
                                 prepareExecute:nil
                                       progress:nil
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * feedbacks = responseObject[@"data"][@"feedbacks"];
        NSMutableArray * mAry = [NSMutableArray array];
        for (NSDictionary * feedback in feedbacks) {
            FeedBackModel * model = [FeedBackModel mj_objectWithKeyValues:feedback];
            [mAry addObject:model];
        }
        success([mAry copy]);
    }
                                        failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure();
    }];
}

@end
