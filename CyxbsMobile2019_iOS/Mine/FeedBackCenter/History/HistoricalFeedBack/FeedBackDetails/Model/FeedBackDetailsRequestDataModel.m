//
//  FeedBackDetailsRequestDataModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackDetailsRequestDataModel.h"

@implementation FeedBackDetailsRequestDataModel

+ (void)getDataArySuccess:(void (^)(NSArray * _Nonnull))success failure:(void (^)(void))failure {
    // 模拟从网络上获取数据
    NSMutableArray * mAry = [NSMutableArray array];
    
    FeedBackDetailsModel * detailsModel = [[FeedBackDetailsModel alloc] init];
    detailsModel.contentText = @"今天喝了脉动呐，吃了果冻呐，打了电动呐，还是挡不住对你的心动呐~";
    detailsModel.date = 1628845560;
    detailsModel.title = @"参与买一送一的活动";
    detailsModel.type = @"账号问题";
    detailsModel.imgCount = 2;
    [mAry addObject:detailsModel];
    
    FeedBackReplyModel * replyModel = [[FeedBackReplyModel alloc] init];
    replyModel.contentText = @"你的问题我们已收到，感谢同学你的反馈。";
    replyModel.date = 1628845560;
    replyModel.imgCount = 1;
    [mAry addObject:replyModel];
    success([mAry copy]);
}

@end
