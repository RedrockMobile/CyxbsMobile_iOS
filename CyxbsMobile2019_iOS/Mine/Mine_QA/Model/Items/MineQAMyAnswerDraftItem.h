//
//  MineQAMyAnswerDraftItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 "data": [
     {
         "draft_answer_id": 26,
         "question_id": 0,
         "latest_edit_time": "2020-02-15 21:02:50",
         "draft_answer_content": "test"
     }
 ]
 */

NS_ASSUME_NONNULL_BEGIN

@interface MineQAMyAnswerDraftItem : NSObject

@property (nonatomic, copy) NSString *answerDraftID;
@property (nonatomic, copy) NSString *questionID;
@property (nonatomic, copy) NSString *lastEditTime;
@property (nonatomic, copy) NSString *answerDraftContent;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
