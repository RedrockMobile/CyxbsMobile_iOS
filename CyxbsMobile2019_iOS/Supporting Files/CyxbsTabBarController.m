//
//  CyxbsTabBarController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "CyxbsTabBarController.h"

#import "SchedulePresenter.h"

@interface CyxbsTabBarController ()

@end

@implementation CyxbsTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllers = @[
        self._vc1
    ];
}

- (UIViewController *)_vc1 {
    UIViewController *vc = [[ScheduleController alloc] initWithPresenter:[[SchedulePresenter alloc] init]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBarHidden = YES;
    return nav;
}

@end
