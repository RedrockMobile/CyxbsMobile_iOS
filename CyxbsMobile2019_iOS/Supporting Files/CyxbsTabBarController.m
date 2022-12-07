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

#import "UserAgreementViewController.h"

@interface CyxbsTabBarController () 

/// <#description#>
@property (nonatomic, strong) SchedulePresenter *schedulePresenter;

@end

@implementation CyxbsTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _tabBar];
    self.viewControllers = @[
        self._vc1,
        self._test1
    ];
    
    BOOL hadReadAgreement = [NSUserDefaults.standardUserDefaults boolForKey:UDKey.hadReadAgreement];
    if (!hadReadAgreement) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController *vc = [[UserAgreementViewController alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:vc animated:YES completion:nil];
        });
        self.selectedIndex = 1;
    }
}

#pragma mark - Method

- (UIViewController *)_test1 {
    FastLoginViewController *vc = [[FastLoginViewController alloc] init];
    vc.presenter = self.schedulePresenter;
    return vc;
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
    presenter.useAwake = [NSUserDefaults.standardUserDefaults boolForKey:UDKey.isXXHB];
    NSString *sno = [NSUserDefaults.standardUserDefaults valueForKey:UDKey.sno];
    if (sno && ![sno isEqualToString:@""]) {
        presenter.nextRequestDic = @{
            ScheduleModelRequestStudent : @[sno]
        };
    }
    
//    /// @warning 注意
//    presenter.nextRequestDic = @{
//        ScheduleModelRequestStudent : @[
//            @"2021215154",
//            @"2021214411"
//        ]
//    };
//    presenter.model.sno = @"2021214411";
    
    ScheduleController *vc = [[ScheduleController alloc] initWithPresenter:presenter];
    vc.isPushStyle = YES;
    self.schedulePresenter = presenter;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBarHidden = YES;
    return nav;
}

@end
