//
//  VolunteerView.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/6/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYHCycleLabel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol VolunteerViewDelegate <NSObject>
-(void)touchVolunteerView;
@end

@interface VolunteerView : UIView
@property (nonatomic, weak)id<VolunteerViewDelegate> delegate;


@property (nonatomic, weak)UIButton *volunteer;//志愿服务二级按钮
///志愿时长部分
@property (nonatomic, weak) UILabel *volunteerTitle;
@property (nonatomic, weak) UILabel *allTime;//总共时长
@property (nonatomic, weak) UILabel *shi;//“时”
@property (nonatomic, weak) UIImageView *allTimeBackImage;
@property (nonatomic, weak) UILabel *recentDate;//最近一次服务的日期
@property (nonatomic, weak) UILabel *recentTitle;//最近一次服务的标题
@property (nonatomic, weak) UILabel *recentTime;//最近一次服务时长
@property (nonatomic, weak) UILabel *recentTeam;//最近一次志愿时长跟随的组织



@property (nonatomic, weak) UILabel *hintLabel;//"还没有绑定志愿者账号哦～"
-(void) refreshViewIfNeeded;

@end

NS_ASSUME_NONNULL_END
