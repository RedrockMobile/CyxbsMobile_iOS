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

- (void)setSchoolBusDataArray:(NSArray *)schoolBusDataArray{
    //当获取到数据时调用
    NSMutableArray *items = [NSMutableArray array];
    
    _schoolBusDataArray = schoolBusDataArray;
    
    SchoolBusData *data = _schoolBusDataArray[0];
    
    MAMultiPointItem *item = [[MAMultiPointItem alloc] init];
    
    item.coordinate = CLLocationCoordinate2DMake(data.latitude, data.longitude);
    
    [items addObject:item];
    
    MAMultiPointOverlay *overlay = [[MAMultiPointOverlay alloc] initWithMultiPointItems:items];
    
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
    [SchoolBusData SchoolBusDataWithSuccess:^(NSArray * _Nonnull array) {
            self.schoolBusDataArray = array;
        } error:^{
            
        }];
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



@end
