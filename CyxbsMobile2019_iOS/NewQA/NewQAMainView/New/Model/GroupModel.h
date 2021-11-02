//
//  GroupModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^Netblock)(id info);

@interface GroupModel : NSObject <NSCoding>

@property (nonatomic, copy) Netblock Block;

@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)loadMyFollowGroup;

@end

NS_ASSUME_NONNULL_END
