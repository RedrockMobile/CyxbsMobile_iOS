//
//  FeedBackVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/24.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackVC.h"
#import "TypeSelectView.h"
#import "ZWTMacro.h"
#import "FeedBackView.h"
#import "UIView+XYView.h"
@interface FeedBackVC ()

@property (nonatomic,strong) TypeSelectView * typeSelectView;
@property (nonatomic,strong) FeedBackView *feedBackView;
@property (nonatomic,strong) UIButton *submitBtn;

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBar];
    [self.view addSubview:self.typeSelectView];
    [self.view addSubview:self.feedBackView];
    [self.view addSubview:self.submitBtn];
}


#pragma mark - getter
- (TypeSelectView *)typeSelectView{
    if (!_typeSelectView) {
        _typeSelectView = [[TypeSelectView alloc]initWithFrame:CGRectMake(0, Bar_H, SCREEN_WIDTH, 71)];
    }
    return _typeSelectView;
}

- (FeedBackView *)feedBackView{
    if (!_feedBackView) {
        _feedBackView = [[FeedBackView alloc]initWithFrame:CGRectMake(16, Bar_H + 71, SCREEN_WIDTH - 32, 509)];
    }
    return _feedBackView;
}

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc]init];
        _submitBtn.size = CGSizeMake(117, 41);
        _submitBtn.centerX = self.view.centerX;
        _submitBtn.y = 719;
        [_submitBtn setImage:[UIImage imageNamed:@"submit"] forState:UIControlStateNormal];
    }
    return _submitBtn;
}


#pragma mark - 私有方法
- (void)setupBar{
    self.view.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
    self.VCTitleStr = @"意见反馈";
    self.topBarView.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
    self.splitLineColor = [UIColor systemGray5Color];
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:21];
}


@end
