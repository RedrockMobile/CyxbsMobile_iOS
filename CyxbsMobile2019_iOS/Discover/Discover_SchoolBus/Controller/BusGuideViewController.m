//
//  BusGuideViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2022/5/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "BusGuideViewController.h"
#import "StationsGuideTableViewCell.h"
#import "StationData.h"
#import "StationGuideView.h"

@interface BusGuideViewController ()
/// <#Description#>
@property (nonatomic, copy) NSArray *stationsArray;
/// BusGuide
@property (nonatomic, strong) UITableView *busGuideTableView;
@property (nonatomic, strong) UIScrollView *busGuideScrollView;
@end

@implementation BusGuideViewController

- (instancetype)initWithstationsArray:(NSArray *)stationsArray {
    self = [super init];
    if (self) {
        self.stationsArray = stationsArray;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorNamed:@"242_243_248_1&0_0_0_1"];
    [self.view addSubview:self.busGuideScrollView];
    [self addstationGuideViews];
    self.VCTitleStr = @"校车指南";
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.splitLineHidden = YES;
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    self.titleColor = [UIColor colorNamed:@"21_49_91"];
    self.topBarView.backgroundColor = [UIColor colorNamed:@"white&black"];
}

#pragma mark - Getter

- (UIScrollView *)busGuideScrollView {
    if (!_busGuideScrollView) {
        CGFloat y = self.topBarView.bottom;
        _busGuideScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-y)];
        _busGuideScrollView.top = self.topBarView.bottom;
        _busGuideTableView.bottom = self.view.bottom;
        _busGuideScrollView.contentSize = CGSizeMake(kScreenWidth, 264 * self.stationsArray.count);
    }
    return _busGuideScrollView;
}
- (void)addstationGuideViews {
    for (NSUInteger i = 0; i < self.stationsArray.count; i++) {
        StationGuideView *view = [[StationGuideView alloc]initWithFrame:CGRectMake(0, 264 * i, kScreenWidth, 256) AndStationsData:self.stationsArray[i]];
        view.backgroundColor = [UIColor colorNamed:@"Whiter&Black"];
        [self.busGuideScrollView addSubview:view];
    }
}
@end
