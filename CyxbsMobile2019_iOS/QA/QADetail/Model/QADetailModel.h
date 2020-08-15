//
//  QADetailModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/21.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QADetailModel : NSObject

///回答的数据
@property(strong,nonatomic)NSArray *answersData;
///问题详情
@property(strong,nonatomic)NSDictionary *detailData;

- (void)getDataWithId:(NSNumber *)questionId;
- (void)replyComment:(nonnull NSNumber *)answerId content:(NSString *)content;

- (void)getCommentData:(nonnull NSNumber *)answerId;
- (void)adoptAnswer:(NSNumber *)questionId answerId:(NSNumber *)answerId;
- (void)praise:(nonnull NSNumber *)answerId;
- (void)cancelPraise:(nonnull NSNumber *)answerId;

- (void)report:(NSString *)type question_id:(NSNumber *)question_id;
- (void)ignore:(NSNumber *)question_id;
//参数：questionId：问题id，page：请求的页
- (void)getAnswersWithId:(NSNumber *)questionId AndPage:(NSNumber*)page;
@end

NS_ASSUME_NONNULL_END
