//
//  SearchPerson.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchPerson : NSObject

/// 学号
@property (nonatomic, copy) NSString *stunum;

/// 名字
@property (nonatomic, copy) NSString *name;

/// 性别
@property (nonatomic, copy) NSString *gender;

/// 班级
@property (nonatomic, copy) NSString *classnum;

/// 专业
@property (nonatomic, copy) NSString *major;

/// 年级
@property (nonatomic, copy) NSString *grade;

#pragma mark - Method

/// 根据字典来赋值
/// @param dic 字典（这里必须看文档，注意使用）
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
