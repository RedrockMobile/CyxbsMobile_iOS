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
//    HttpClient *client = [HttpClient defaultClient];
//    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",FEED_BACK_TOKEN]  forHTTPHeaderField:@"authorization"];
//    [client.httpSessionManager GET:FeedBack_Center_History_List
//                        parameters:nil
//                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSArray * feedbacks = responseObject[@"data"][@"feedbacks"];
//        NSMutableArray * mAry = [NSMutableArray array];
//        for (NSDictionary * feedback in feedbacks) {
//            FeedBackModel * model = [FeedBackModel mj_objectWithKeyValues:feedback];
//            [mAry addObject:model];
//            if (model.replied &&
//                ![[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"feedback_history_%zd", model.ID]]) {
//                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"feedback_history_%zd", model.ID]];
//            }
//        }
//        success([mAry copy]);
//    }
//                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure();
//    }];
     
     
     
    [[HttpClient defaultClient] requestWithPath:FeedBack_Center_History_List
                                         method:HttpRequestGet
                                     parameters:@{@"product_id" : @1}
                                 prepareExecute:nil
                                       progress:nil
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * feedbacks = responseObject[@"data"][@"feedbacks"];
        NSMutableArray * mAry = [NSMutableArray array];
        for (NSDictionary * feedback in feedbacks) {
            FeedBackModel * model = [FeedBackModel mj_objectWithKeyValues:feedback];
            [mAry addObject:model];
            if (model.replied &&
                ![[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"feedback_history_%zd", model.ID]]) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"feedback_history_%zd", model.ID]];
            }
        }
        success([mAry copy]);
    }
                                        failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure();
    }];
}

@end
