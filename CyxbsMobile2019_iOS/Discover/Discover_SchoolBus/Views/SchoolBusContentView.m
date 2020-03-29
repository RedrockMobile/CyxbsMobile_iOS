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
        map.zoomLevel = 15.4;
        map.centerCoordinate = CLLocationCoordinate2DMake(29.529332, 106.607517);
        map.scaleOrigin = CGPointMake(20, 35);      // 比例尺位置
        map.showsCompass = NO;                      // 不显示指南针
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
        
        //        NSDate *today = [NSDate date];
        //        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //        // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
        //        [dateFormat setDateFormat:@"HH:mm"];
        //        NSString * todayStr = [dateFormat stringFromDate:today];//将日期转换成字符串
        //        today = [dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
        //        //startTime格式为 02:22   expireTime格式为 12:44
        //        NSDate *start = [dateFormat dateFromString:@"11:00"];
        //        NSDate *expire = [dateFormat dateFromString:@"14:00"];
        //
        //        if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        ////            return YES;
        //        }
        ////        return NO;
        
        UIView *darkBoard = [[UIView alloc] initWithFrame:frame];
        if (@available(iOS 13.0, *)) {
            darkBoard.backgroundColor = [UIColor systemBackgroundColor];
        } else {
            darkBoard.backgroundColor = [UIColor clearColor];
        }
        darkBoard.alpha = 0.2;
        darkBoard.userInteractionEnabled = NO;
        [self addSubview:darkBoard];
        
        // 返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        backButton.frame = CGRectMake(20, 60, 50, 30);
        [backButton setTitle:@"back" forState:UIControlStateNormal];
        [backButton setTintColor:[UIColor grayColor]];
        [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        UIView *bottomView = [[UIView alloc] init];
        if (@available(iOS 13.0, *)) {
            bottomView.backgroundColor = [UIColor colorNamed:@"SchoolBusBottomColor"];
        } else {
            bottomView.backgroundColor = [UIColor blackColor];
        }
        bottomView.layer.cornerRadius = 16;
        [self addSubview:bottomView];
        self.bottomView = bottomView;
        
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.text = @"校车运行中";
        statusLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        if (@available(iOS 13.0, *)) {
            statusLabel.textColor = [UIColor colorNamed:@"SchoolBusLabelColor"];
        } else {
            statusLabel.textColor = [UIColor blackColor];
        }
        [self addSubview:statusLabel];
        self.statusLabel = statusLabel;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = @"校车营运时间：11：00-14：00、17：00-22：00";
        timeLabel.font = [UIFont systemFontOfSize:13];
        if (@available(iOS 11.0, *)) {
            timeLabel.textColor = [UIColor colorNamed:@"SchoolBusLabelColor"];
        } else {
            timeLabel.textColor = [UIColor blackColor];
        }
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self).offset(16);
        if (IS_IPHONEX) {
            make.height.equalTo(@103);
        } else {
            make.height.equalTo(@88);
        }
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomView).offset(16);
        make.top.equalTo(self.bottomView).offset(12);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.statusLabel);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(6);
    }];
}


- (void)updateSchoolBusLocation:(NSArray<SchoolBusItem *> *)busArray {
    // 更新校车位置
    self.lastItemArray = self.latestItemArray;
    self.latestItemArray = busArray;
    
    if (self.schoolBusPinA == nil) {
        MAPointAnnotation *pinA = [[MAPointAnnotation alloc] init];
        [self.mapView addAnnotation:pinA];
        self.schoolBusPinA = pinA;
    }
    self.schoolBusPinA.coordinate = CLLocationCoordinate2DMake(self.latestItemArray[0].lat, self.latestItemArray[1].lon);
    self.schoolBusPinA.title = @"校车A";
    
    if (self.schoolBusPinB == nil) {
        MAPointAnnotation *pinB = [[MAPointAnnotation alloc] init];
        [self.mapView addAnnotation:pinB];
        self.schoolBusPinB = pinB;
    }
    self.schoolBusPinB.coordinate = CLLocationCoordinate2DMake(self.latestItemArray[0].lat, self.latestItemArray[1].lon);
    self.schoolBusPinB.title = @"校车B";
}


#pragma mark - 手势调用
- (void)backButtonClicked {
    if ([self.delegate respondsToSelector:@selector(backButtonClicked)]) {
        [self.delegate backButtonClicked];
    }
}

@end
