//
//  SchoolBusVC.m
//  CyxbsMobile2019_iOS
//
//  Created by Clutch Powers on 2022/4/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchoolBusVC.h"
#import "SchoolBusMapView.h"
#import "SchoolBusBottomView.h"

@interface SchoolBusVC ()<SchoolBusMapViewDelegate>

///地图View
@property (nonatomic, strong) SchoolBusMapView *schoolBusMapView;

///底部View
@property (nonatomic, strong) SchoolBusBottomView *schoolBusBottomView;


@end

@implementation SchoolBusVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.schoolBusMapView];
    
    [self.schoolBusMapView addSubview:self.schoolBusBottomView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.schoolBusMapView.timer invalidate];
    self.schoolBusMapView.timer = nil;
}

- (SchoolBusMapView *)schoolBusMapView{
    if (!_schoolBusMapView) {
        SchoolBusMapView *schoolBusMapView = [[SchoolBusMapView alloc] initWithFrame:self.view.frame];
        schoolBusMapView.delegate = self;
        _schoolBusMapView = schoolBusMapView;
    }
    return _schoolBusMapView;
}

- (SchoolBusBottomView *)schoolBusBottomView{
    if (!_schoolBusBottomView) {
        CGFloat offset;
            if (IS_IPHONEX) {
                offset = 103;
            } else {
                offset = 88;
            }
        SchoolBusBottomView *schoolBusBottomView = [[SchoolBusBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-offset, SCREEN_WIDTH, offset)];
        _schoolBusBottomView = schoolBusBottomView;
    }
    return _schoolBusBottomView;
}


- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
