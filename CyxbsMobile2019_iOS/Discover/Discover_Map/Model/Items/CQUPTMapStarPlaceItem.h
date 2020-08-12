//
//  CQUPTMapStarPlaceItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/12.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQUPTMapStarPlaceItem : NSObject

@property (nonatomic, copy) NSString *placeNickname;
@property (nonatomic, copy) NSString *placeId;

- (instancetype)initWithDice:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
