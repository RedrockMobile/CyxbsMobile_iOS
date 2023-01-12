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

#import "ScheduleWidgetCache.h"

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
    
    ScheduleIdentifier *mainID = ScheduleWidgetCache.shareCache.mainID;
    if (mainID.sno && ![mainID.sno isEqualToString:@""]) {
        if (ScheduleWidgetCache.shareCache.beDouble) {
            ScheduleIdentifier *otherID = ScheduleWidgetCache.shareCache.otherID;
            [presenter setWithMainIdentifier:mainID otherIdentifier:otherID];
        } else {
            [presenter setWithOnlyMainIdentifier:mainID];
        }
    }
    
    ScheduleController *vc = [[ScheduleController alloc] initWithPresenter:presenter];
    vc.isPushStyle = YES;
    self.schedulePresenter = presenter;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBarHidden = YES;
    return nav;
}

@end
