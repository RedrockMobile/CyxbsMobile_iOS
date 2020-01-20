//
//  CheckInViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/26.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "CheckInViewController.h"
#import "CheckInProtocol.h"
#import "CheckInPresenter.h"
#import "IntegralStoreViewController.h"
#import "IntegralStoreTransitionAnimator.h"
#import "IntegralStorePercentDrivenController.h"

@interface CheckInViewController () <CheckInProtocol, CheckInContentViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) CheckInPresenter *presenter;

@property (nonatomic, weak) MBProgressHUD *chekingHUD;

@end

@implementation CheckInViewController


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:247/255.0 alpha:1];
    
    // 绑定Presenter
    self.presenter = [[CheckInPresenter alloc] init];
    [self.presenter attachView:self];
    
    // 添加子视图
    CheckInContentView *contentView = [[CheckInContentView alloc] init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    contentView.delegate = self;
    self.contentView = contentView;
    
    // 临时返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setTitle:@"back" forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(200, 100, 100, 40);
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [self animationForViewWillAppear];
}

- (void)dealloc
{
    [self.presenter dettachView];
    _presenter = nil;
}

- (void)animationForViewWillAppear {
    self.contentView.checkInView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 400);
    self.contentView.storeView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 100);
    
    [UIView animateWithDuration:0.7 delay:0.15 usingSpringWithDamping:1 initialSpringVelocity:7 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.checkInView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];

    [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.storeView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];

}


#pragma mark - 按钮回调
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 代理回调
- (void)CheckInButtonClicked:(UIButton *)sender {
    if ([UserItemTool defaultItem].rank.intValue != 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"今天签过到了哦～";
        [hud hide:YES afterDelay:1.5];
        return;
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"正在签到...";
        self.chekingHUD = hud;
    }
    [self.presenter checkIn];
}

- (void)presentIntegralStore:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.presentPanGesture = pan;
        
        IntegralStoreViewController *vc = [[IntegralStoreViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.transitioningDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
}


#pragma mark - Presenter回调
- (void)checkInSucceded {
    [self.contentView CheckInSucceded];
    
    [self.chekingHUD hide:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"签到成功";
    [hud hide:YES afterDelay:1.5];
}

- (void)checkInFailed {
    [self.chekingHUD hide:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Σ（ﾟдﾟlll）签到失败了...";
    [hud hide:YES afterDelay:1.5];
}


#pragma mark - 转场动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[IntegralStoreTransitionAnimator alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[IntegralStoreTransitionAnimator alloc] init];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self.presentPanGesture) {
        return [[IntegralStorePercentDrivenController alloc] initWithPanGesture:self.presentPanGesture];
    } else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self.presentPanGesture) {
        return [[IntegralStorePercentDrivenController alloc] initWithPanGesture:self.presentPanGesture];
    } else {
        return nil;
    }
}

@end
