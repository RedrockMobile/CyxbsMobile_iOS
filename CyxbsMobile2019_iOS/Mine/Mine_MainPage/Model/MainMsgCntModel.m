//
//  MainMsgCntModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/4.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MainMsgCntModel.h"
//动态/点赞/获赞评论数
#define CJHgetUserCount @"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/user/getUserCount"
//未读消息数
#define CJHgetMsgCnt @"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/user/uncheckedMessage"


@implementation MainMsgCntModel
- (void)loadData {
    dispatch_queue_t que = dispatch_queue_create("MainMsgCntModelQue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(que, ^{
            [[HttpClient defaultClient] requestWithPath:CJHgetUserCount method:HttpRequestGet parameters:@{} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSDictionary *dataDict = responseObject[@"data"];
                if (dataDict==nil) {
                    [self.delegate loadUserCountDataFailure];
                    return;
                }
                self.commentCnt = dataDict[@"comment"];
                self.dynamicCnt = dataDict[@"dynamic"];
                self.praiseCnt = dataDict[@"praise"];
                [self.delegate loadUserCountDataSuccess];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self.delegate loadUserCountDataFailure];
            }];
        });
        
        dispatch_async(que, ^{
            [[HttpClient defaultClient] requestWithPath:CJHgetMsgCnt method:HttpRequestGet parameters:@{@"time":[self getTime]} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSDictionary *dataDict = responseObject[@"data"];
                if (dataDict==nil) {
                    [self.delegate loadUncheckedDataFailure];
                    return;
                }
                self.uncheckedPraiseCnt = dataDict[@"uncheckedPraise"];
                self.uncheckedCommentCnt = dataDict[@"uncheckedComment"];
                [self.delegate loadUncheckedDataSuccess];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self.delegate loadUncheckedDataFailure];
            }];
        });
}

- (NSString*)getTime {
    return [NSString stringWithFormat:@"%.0f", [NSDate.now timeIntervalSince1970]];
}

- (void)setUncheckedCommentCnt:(NSString *)uncheckedCommentCnt {
    _uncheckedCommentCnt = [NSString stringWithFormat:@"%@",uncheckedCommentCnt];
}

- (void)setUncheckedPraiseCnt:(NSString *)uncheckedPraiseCnt {
    _uncheckedPraiseCnt = [NSString stringWithFormat:@"%@",uncheckedPraiseCnt];
}

- (void)setCommentCnt:(NSString *)commentCnt {
    _commentCnt = [NSString stringWithFormat:@"%@",commentCnt];
}

- (void)setDynamicCnt:(NSString *)dynamicCnt {
    _dynamicCnt = [NSString stringWithFormat:@"%@",dynamicCnt];
}

- (void)setPraiseCnt:(NSString *)praiseCnt {
    _praiseCnt = [NSString stringWithFormat:@"%@",praiseCnt];
}
@end
