//
//  ElectricityView.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/6/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
//Bahnschrift字体部分
#define ImpactMedium @"Impact"
#define ImpactRegular @"Impact"
NS_ASSUME_NONNULL_BEGIN

@protocol ElectricityViewDelegate <NSObject>
-(void)touchElectrictyView;
@end

@interface ElectricityView : UIView


@property (nonatomic, weak)id<ElectricityViewDelegate> delegate;
//@property (nonatomic, weak)UIButton *electricFee;//电费二级页面按钮
/// 电费查询部分
@property (nonatomic, weak)UILabel *electricFeeTitle;//”电费查询“
@property (nonatomic, weak)UILabel *electricFeeTime;//右上角时间
@property (nonatomic, weak)UIButton *electricFeeMoney;//钱的数字       可点击修改寝室
@property (nonatomic, weak)UILabel *electricFeeDegree;//度的数字
@property (nonatomic, weak)UILabel *electricFeeYuan;//“元”
@property (nonatomic, weak)UILabel *electricFeeDu;//“度”
@property (nonatomic, weak)UILabel *electricFeeHintLeft;//“费用/本月”
@property (nonatomic, weak)UILabel *electricFeeHintRight;//“使用度数/本月”
@property (nonatomic, weak)UILabel *hintLabel;//“还未绑定账号哦～”

@property (nonatomic, weak)UIButton *clearButton;
@property (nonatomic, weak)UIButton *bindingButton;//点击之后跳转绑定宿舍

/// 当有数据的时候调用这个方法更新为有预览的视图
-(void) refreshViewIfNeeded;
@end

NS_ASSUME_NONNULL_END




