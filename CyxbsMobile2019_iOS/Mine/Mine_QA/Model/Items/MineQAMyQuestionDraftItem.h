//
//  MineQAMyQuestionDraftItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineQAMyQuestionDraftItem : NSObject

@property (nonatomic, copy) NSString *questionDraftID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *questionDraftContent;
@property (nonatomic, copy) NSString *lastEditTime;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
