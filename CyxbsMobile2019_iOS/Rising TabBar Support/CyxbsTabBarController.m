//
//  CyxbsTabBarController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "CyxbsTabBarController.h"

#import "FastLoginViewController.h"
#import "UserAgreementViewController.h"

#import "SchedulePresenter.h"
#import "ScheduleWidgetCache.h"
#import "SchedulePolicyService.h"
#import "ScheduleTouchItem.h"

#import "ScheduleBar.h"
#import "ScheduleController.h"
#import "TransitioningDelegate.h"

@interface CyxbsTabBarController () <FastLoginViewControllerDelegate>

@property (nonatomic, strong) ScheduleBar *scheduleBar;

/// <#description#>
@property (nonatomic, strong) SchedulePresenter *schedulePresenter;

@end

@implementation CyxbsTabBarController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.schedulePresenter = [[SchedulePresenter alloc] init];
    
    self.viewControllers = @[
        self._test1
    ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ScheduleIdentifier *mainKey = [ScheduleWidgetCache.shareCache getKeyWithKeyName:ScheduleWidgetCacheKeyMain usingSupport:YES];
    if (mainKey) {
        SchedulePolicyService *policy = [[SchedulePolicyService alloc] init];
        policy.outRequestTime = 45 * 60 * 60;
        [policy requestDic:@{
            ScheduleModelRequestStudent : @[mainKey.sno],
            ScheduleModelRequestCustom : @[mainKey.sno]
        } policy:^(ScheduleCombineItem * _Nonnull item) {
            ScheduleTouchItem *touch = [[ScheduleTouchItem alloc] init];
            touch.combining = item;
            ScheduleCourse *now = touch.floorCourse;
            if (now) {
                self.scheduleBar.title = now.course;
                self.scheduleBar.place = now.classRoom;
                self.scheduleBar.time = now.timeStr;
            } else {
                self.scheduleBar.title = @"没课了";
                self.scheduleBar.place = @"好好休息吧";
                self.scheduleBar.time = @"明天再说";
            }
        } unPolicy:^(ScheduleIdentifier * _Nonnull unpolicyKEY) {
            self.scheduleBar.title = @"网络请求失败";
            self.scheduleBar.place = @"请检查网络";
            self.scheduleBar.time = @"退出重试";
        }];
        [self.schedulePresenter setWithMainKey:mainKey];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    static BOOL _draw = NO;
    if (!_draw) {
        _draw = YES;
        [self _drawTabBarEffect];
        
        [self.view addSubview:self.scheduleBar];
        [self _drawScheduleBar];
        
        BOOL hadReadAgreement = [NSUserDefaults.standardUserDefaults boolForKey:UDKey.hadReadAgreement];
        if (!hadReadAgreement) {
            // 用户协议以及登录请在这里进行改变
            UIViewController *vc = [[UserAgreementViewController alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:vc animated:YES completion:nil];
            self.selectedIndex = 1;
        } else {
            ScheduleIdentifier *main = [ScheduleWidgetCache.shareCache getKeyWithKeyName:ScheduleWidgetCacheKeyMain usingSupport:YES];
            ScheduleIdentifier *other = [ScheduleWidgetCache.shareCache getKeyWithKeyName:ScheduleWidgetCacheKeyOther usingSupport:YES];
            if (!main) { return; }
            if (ScheduleWidgetCache.shareCache.beDouble) {
                [self.schedulePresenter setWithMainKey:main otherKey:other];
            } else {
                [self.schedulePresenter setWithMainKey:main];
            }
            [self presentScheduleControllerWithPan:nil completion:nil];
        }
    }
}

#pragma mark - Getter

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





- (void)presentScheduleControllerWithPan:(UIPanGestureRecognizer * _Nullable)pan completion:(void (^ __nullable)(UIViewController *vc))completion {
    if (self.presentedViewController) {
        completion(self.presentedViewController);
        return;
    }
    UIViewController *vc = [[ScheduleController alloc] initWithPresenter:self.schedulePresenter];
    TransitioningDelegate *delegate = [[TransitioningDelegate alloc] init];
    delegate.transitionDurationIfNeeded = 0.3;
    delegate.panInsetsIfNeeded = UIEdgeInsetsMake(StatusBarHeight(), 0, self.tabBar.height, 0);
    delegate.supportedTapOutsideBackWhenPresent = NO;
    if (pan) {
        delegate.panGestureIfNeeded = pan;
    }
    
    vc.transitioningDelegate = delegate;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:^{
        if (completion) {
            completion(vc);
        }
    }];
}

- (void)_tap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self presentScheduleControllerWithPan:nil completion:nil];
    }
}

- (void)_pan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self presentScheduleControllerWithPan:pan completion:nil];
    }
}

#pragma mark - Setter

- (void)setScheduleBarHidden:(BOOL)scheduleBarHidden {
    _scheduleBarHidden = scheduleBarHidden;
    self.scheduleBar.hidden = scheduleBarHidden;
}





















#pragma mark - Method

- (UIViewController *)_test1 {
    FastLoginViewController *vc = [[FastLoginViewController alloc] init];
    vc.presenter = self.schedulePresenter;
    vc.delegate = self;
    return [[UINavigationController alloc] initWithRootViewController:vc];
}

- (void)viewControllerTapBegin:(FastLoginViewController *)vc {
    [self presentScheduleControllerWithPan:nil completion:nil];
}

@end
