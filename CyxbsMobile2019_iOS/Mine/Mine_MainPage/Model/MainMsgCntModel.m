//
//  MainMsgCntModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/4.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MainMsgCntModel.h"


typedef enum : NSUInteger {
    MainMsgCntModelRequestTypePraise,
    MainMsgCntModelRequestTypeComment,
} MainMsgCntModelRequestType;

@implementation MainMsgCntModel
- (void)mainMsgCntModelLoadMoreData {
    [[HttpClient defaultClient] requestWithPath:getUserCount method:HttpRequestGet parameters:@{} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dataDict = responseObject[@"data"];
        if (dataDict==nil) {
            [self.delegate mainMsgCntModelLoadDataFinishWithState:(MainMsgCntModelLoadDataStateFailure_userCnt)];
            return;
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setValue:[NSString stringWithFormat:@"%@",dataDict[@"comment"]] forKey:MineCommentCntStrKey];
        [defaults setValue:[NSString stringWithFormat:@"%@",dataDict[@"dynamic"]] forKey:MineDynamicCntStrKey];
         [defaults setValue:[NSString stringWithFormat:@"%@",dataDict[@"praise"]] forKey:MinePraiseCntStrKey];
        [defaults synchronize];
        
        [self.delegate mainMsgCntModelLoadDataFinishWithState:(MainMsgCntModelLoadDataStateSuccess_userCnt)];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate mainMsgCntModelLoadDataFinishWithState:(MainMsgCntModelLoadDataStateFailure_userCnt)];
    }];
    [self loadUncheckMsgWithType:MainMsgCntModelRequestTypePraise];
    [self loadUncheckMsgWithType:MainMsgCntModelRequestTypeComment];
}

- (void)loadUncheckMsgWithType:(MainMsgCntModelRequestType)type {
    NSDictionary *paramDict;
    MainMsgCntModelLoadDataState stateSuccess,stateFailure;
    NSString *time;
    if (type==MainMsgCntModelRequestTypePraise) {
        stateSuccess = MainMsgCntModelLoadDataStateSuccess_praise;
        stateFailure = MainMsgCntModelLoadDataStateFailure_praise;
        time = [[NSUserDefaults standardUserDefaults] stringForKey:praiseLastClickTimeKey];
        if (time==nil) {
            time = [self getTime7DayAgo];
        }
        paramDict = @{
            @"time":time,
            @"type":@"2",
        };
    } else {
        stateSuccess = MainMsgCntModelLoadDataStateSuccess_comment;
        stateFailure = MainMsgCntModelLoadDataStateFailure_comment;
        time = [[NSUserDefaults standardUserDefaults] stringForKey:remarkLastClickTimeKey];
        if (time==nil) {
            time = [self getTime7DayAgo];
        }
        paramDict = @{
            @"time":time,
            @"type":@"1",
        };
    }
    
    [[HttpClient defaultClient] requestWithPath:getMsgCnt method:HttpRequestGet parameters:paramDict prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dataDict = responseObject[@"data"];
        if (dataDict==nil) {
            [self.delegate mainMsgCntModelLoadDataFinishWithState:stateFailure];
            return;
        }
        
        if (type==MainMsgCntModelRequestTypePraise) {
            self.uncheckedPraiseCnt = dataDict[@"uncheckedPraise"];
        }else {
            self.uncheckedCommentCnt = dataDict[@"uncheckedComment"];
        }
        
//        CCLog(@"MainMsg:%@,%@",self.uncheckedPraiseCnt,self.uncheckedCommentCnt);
//        CCLog(@"MainMsgres%@",responseObject);
        [self.delegate mainMsgCntModelLoadDataFinishWithState:stateSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate mainMsgCntModelLoadDataFinishWithState:stateFailure];
    }];
}

/// 获取一天前的时间戳
- (NSString*)getTime7DayAgo {
    //86400正好是一天的秒数
    return [NSString stringWithFormat:@"%.0f", [NSDate.now timeIntervalSince1970]-86400];
}

- (void)setUncheckedCommentCnt:(NSString *)uncheckedCommentCnt {
    _uncheckedCommentCnt = [NSString stringWithFormat:@"%@",uncheckedCommentCnt];
}

- (void)setUncheckedPraiseCnt:(NSString *)uncheckedPraiseCnt {
    _uncheckedPraiseCnt = [NSString stringWithFormat:@"%@",uncheckedPraiseCnt];
}

//- (void)setCommentCnt:(NSString *)commentCnt {
//    _commentCnt = [NSString stringWithFormat:@"%@",commentCnt];
//}
//
//- (void)setDynamicCnt:(NSString *)dynamicCnt {
//    _dynamicCnt = [NSString stringWithFormat:@"%@",dynamicCnt];
//}
//
//- (void)setPraiseCnt:(NSString *)praiseCnt {
//    _praiseCnt = [NSString stringWithFormat:@"%@",praiseCnt];
//}
@end
