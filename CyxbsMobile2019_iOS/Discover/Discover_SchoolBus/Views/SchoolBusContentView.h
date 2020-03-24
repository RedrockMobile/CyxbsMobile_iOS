//
//  SchoolBusContentView.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol SchoolBusContentViewProtocol <NSObject>

- (void)backButtonClicked;

@end


@class MAMapView, MAPointAnnotation, SchoolBusItem;
@interface SchoolBusContentView : UIView

@property (nonatomic, weak) id<SchoolBusContentViewProtocol> delegate;

/// 地图视图
@property (nonatomic, weak) MAMapView *mapView;

/// 校车A
@property (nonatomic, weak) MAPointAnnotation *schoolBusPinA;

/// 校车B
@property (nonatomic, weak) MAPointAnnotation *schoolBusPinB;


- (void)updateSchoolBusLocation:(NSArray<SchoolBusItem *> *)busArray;

@end

NS_ASSUME_NONNULL_END
