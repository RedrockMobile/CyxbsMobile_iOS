//
//  OneNewsItemData.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OneNewsItemData : NSObject
@property (nonatomic, copy)NSString *NewsID;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *readCount;
- (instancetype) initWithDict: (NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
