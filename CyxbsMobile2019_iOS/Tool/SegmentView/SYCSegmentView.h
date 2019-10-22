//
//  SYCSegmentView.h
//  MoblieCQUPT_iOS
//
//  Created by 施昱丞 on 2019/3/10.
//  Copyright © 2019年 Shi Yucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

//SegmentView样式类型，SYCSegmentViewTypeNormal为普通，SYCSegmentViewTypeButton为按钮形
typedef NS_ENUM(NSUInteger, SYCSegmentViewType){
    SYCSegmentViewTypeNormal = 0,
    SYCSegmentViewTypeButton = 1,
    SYCSegmentViewTypeHiddenLine = 2,
};


@protocol SYCSegmentViewDelegate

@required
/**
 点击SegmentView触发的方法
 
 @param index 标示点击的第几个SegmentView
 */
- (void)scrollEventWithIndex:(NSInteger) index;

@end


@interface SYCSegmentView : UIView <SYCSegmentViewDelegate>

@property (nonatomic, weak) id<SYCSegmentViewDelegate> eventDelegate;
@property (nonatomic) CGFloat titleHeight;  //标签栏高度
@property (nonatomic, strong) UIColor *selectedTitleColor;  //标签选中时的字体颜色
@property (nonatomic, strong) UIColor *titleColor;  //标签字体颜色
@property (nonatomic, strong) UIFont *titleFont;    //标签字体属性
@property (nonatomic, strong) UIColor *titleBackgroundColor;    //标签背景颜色
@property (nonatomic) SYCSegmentViewType segmentType;   //SegmentView样式类型


/**
 默认初始化方法（Type是样式类型）
 
 @param frame SegmentView的Frame大小
 @param controllers SegmentView容纳的视图控制器，以数组形式提供
 @param type SegmentView的样式类型，
 @return 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray <UIViewController *> *)controllers type:(SYCSegmentViewType)type;

/**
 设置SegmentView上方标签栏的字体颜色
 
 @param titleColor 标签栏的字体颜色
 */
- (void)setTitleColor:(UIColor *)titleColor;


/**
 设置SegmentView上方标签栏选中后的字体颜色
 
 @param selectedTitleColor 选中后的字体颜色
 */
- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor;


/**
 设置SegmentView上方标签栏的字体样式或者大小
 
 @param font 字体样式或者大小
 */
- (void)setFont:(UIFont *)font;

@end


