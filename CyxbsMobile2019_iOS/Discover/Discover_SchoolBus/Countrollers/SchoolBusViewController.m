//
//  SchoolBusViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "SchoolBusViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface SchoolBusViewController ()<AMapLocationManagerDelegate>

@end

@implementation SchoolBusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AMapServices sharedServices].apiKey = @"b63093746b0d6f4d4fdf90284b41b8c8";
    
    MAMapView *map = [[MAMapView alloc] initWithFrame:self.view.bounds];
    map.showsUserLocation = YES;
    map.userTrackingMode = MAUserTrackingModeFollow;
    [self.view addSubview:map];
    
    if([CLLocationManager locationServicesEnabled]){
        
        AMapLocationManager *locationManager = [[AMapLocationManager alloc] init];
        
        [locationManager setDelegate:self];
        //是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
        [locationManager setAllowsBackgroundLocationUpdates:NO];
        //指定定位是否会被系统自动暂停。默认为NO。
        [locationManager setPausesLocationUpdatesAutomatically:NO];
        //设定定位的最小更新距离。单位米，默认为 kCLDistanceFilterNone，表示只要检测到设备位置发生变化就会更新位置信息
        [locationManager setDistanceFilter:20];
        //设定期望的定位精度。单位米，默认为 kCLLocationAccuracyBest
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //开始定位服务
        [locationManager startUpdatingLocation];
        
    }
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(20, 60, 50, 30);
    [backButton setTitle:@"back" forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor grayColor]];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
