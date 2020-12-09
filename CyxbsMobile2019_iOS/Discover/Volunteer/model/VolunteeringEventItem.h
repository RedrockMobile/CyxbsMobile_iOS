//
//  QueryModel.h
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 07/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>

// 志愿信息
@interface VolunteeringEventItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString *creatTime;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *addWay;
@property (nonatomic, strong) NSString *server_group;
@property (nonatomic, strong) NSString *orgId;



- (instancetype)initWithDictinary: (NSDictionary *)dict;

@end
