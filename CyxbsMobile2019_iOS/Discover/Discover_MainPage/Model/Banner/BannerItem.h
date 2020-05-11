//
//  BannerItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerItem : NSObject
@property (nonatomic, copy)NSString *picureID;
@property (nonatomic, copy)NSString *pictureUrl;
@property (nonatomic, copy)NSString *pictureGoToUrl;
@property (nonatomic, copy)NSString *keyword;
- (instancetype) initWithdictionary: (NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
