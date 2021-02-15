//
//  SZHCircleLabelView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/14.
//  Copyright © 2021 Redrock. All rights reserved.
//
/**
 发布动态的下面显示标签的view
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SZHCircleLabelViewDelegate <NSObject>
/// 选中一个按钮
- (void)clickACirleBtn:(UIButton *)sender;
@end

@interface SZHCircleLabelView : UIScrollView
/// 顶部的分割条
@property (nonatomic, strong) UIView *topSeparationView;

@property (nonatomic, strong) UILabel *tittleLbl;

/// button数组
@property (nonatomic, strong) NSMutableArray <UIButton*>*buttonArray;

@property id <SZHCircleLabelViewDelegate>delegate;

@property int split;    //行、列间距
/// 通过一个数组初始化
/// @param array 里面包含着button的文字
- (instancetype)initWithArrays:(NSArray *)array;

/// 按钮布局约束
- (void)btnsAddConstraints;
@end

NS_ASSUME_NONNULL_END
