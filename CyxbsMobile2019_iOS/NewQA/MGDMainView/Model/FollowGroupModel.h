//
//  FollowGroupModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Netblock)(id info);

@interface FollowGroupModel : NSObject

@property (nonatomic, copy) Netblock Block;

- (void)FollowGroupWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
