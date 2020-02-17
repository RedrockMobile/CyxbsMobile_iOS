//
//  MineQAMyAnswerItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineQAMyAnswerItem : NSObject

@property (nonatomic, copy) NSString *questionID;
@property (nonatomic, copy) NSString *integral;
@property (nonatomic, copy) NSString *answerID;
@property (nonatomic, copy) NSString *answerContent;
@property (nonatomic, copy) NSString *answerTime;
@property (nonatomic, copy) NSString *type;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
