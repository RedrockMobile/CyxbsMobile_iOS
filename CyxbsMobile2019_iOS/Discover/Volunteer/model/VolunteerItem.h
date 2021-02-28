//
//  QueryDataModel.h
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 12/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VolunteeringEventItem.h"

// 志愿者信息
@interface VolunteerItem : NSObject <NSCoding>

@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *sid;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, copy) NSString *hour;
@property (nonatomic, strong)NSArray<VolunteeringEventItem *> *eventsArray;
@property (nonatomic, strong) NSArray<NSMutableArray<VolunteeringEventItem *> *> *eventsSortedByYears;


- (void)getVolunteerInfoWithUserName: (NSString *)userName andPassWord: (NSString *)passWord finishBlock:(void (^)(VolunteerItem *volunteer))finish;

-(NSString *)aesEncrypt:(NSString *)plainText;

- (void)sortEvents;


@end
