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

#import "ScheduleBar.h"



#import "TransitioningDelegate.h"

@interface CyxbsTabBarController ()

@property (nonatomic, strong) ScheduleBar *scheduleBar;

/// <#description#>
@property (nonatomic, strong) SchedulePresenter *schedulePresenter;

@end

@implementation CyxbsTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.schedulePresenter = [[SchedulePresenter alloc] init];
    self.viewControllers = @[
        self._test1
    ];
    
    BOOL hadReadAgreement = [NSUserDefaults.standardUserDefaults boolForKey:UDKey.hadReadAgreement];
    if (!hadReadAgreement) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.53 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController *vc = [[UserAgreementViewController alloc] init];
                vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [self presentViewController:vc animated:YES completion:nil];
                self.selectedIndex = 1;
        });
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self _drawTabBarEffect];
    
    [self.view addSubview:self.scheduleBar];
    [self _drawScheduleBar];
}

- (ScheduleBar *)scheduleBar {
    if (_scheduleBar == nil) {
        CGFloat height = 58;
        CGRect frame = CGRectMake(0, self.view.height - self.tabBar.height - height, self.view.width, height);
        _scheduleBar = [[ScheduleBar alloc] initWithFrame:frame];
        _scheduleBar.backgroundColor = [UIColor Light:UIColorHex(#FFFFFF) Dark:UIColorHex(#2D2D2D)];
        _scheduleBar.title = @"你是故意找茬是不是";
        _scheduleBar.time = @"8:00 - 9:40";
        _scheduleBar.place = @"2103";
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan:)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tap:)];
        [_scheduleBar addGestureRecognizer:pan];
        [_scheduleBar addGestureRecognizer:tap];
    }
    return _scheduleBar;
}

- (void)_drawTabBarEffect {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:effect];
    view.frame = self.tabBar.SuperFrame;
    [self.tabBar insertSubview:view atIndex:1];
}

- (void)_drawScheduleBar {
    if (_scheduleBar) {
        UIView *view = [[UIView alloc] initWithFrame:self.scheduleBar.SuperFrame];
        view.backgroundColor = self.scheduleBar.backgroundColor;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.frame = view.bounds;
        shapeLayer.path = bezierPath.CGPath;
        view.layer.mask = shapeLayer;
        
        self.scheduleBar.backgroundColor = UIColor.clearColor;
        self.scheduleBar.layer.shadowColor = [UIColor Light:UIColor.lightGrayColor Dark:UIColor.darkGrayColor].CGColor;
        self.scheduleBar.layer.shadowOpacity = 0.6;
        self.scheduleBar.layer.shadowPath = shapeLayer.path;
        self.scheduleBar.layer.shadowOffset = CGSizeMake(0, -3);
        
        [self.scheduleBar insertSubview:view atIndex:0];
    }
}




- (UIViewController *)_svc {
    ScheduleIdentifier *mainID = ScheduleWidgetCache.shareCache.mainID;
    [self.schedulePresenter setWithOnlyMainIdentifier:mainID];
    ScheduleController *vc = [[ScheduleController alloc] initWithPresenter:self.schedulePresenter];
    
    return vc;
}

- (TransitioningDelegate *)_delegate {
    TransitioningDelegate *delegate = [[TransitioningDelegate alloc] init];
    delegate.transitionDurationIfNeeded = 0.3;
    delegate.panInsetsIfNeeded = UIEdgeInsetsMake(StatusBarHeight(), 0, self.tabBar.height, 0);
    delegate.supportedTapOutsideBackWhenPresent = NO;
    return delegate;
}

- (void)_tap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        UIViewController *vc = self._svc;
        TransitioningDelegate *delegate = self._delegate;
        
        vc.transitioningDelegate = delegate;
        vc.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:^{
                    
        }];
    }
}

- (void)_pan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        UIViewController *vc = self._svc;
        TransitioningDelegate *delegate = self._delegate;
        delegate.panGestureIfNeeded = pan;
        
        vc.transitioningDelegate = delegate;
        vc.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:^{
                    
        }];
    }
}






















#pragma mark - Method

- (UIViewController *)_test1 {
    FastLoginViewController *vc = [[FastLoginViewController alloc] init];
    vc.presenter = self.schedulePresenter;
    return [[UINavigationController alloc] initWithRootViewController:vc];
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
    self.schedulePresenter = presenter;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBarHidden = YES;
    return nav;
}

@end
