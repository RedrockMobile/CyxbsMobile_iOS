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

#import "ScheduleNETRequest.h"
#import "SchedulePresenter.h"
#import "ScheduleShareCache.h"
#import "ScheduleTouchItem.h"

#import "ScheduleBar.h"
#import "ScheduleController.h"
#import "TransitioningDelegate.h"

@interface CyxbsTabBarController () <FastLoginViewControllerDelegate>

@property (nonatomic, strong) ScheduleBar *scheduleBar;

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
    [self addObserver:self forKeyPath:@"tabBar.hidden" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self _once];
    [self reloadScheduleBar];
    [self presentControllerWhatIfNeeded];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"tabBar.hidden"]) {
        self.scheduleBarHidden = [change[@"new"] boolValue];
    }
}

#pragma mark - Method

- (void)presentControllerWhatIfNeeded {
    if (self.presentedViewController) {
        return;
    }
    BOOL hadReadAgreement = [NSUserDefaults.standardUserDefaults boolForKey:@"UDKey_hadReadAgreement"];
    if (!hadReadAgreement) {
        // 用户协议以及登录请在这里进行改变
        UIViewController *vc = [[UserAgreementViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:YES completion:nil];
        self.selectedIndex = 1;
    } else {
        ScheduleIdentifier *main = [ScheduleShareCache memoryKeyForKey:nil forKeyName:ScheduleWidgetCacheKeyMain];
        ScheduleIdentifier *other = [ScheduleShareCache memoryKeyForKey:nil forKeyName:ScheduleWidgetCacheKeyOther];
        if (!main) { return; }
        if (other.useWidget == YES) {
            [self.schedulePresenter setWithMainKey:main otherKey:other];
        } else {
            [self.schedulePresenter setWithMainKey:main];
        }
        [self presentScheduleControllerWithPan:nil completion:nil];
    }
}

- (void)reloadScheduleBar {
    ScheduleIdentifier *mainKey = [ScheduleShareCache memoryKeyForKey:nil forKeyName:ScheduleWidgetCacheKeyMain];
    if (mainKey) {
        [ScheduleNETRequest requestDic:@{
            ScheduleModelRequestStudent : @[mainKey.sno]
        } success:^(ScheduleCombineItem * _Nonnull item) {
            ScheduleTouchItem *touch = [[ScheduleTouchItem alloc] init];
            touch.combining = item;
            ScheduleCourse *now = touch.floorCourse;
            if (now) {
                self.scheduleBar.title = now.course;
                self.scheduleBar.time = now.timeStr;
                self.scheduleBar.place = now.classRoom;
            } else {
                self.scheduleBar.title = @"今天已经没课了";
                self.scheduleBar.time = @"也许明天才有课";
                self.scheduleBar.place = @"好好休息下吧";
            }
        } failure:^(NSError * _Nonnull error, ScheduleIdentifier * _Nonnull errorID) {
            self.scheduleBar.title = @"网络请求失败";
            self.scheduleBar.time = @"无法加载时间...";
            self.scheduleBar.place = @"无法加载地点...";
        }];
    }
}

- (void)presentScheduleControllerWithPan:(UIPanGestureRecognizer * _Nullable)pan completion:(void (^ __nullable)(UIViewController *vc))completion {
    if (self.presentedViewController) {
        if (completion) {
            completion(self.presentedViewController);
        }
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

#pragma mark - Getter

- (ScheduleBar *)scheduleBar {
    if (_scheduleBar == nil) {
        CGFloat height = 58;
        CGRect frame = CGRectMake(0, self.view.height - self.tabBar.height - height, self.view.width, height);
        _scheduleBar = [[ScheduleBar alloc] initWithFrame:frame];
        _scheduleBar.title = @"正在请求课程";
        _scheduleBar.time = @"课程的时间";
        _scheduleBar.place = @"课程的地点";
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan:)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tap:)];
        [_scheduleBar addGestureRecognizer:pan];
        [_scheduleBar addGestureRecognizer:tap];
    }
    return _scheduleBar;
}

#pragma mark - Private

- (void)_once {
    static BOOL _draw = NO;
    if (!_draw) {
        _draw = YES;
        [self.view addSubview:self.scheduleBar];
        [self _drawEffects];
    }
}

- (void)_drawEffects {
    { // !!!: tabBar
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:effect];
        view.frame = self.tabBar.bounds;
        [self.tabBar insertSubview:view atIndex:0];
    }
    { // !!!: scheduleBar
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:effect];
        view.frame = self.scheduleBar.bounds;
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.frame = view.bounds;
        shapeLayer.path = bezierPath.CGPath;
        view.layer.mask = shapeLayer;
        [self.scheduleBar insertSubview:view atIndex:0];
    }
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
