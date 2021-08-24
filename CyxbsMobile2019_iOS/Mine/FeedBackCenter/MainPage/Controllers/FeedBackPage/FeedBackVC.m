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
@interface FeedBackVC ()

@property (nonatomic) TypeSelectView * typeSelectView;

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBar];
    [self.view addSubview:self.typeSelectView];
}


#pragma mark - getter
- (TypeSelectView *)typeSelectView{
    if (!_typeSelectView) {
        _typeSelectView = [[TypeSelectView alloc]initWithFrame:CGRectMake(0, Bar_H, SCREEN_WIDTH, 71)];
    }
    return _typeSelectView;
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
