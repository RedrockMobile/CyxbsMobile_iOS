//
//  SchoolBusContentView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "SchoolBusContentView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "SchoolBusItem.h"

@interface SchoolBusContentView () <AMapLocationManagerDelegate>

/// 上一次的校车位置
@property (nonatomic, copy) NSArray<SchoolBusItem *> *lastItemArray;

/// 最新一次的校车位置
@property (nonatomic, copy) NSArray<SchoolBusItem *> *latestItemArray;

@end

@implementation SchoolBusContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 这个key出问题了找我，QQ：1374872604，别再其他软件里用这个key，会出问题
        [AMapServices sharedServices].apiKey = @"7252742ad6f47069544dbf9213f68b56";
        
        MAMapView *map = [[MAMapView alloc] initWithFrame:self.bounds];
        map.showsUserLocation = YES;
        map.userTrackingMode = MAUserTrackingModeFollow;
        map.zoomLevel = 15.5;
        map.centerCoordinate = CLLocationCoordinate2DMake(29.530332, 106.607517);
        [self addSubview:map];
        self.mapView = map;
        
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
        [self addSubview:backButton];
    }
    return self;
}

- (void)updateSchoolBusLocation:(NSArray<SchoolBusItem *> *)busArray {
    // 更新缓存的校车位置
    self.lastItemArray = self.latestItemArray;
    self.latestItemArray = busArray;
    
    MAPointAnnotation *pinA = [[MAPointAnnotation alloc] init];
    pinA.coordinate = CLLocationCoordinate2DMake(self.latestItemArray[0].lat, self.latestItemArray[1].lon);
    pinA.title = @"校车A";
    [self.mapView addAnnotation:pinA];
    self.schoolBusPinA = pinA;
    
    MAPointAnnotation *pinB = [[MAPointAnnotation alloc] init];
    pinB.coordinate = CLLocationCoordinate2DMake(self.latestItemArray[0].lat, self.latestItemArray[1].lon);
    pinB.title = @"校车B";
    [self.mapView addAnnotation:pinB];
    self.schoolBusPinB = pinB;
}


#pragma mark - 手势调用
- (void)backButtonClicked {
    if ([self.delegate respondsToSelector:@selector(backButtonClicked)]) {
        [self.delegate backButtonClicked];
    }
}

@end
