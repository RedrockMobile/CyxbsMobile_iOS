//
//  EmptyClassModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/15.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmptyClassModel : NSObject
@property int nowWeek;//当前周数
@property int status;//状态吗
@property (nonatomic, copy) NSString *info;//success表示成功
@property (nonatomic, copy) NSArray *emptyClassArray;//空教室数组
- (instancetype) initWithDict: (NSDictionary *)dict;
+ (instancetype) modelWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
