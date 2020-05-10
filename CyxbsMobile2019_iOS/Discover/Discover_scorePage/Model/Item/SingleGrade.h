//
//  SingleGrade.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SingleGrade : NSObject

@property (nonatomic, copy)NSString *class_num;
@property (nonatomic, copy)NSString *class_name;
@property (nonatomic, copy)NSString *class_type;
@property (nonatomic, copy)NSString *credit;
@property (nonatomic, copy)NSString *exam_type;
@property (nonatomic, copy)NSString *grade;
@property (nonatomic, copy)NSString *gpa;



- (instancetype)initWithDictionary: (NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END
