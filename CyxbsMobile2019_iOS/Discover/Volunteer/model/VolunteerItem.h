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
@property (nonatomic, copy)NSString *hour;
@property (nonatomic, strong)NSArray<VolunteeringEventItem *> *eventsArray;
@property (nonatomic, strong)NSArray<VolunteeringEventItem *> *eventsSortedByYears;


- (void)getVolunteerInfoWithUserName: (NSString *)userName andPassWord: (NSString *)passWord finishBlock:(void (^)(VolunteerItem *volunteer))finish;

-(NSString *)aesEncrypt:(NSString *)plainText;

- (void)sortEvents;

/// 获取缓存路径
+ (NSString *)archivePath;

/// 归档对象
- (void)archiveItem;


@end
