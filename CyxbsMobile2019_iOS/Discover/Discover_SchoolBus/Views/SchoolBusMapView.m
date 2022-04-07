//
//  SchoolBusMapView.m
//  CyxbsMobile2019_iOS
//
//  Created by Clutch Powers on 2022/4/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchoolBusMapView.h"


@implementation SchoolBusMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.mapView];
        [self.mapView addSubview:self.backBtn];
        [self refreshSchoolBusData];
    }
    return self;
}

//当获取到数据时调用
- (void)setSchoolBusDataArray:(NSArray *)schoolBusDataArray{
    _schoolBusDataArray = schoolBusDataArray;
    
    
    
    
    
    
    
    //创建经纬度数组items
    NSMutableArray *items = [NSMutableArray array];
    
    //遍历校车数据
    for (int i = 0; i < _schoolBusDataArray.count; i++) {
        
        SchoolBusData *data = _schoolBusDataArray[i];
        MAMultiPointItem *item = [[MAMultiPointItem alloc] init];
        item.coordinate = CLLocationCoordinate2DMake(data.latitude, data.longitude);
        //将经纬度数据写入数组
        [items addObject:item];
    }
    //根据items创建点
    MAMultiPointOverlay *overlay = [[MAMultiPointOverlay alloc] initWithMultiPointItems:items];
    
    //把Overlay添加进mapView
    [self.mapView addOverlay:overlay];
}


- (MAMapView *)mapView{
    if (!_mapView) {
        
        [AMapServices sharedServices].apiKey = @"0de229ab86861128f7fec123538aa109";
        [[AMapServices sharedServices] setEnableHTTPS:YES];
        [MAMapView updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
        [MAMapView updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
        
        MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.bounds];
        mapView.showsUserLocation = YES;
        mapView.userTrackingMode = MAUserTrackingModeFollow;
        mapView.zoomLevel = 15.4;
        mapView.centerCoordinate = CLLocationCoordinate2DMake(29.529332, 106.607517);
        mapView.scaleOrigin = CGPointMake(50, STATUSBARHEIGHT + 10);
        mapView.showsCompass = NO;
        mapView.delegate = self;
        
        if([CLLocationManager locationServicesEnabled]){

            AMapLocationManager *locationManager = [[AMapLocationManager alloc] init];

            [locationManager setDelegate:self];
            //是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
            [locationManager setAllowsBackgroundLocationUpdates:NO];
            //指定定位是否会被系统自动暂停。默认为NO。
            [locationManager setPausesLocationUpdatesAutomatically:NO];
            //设定定位的最小更新距离。单位米，默认为 kCLDistanceFilterNone，表示只要检测到设备位置发生变化就会更新位置信息
            [locationManager setDistanceFilter:1];
            //设定期望的定位精度。单位米，默认为 kCLLocationAccuracyBest
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //开始定位服务
            [locationManager startUpdatingLocation];

        }
        _mapView = mapView;
    }
    return _mapView;
}


- (UIButton *)backBtn{
    if (!_backBtn) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        backBtn.frame = CGRectMake(17, STATUSBARHEIGHT + 13, 19, 19);
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [backBtn setImage:[UIImage imageNamed:@"我的返回"] forState:UIControlStateNormal];
        [backBtn setTintColor:[UIColor grayColor]];
        [backBtn addTarget:self.delegate action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = backBtn;
    }
    return _backBtn;
}

- (void)refreshSchoolBusData{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(setupSchoolBusData) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}


- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAMultiPointOverlay class]])
       {
           MAMultiPointOverlayRenderer * renderer = [[MAMultiPointOverlayRenderer alloc] initWithMultiPointOverlay:(MAMultiPointOverlay *)overlay];
           
           ///设置图片
           renderer.icon = [UIImage imageNamed:@"BusIcon"];
           ///设置锚点
           renderer.anchor = CGPointMake(0.5, 1.0);
           renderer.delegate = self;
           return renderer;
       }
    return nil;
}

- (void)setupSchoolBusData{
    [SchoolBusData SchoolBusDataWithSuccess:^(NSArray * _Nonnull array) {
            self.schoolBusDataArray = array;
        } error:^{

        }];
    
    NSLog(@"-- STBY --");
}

- (void)dealloc{
    
}

@end
