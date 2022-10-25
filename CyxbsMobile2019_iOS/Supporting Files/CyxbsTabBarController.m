//
//  CyxbsTabBarController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "CyxbsTabBarController.h"

#import "SchedulePresenter.h"

#import "FastLoginViewController.h"

@interface CyxbsTabBarController ()

@end

@implementation CyxbsTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _tabBar];
    self.viewControllers = @[
        self._vc1,
    ];
}

#pragma mark - Method

- (void)_test1 {
    FastLoginViewController *vc = [[FastLoginViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - private

- (void)_tabBar {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:effect];
    view.frame = self.view.SuperFrame;
    [self.tabBar addSubview:view];
}

- (UIViewController *)_vc1 {
    SchedulePresenter *presenter = [[SchedulePresenter alloc] init];
//    presenter.delegateService.parameterIfNeeded = @{
//        ScheduleModelRequestStudent : @[@"2021215154"]
//    };
    ScheduleController *vc = [[ScheduleController alloc] initWithPresenter:presenter];
    vc.isPushStyle = YES;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBarHidden = YES;
    return nav;
}

@end
