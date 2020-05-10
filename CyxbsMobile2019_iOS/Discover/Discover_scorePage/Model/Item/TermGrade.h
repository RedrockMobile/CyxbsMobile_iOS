//
//  TermGrade.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleGrade.h"

NS_ASSUME_NONNULL_BEGIN

@interface TermGrade : NSObject

@property (nonatomic, copy)NSString *term;
@property (nonatomic, copy)NSString *gpa;
@property (nonatomic, copy)NSString *grade;
@property (nonatomic, copy)NSString *rank;
@property (nonatomic) NSArray<SingleGrade*> *singegradesArr;
- (instancetype)initWithDictionary: (NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
