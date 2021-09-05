//
//  FeedBackDetailsRequestDataModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackDetailsRequestDataModel.h"
// network
#import "HttpClient.h"

@implementation FeedBackDetailsRequestDataModel

+ (void)getDataAryWithFeedBackID:(long)feedback_id
                         Success:(void (^)(NSArray * _Nonnull))success
                         failure:(void (^)(void))failure {
//    // 模拟从网络上获取数据
//    NSMutableArray * mAry = [NSMutableArray array];
//
//    FeedBackDetailsModel * detailsModel = [[FeedBackDetailsModel alloc] init];
//    detailsModel.content = @"今天喝了脉动呐，吃了果冻呐，打了电动呐，还是挡不住对你的心动呐~";
//    detailsModel.CreatedAt = @"";
//    detailsModel.title = @"参与买一送一的活动";
//    detailsModel.type = @"账号问题";
//    detailsModel.pictures = [NSArray array];
//    [mAry addObject:detailsModel];
//
//    FeedBackReplyModel * replyModel = [[FeedBackReplyModel alloc] init];
//    replyModel.content = @"你的问题我们已收到，感谢同学你的反馈。";
//    replyModel.CreatedAt = @"";
//    replyModel.urls = [NSArray array];
//    [mAry addObject:replyModel];
//    success([mAry copy]);
    
    HttpClient *client = [HttpClient defaultClient];
    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",FEED_BACK_TOKEN]  forHTTPHeaderField:@"authorization"];
    [client.httpSessionManager GET:FeedBack_Center_History_View
                        parameters:@{
                            @"feedback_id" : @(feedback_id),
                            @"product_id" : @1
                        }
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSMutableArray * mAry = [NSMutableArray array];

        //
        NSDictionary * feedback = responseObject[@"data"][@"feedback"];
        FeedBackDetailsModel * model = [FeedBackDetailsModel mj_objectWithKeyValues:feedback];
        [mAry addObject:model];

        //
        NSDictionary * reply = responseObject[@"data"][@"reply"];
        FeedBackReplyModel * replyModel = [FeedBackReplyModel mj_objectWithKeyValues:reply];
        if (replyModel && replyModel.ID != 0) {
            [mAry addObject: replyModel];
        }

        success([mAry copy]);
    }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure();
    }];
     

//    [[HttpClient defaultClient] requestWithPath:FeedBack_Center_History_View
//                                         method:HttpRequestGet
//                                     parameters:@{
//                                         @"feedback_id" : @(feedback_id),
//                                         @"product_id" : @1
//                                     }
//                                 prepareExecute:nil
//                                       progress:nil
//                                        success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSMutableArray * mAry = [NSMutableArray array];
//
//        //
//        NSDictionary * feedback = responseObject[@"data"][@"feedback"];
//        FeedBackDetailsModel * model = [FeedBackDetailsModel mj_objectWithKeyValues:feedback];
//        [mAry addObject:model];
//
//        //
//        NSArray * reply = responseObject[@"data"][@"reply"];
//        NSMutableArray * replies = [NSMutableArray array];
//        for (NSDictionary * dict in reply) {
//            FeedBackReplyModel * replyModel = [FeedBackReplyModel mj_objectWithKeyValues:dict];
//            [replies addObject: replyModel];
//        }
//        [mAry addObject:replies.copy];
//
//        success([mAry copy]);
//    }
//                                        failure:^(NSURLSessionDataTask *task, NSError *error) {
//        failure();
//    }];
}

@end
