//
//  CheckInViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/26.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "CheckInViewController.h"
#import "CheckInContentView.h"

@interface CheckInViewController ()

@property (nonatomic, weak) CheckInContentView *contentView;

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CheckInContentView *contentView = [[CheckInContentView alloc] init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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

@end
