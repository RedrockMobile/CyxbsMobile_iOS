//
//  LQQGlanceView.h
//  testForLargeTitle
//
//  Created by qianqian on 2019/10/22.
//  Copyright © 2019 千千. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LQQGlanceView : UIView
@property (nonatomic, weak)UIButton *electricFee;//电费二级页面按钮
@property (nonatomic, weak)UIButton *volunteer;//志愿服务二级按钮
@property (nonatomic, weak)UIButton *tools;//工具二级页面


/// 电费查询部分
@property (nonatomic, weak)UILabel *electricFeeTitle;
@property (nonatomic, weak)UILabel *electricFeeTime;
@property (nonatomic, weak)UILabel *electricFeeMoney;
@property (nonatomic, weak)UILabel *electricFeeDegree;
@property (nonatomic, weak)UILabel *electricFeeYuan;
@property (nonatomic, weak)UILabel *electricFeeDu;
@property (nonatomic, weak)UILabel *electricFeeHintLeft;
@property (nonatomic, weak)UILabel *electricFeeHintRight;

///志愿时长部分
@property (nonatomic, weak) UILabel *volunteerTitle;
@property (nonatomic, weak) UILabel *allTime;//总共时长
@property (nonatomic, weak) UILabel *shi;//“时”
@property (nonatomic, weak) UIImageView *allTimeBackImage;
@property (nonatomic, weak) UILabel *recentDate;//最近一次服务的日期
@property (nonatomic, weak) UILabel *recentTitle;//最近一次服务的标题
@property (nonatomic, weak) UILabel *recentTime;//最近一次服务时长
@property (nonatomic, weak) UILabel *recentTeam;//最近一次志愿时长跟随的组织


@end

NS_ASSUME_NONNULL_END

