//
//  QueryModel.h
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 07/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>

// 志愿信息
@interface VolunteeringEventItem : NSObject

@property (nonatomic, copy)NSString *hour;
@property (nonatomic, copy)NSString *creatTime;
@property (nonatomic, copy)NSString *eventName;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *orgName;   // 组织名称

- (instancetype)initWithDictinary: (NSDictionary *)dict;

@end
