//
//  FirstViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - DiscoverViewController

@interface DiscoverViewController: UIViewController <
    RisingRouterHandler
>

- (void)reloadViewController:(UIViewController *)viewController;

@end

