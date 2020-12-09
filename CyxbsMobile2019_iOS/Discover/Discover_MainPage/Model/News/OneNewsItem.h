//
//  OneNewsItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2019/11/10.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneNewsItemData.h"
NS_ASSUME_NONNULL_BEGIN

@interface OneNewsItem : NSObject
@property (nonatomic, strong)NSNumber *page;
@property (nonatomic, strong)NSNumber *status;
@property (nonatomic, copy)NSString *success;
@property (nonatomic, copy)NSString *info;
@property (nonatomic, strong)NSArray<OneNewsItemData*> *dataArray;
-(instancetype)initWithDict: (NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
