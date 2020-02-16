//
//  MineQAMyQuestionItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineQAMyQuestionItem : NSObject

@property (nonatomic, copy) NSString *questionID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *questionContent;
@property (nonatomic, copy) NSString *integral;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *disappearTime;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
