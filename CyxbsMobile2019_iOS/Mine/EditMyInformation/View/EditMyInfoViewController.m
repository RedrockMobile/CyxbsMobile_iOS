//
//  EditMyInfoViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoViewController.h"
#import "EditMyInfoContentView.h"
#import "EditMyInfoPresenter.h"

@interface EditMyInfoViewController ()

@property (nonatomic, strong) EditMyInfoPresenter *presenter;

@property (nonatomic, weak) EditMyInfoContentView *contentView;

@end

@implementation EditMyInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[EditMyInfoPresenter alloc] init];
    [self.presenter attachView:self];
    
    EditMyInfoContentView *contentView = [[EditMyInfoContentView alloc] init];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
}

- (void)dealloc
{
    [self.presenter dettatchView];
}

@end
