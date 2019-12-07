//
//  RemindMatter.h
//  Demo
//
//  Created by 李展 on 2016/11/17.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RemindMatter : NSObject
@property (nonatomic, strong) NSNumber *idNum;
@property (nonatomic, strong) NSNumber *day;
@property (nonatomic, strong) NSNumber *classNum;
@property (nonatomic, copy) NSArray *week;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
- (instancetype)initWithRemind:(NSDictionary *)remind;
@end
