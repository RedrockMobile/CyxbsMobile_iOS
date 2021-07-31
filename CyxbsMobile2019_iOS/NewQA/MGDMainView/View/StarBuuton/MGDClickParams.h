//
//  MGDClickParams.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDClickParams : NSObject

/// 动画时间
@property(nonatomic, assign) double animationDuration;

/// 大圈圈的颜色
@property(nonatomic, strong)UIColor *bigCiercleColor;

/// 是否需要Flash效果
@property(nonatomic, assign) BOOL enableFlashing;

/// 圈圈的个数
@property(nonatomic, assign) int circleCount;

/// shine的扩散的旋转角度
@property(nonatomic, assign) float circleTurnAngle;

/// 圈圈的扩散的范围的倍数
@property(nonatomic, assign) float circleDistanceMultiple;

/// 小圈圈与大圈圈之前的角度差异
@property(nonatomic, assign) float  smallCircleOffsetAngle;

/// 小圈圈的颜色
@property(nonatomic, strong)UIColor *smallCircleColor;
/// 圈圈的大小
@property(nonatomic, assign) float circleSize;
/// 随机颜色
@property(nonatomic, strong) NSArray<UIColor *> *colorRandom;

@end

NS_ASSUME_NONNULL_END
