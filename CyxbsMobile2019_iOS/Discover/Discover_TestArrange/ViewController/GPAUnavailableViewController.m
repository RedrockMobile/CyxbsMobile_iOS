//
//  GPAUnavailableViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/11/11.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "GPAUnavailableViewController.h"

@interface GPAUnavailableViewController ()

@end

@implementation GPAUnavailableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBar];
    
}

- (void)setupBar{
    self.view.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
    self.VCTitleStr = @"学分成绩";
    self.topBarView.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
    self.splitLineColor = [UIColor colorNamed:@"BarLine"];
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:21];
}


@end
