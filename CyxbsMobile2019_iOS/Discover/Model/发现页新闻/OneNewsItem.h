//
//  OneNewsItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2019/11/10.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OneNewsItem : NSObject
@property(nonatomic, copy)NSString *oneNews;
-(instancetype)initWithDict: (NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
