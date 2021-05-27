//
//  ActivityItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/28.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityItem : NSObject

@property (nonatomic, strong) NSString *idNum;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descript;
@property (nonatomic, strong) NSString *sign_up_start;
@property (nonatomic, strong) NSString *sign_up_last;
@property (nonatomic, strong) NSString *last_date;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *place;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
