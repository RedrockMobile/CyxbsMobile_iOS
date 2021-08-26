//
//  CommonQuestionDetailVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "CommonQuestionDetailVC.h"

@interface CommonQuestionDetailVC ()

@end

@implementation CommonQuestionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBar];
    
}

#pragma mark - 私有方法
- (void)setupBar{
    self.view.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
    self.VCTitleStr = @"一个问题";
    self.topBarView.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
    self.splitLineColor = [UIColor systemGray5Color];
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:21];
}
@end
