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

- (void)setSchoolBusPointArray:(NSArray *)schoolBusPointArray{
    
    if (_schoolBusPointArray) {
        [_mapView removeAnnotations:self.schoolBusPointArray];
    }
    
    _schoolBusPointArray = schoolBusPointArray;
    
    [_mapView addAnnotations:_schoolBusPointArray];
    
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

    
    if (!_timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(setupSchoolBusData) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }

}

//将原始数据转换为地图上的标记点
- (void)setupSchoolBusData{
    [SchoolBusData SchoolBusDataWithSuccess:^(NSArray * _Nonnull array) {
        NSMutableArray *mArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            SchoolBusData *data = array[i];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(data.latitude, data.longitude);
            pointAnnotation.title = [NSString stringWithFormat:@"BusID : %d",data.busID];
            
            [mArray addObject:pointAnnotation];
        }
        self.schoolBusPointArray = mArray;
        NSLog(@"%lu",(unsigned long)array.count);
        } error:^{

        }];
    
    NSLog(@"-- STBY --");
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
        {
            static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
            MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
            if (annotationView == nil)
            {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            }
            annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
            annotationView.animatesDrop = NO;        //设置标注动画显示，默认为NO
            annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
            annotationView.pinColor = MAPinAnnotationColorPurple;
            return annotationView;
        }
        return nil;
    
    
}
@end
