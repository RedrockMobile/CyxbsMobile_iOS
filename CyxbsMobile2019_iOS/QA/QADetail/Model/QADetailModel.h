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

@property(strong,nonatomic)NSArray *answersData;
@property(strong,nonatomic)NSDictionary *detailData;

- (void)getDataWithId:(NSNumber *)questionId;
- (void)replyComment:(nonnull NSNumber *)answerId content:(NSString *)content;

- (void)getCommentData:(nonnull NSNumber *)answerId;
- (void)adoptAnswer:(NSNumber *)questionId answerId:(NSNumber *)answerId;
- (void)praise:(nonnull NSNumber *)answerId;
- (void)cancelPraise:(nonnull NSNumber *)answerId;
@end

NS_ASSUME_NONNULL_END
