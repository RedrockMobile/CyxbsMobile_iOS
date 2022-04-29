//
//  DiscoverMineMessageVC.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/17.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MineMessageViewController

/// mine message that show outside in, use init
@interface DiscoverMineMessageVC : UIViewController

/// default is NO, and without red boll
@property (nonatomic) BOOL hadRead;

/// if userdefault don't need show boll, maybe use this
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
