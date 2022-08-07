//
//  RisingCycleSingleLabelView.h
//  ByteDanceCampus_Klotski
//
//  Created by SSR on 2022/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - RisingCycleSingleLabelView

@interface RisingCycleSingleLabelView : UIView

/// 方向，默认UIAccessibilityScrollDirectionLeft向左
@property (nonatomic) UIAccessibilityScrollDirection scrollDirection;

/// 自定义一个Label并赋值，赋值后才有效，只有width不会被改变
@property (nonatomic, strong, null_resettable) __kindof UILabel *label;

/// 多少秒循环一次，默认2秒
@property (nonatomic) NSTimeInterval timeForSigleCycle;

/// 循环时多久刷新一次，默认0.025
@property (nonatomic) NSTimeInterval timeForSpeedScheduled;

/// 没次speedScheduled所需要滑动的距离，默认0.5
@property (nonatomic) CGFloat contentForPertime;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithLabel:(UILabel *)label contentWidth:(CGFloat)width;

/// 开始
- (void)begin;

/// 结束
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
