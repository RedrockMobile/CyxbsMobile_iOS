//
//  DateModle.h
//  ChatBotTest
//
//  Created by 王一成 on 2018/8/30.
//  Copyright © 2018年 wyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateModle : NSObject
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSNumber *nowWeek;
+(instancetype)initWithStartDate:(NSString *)startDate;

@end
