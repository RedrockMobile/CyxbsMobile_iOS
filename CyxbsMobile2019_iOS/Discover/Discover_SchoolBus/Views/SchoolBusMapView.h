//
//  SchoolBusMapView.h
//  CyxbsMobile2019_iOS
//
//  Created by Clutch Powers on 2022/4/7.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "SchoolBusData.h"

NS_ASSUME_NONNULL_BEGIN



@protocol SchoolBusMapViewDelegate <NSObject>

- (void)backBtnClicked;

@end

/**
    地图View
 */
@interface SchoolBusMapView : UIView <MAMapViewDelegate,AMapLocationManagerDelegate>

/// 地图视图
@property (nonatomic, strong) MAMapView *mapView;

///返回按钮
@property (nonatomic, strong) UIButton *backBtn;

///返回按钮的代理
@property (nonatomic, weak) id<SchoolBusMapViewDelegate> delegate;

///校车位置数组
@property (nonatomic, copy) NSArray *schoolBusPointArray;

@property (nonatomic, strong) NSTimer *timer;

@end

NS_ASSUME_NONNULL_END
