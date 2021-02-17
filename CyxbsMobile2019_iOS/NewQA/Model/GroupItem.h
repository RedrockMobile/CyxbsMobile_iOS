//
//  GroupItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupItem : NSObject <NSCoding>

@property(nonatomic, strong) NSNumber *topic_id;

@property(nonatomic, strong) NSString *topic_logo;

@property(nonatomic, strong) NSString *topic_name;

@property(nonatomic, strong) NSNumber *message_count;

@property(nonatomic, strong) NSNumber *is_follow;

@property(nonatomic, strong) NSString *introduction;

- (instancetype)initWithDic:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
