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
    
    [self animationForViewWillAppear];
}

- (void)animationForViewWillAppear {
    self.contentView.checkInView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 400);
    self.contentView.storeView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 100);
    
    [UIView animateWithDuration:0.5 delay:1 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.checkInView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];

    [UIView animateWithDuration:0.5 delay:1.2 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.storeView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];

}

@end
