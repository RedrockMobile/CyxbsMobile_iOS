//
//  MineQAModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/15.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineQAModel : NSObject

- (void)requestQuestionListWithPageNum:(NSNumber *)pageNum
                           andPageSize:(NSNumber *)size
                             succeeded:(void (^)(NSDictionary *responseObject))succeeded
                                failed:(void (^)(NSError *error))failed;

- (void)requestQuestionDraftListWithPageNum:(NSNumber *)pageNum
                                andPageSize:(NSNumber *)size
                                  succeeded:(void (^)(NSDictionary *responseObject))succeeded
                                     failed:(void (^)(NSError *error))failed;

- (void)requestAnswerListWithPageNum:(NSNumber *)pageNum
                         andPageSize:(NSNumber *)size
                           succeeded:(void (^)(NSDictionary *responseObject))succeeded
                              failed:(void (^)(NSError *error))failed;

- (void)requestAnswerDraftListWithPageNum:(NSNumber *)pageNum
                              andPageSize:(NSNumber *)size
                                succeeded:(void (^)(NSDictionary *responseObject))succeeded
                                   failed:(void (^)(NSError *error))failed;

- (void)requestCommentListWithPageNum:(NSNumber *)pageNum
                          andPageSize:(NSNumber *)size
                            succeeded:(void (^)(NSDictionary *responseObject))succeeded
                               failed:(void (^)(NSError *error))failed;

- (void)requestReCommentListWithPageNum:(NSNumber *)pageNum
                            andPageSize:(NSNumber *)size
                              succeeded:(void (^)(NSDictionary *responseObject))succeeded
                                 failed:(void (^)(NSError *error))failed;

- (void)deleteDraftWithDraftID:(NSString *)draftID
                     succeeded:(void (^)(void))succeeded
                        failed:(void (^)(NSError *error))failed;

@end

NS_ASSUME_NONNULL_END
