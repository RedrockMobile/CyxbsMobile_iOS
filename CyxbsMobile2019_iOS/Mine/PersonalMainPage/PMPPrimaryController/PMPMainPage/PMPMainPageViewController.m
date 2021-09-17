//
//  PersonalMainPageViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPMainPageViewController.h"
// view
#import "PMPMainPageHeaderView.h"

@interface PMPMainPageViewController ()

@property (nonatomic, strong) PMPMainPageHeaderView * headerView;

/// 背景图片
@property (nonatomic, strong) UIImageView * backgroundImageView;

@end

@implementation PMPMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)configureView {
    self.VCTitleStr = @"个人主页";
    self.topBarBackgroundColor = [UIColor clearColor];
    
    // config backgroundImageView
    [self.view addSubview:self.backgroundImageView];
    self.backgroundImageView.size = CGSizeMake(self.view.jh_width, self.view.jh_height / 2);
    
}

#pragma mark - lazy

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _backgroundImageView;
}

- (PMPMainPageHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[PMPMainPageHeaderView alloc] init];
        
    }
    return _headerView;
}

@end
