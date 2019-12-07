//
//  WYCClassAndRemindDataModel.h
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2019/3/8.
//  Copyright © 2019年 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#define URL @"https://cyxbsmobile.redrock.team/api/kebiao"

@interface WYCClassAndRemindDataModel : NSObject

@property (nonatomic, strong) NSMutableArray *weekArray;
@property (nonatomic, strong) NSMutableArray *remindArray;

- (void)getClassBookArray:(NSString *)stu_Num;
- (void)getClassBookArrayFromNet:(NSString *)stu_Num;


- (void)getRemind:(NSString *)stuNum idNum:(NSString *)idNum;
- (void)getRemindFromNet:(NSString *)stuNum idNum:(NSString *)idNum;
- (void)deleteRemind:(NSString *)stuNum idNum:(NSString *)idNum remindId:(NSNumber *)remindId;

@end
