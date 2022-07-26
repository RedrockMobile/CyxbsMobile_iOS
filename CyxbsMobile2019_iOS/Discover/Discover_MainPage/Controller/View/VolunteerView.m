//
//  VolunteerView.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/6/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "VolunteerView.h"
#import "VolunteerItem.h"
#import "ArchiveTool.h"

//Bahnschrift字体部分
#define ImpactMedium @"Impact"
#define ImpactRegular @"Impact"

@interface VolunteerView()

@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, strong) VolunteerItem *volunteerItem;

@end


@implementation VolunteerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"colorLikeWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
        } else {
            // Fallback on earlier versions
        }
        [self loadUserDefaults];//加载缓存用作视图的初始化
        [self addNoBindingView];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"volunteer_information"]) {
            self.volunteerItem = [ArchiveTool getPersonalInfo];
            [self refreshViewIfNeeded];
        }
        [self addClearButton];//添加透明按钮用来在被点击后设置宿舍
    }
    return self;
}
-(void)refreshViewIfNeeded {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"volunteer_information"]) {
        [self removeUnbindingView];
        [self addBindingView];
        [self updateAllHour];//总时长刷新
    }else {
        [self removeAllSubviews];
        [self addNoBindingView];
        [self addClearButton];//添加透明按钮用来在被点击后设置宿舍

    }

}
-(void)updateAllHour {
    self.allTime.text = [NSString stringWithFormat:@"%d",[self.volunteerItem.hour intValue]];
}
-(void)removeUnbindingView {
    [self.hintLabel removeFromSuperview];
}
- (void)loadUserDefaults {
    NSUserDefaults *defualts = [NSUserDefaults standardUserDefaults];
    self.defaults = defualts;
}
-(void) addClearButton {
    UIButton * button = [[UIButton alloc]init];
    [button addTarget:self action:@selector(touchSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}
//被点击时调用的方法
-(void)touchSelf {
    if ([self.delegate respondsToSelector:@selector(touchVolunteerView)]) {
        [self.delegate touchVolunteerView];
    }
}
// MARK: 未绑定部分
-(void)addNoBindingView {
    [self addSeperateLine];//一个像素的分割线
    [self addVolunteerTitle];
    [self addAllTimeBackImage];
    [self addHintLabel];
}
- (void)addSeperateLine {
    UIView *line = [[UIView alloc]init];
    if (@available(iOS 11.0, *)) {
        line.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:0.1] darkColor:[UIColor colorWithHexString:@"#2D2D2D" alpha:0.5]];
    } else {
        line.backgroundColor = [UIColor colorWithRed:232/255.0 green:223/255.0 blue:241/255.0 alpha:1];
    }
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@1);
    }];
}
- (void)addHintLabel {
    UILabel *hintLabel = [[UILabel alloc]init];
    self.hintLabel = hintLabel;
    hintLabel.text = @"还未绑定志愿者账号哦～";
    hintLabel.font = [UIFont fontWithName:PingFangSCLight size: 15];
    if (@available(iOS 11.0, *)) {
        hintLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    } else {
        // Fallback on earlier versions
    }
    [self addSubview:hintLabel];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.allTimeBackImage);
        make.left.equalTo(self.allTimeBackImage.mas_right).offset(22);
    }];
}
- (void)addVolunteerTitle {
    UILabel *title = [[UILabel alloc]init];//左上角标题
    self.volunteerTitle = title;
    title.text = @"志愿时长";
    title.font = [UIFont fontWithName:PingFangSCBold size: 18];
    if (@available(iOS 11.0, *)) {
        title.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    } else {
        // Fallback on earlier versions
    }
    [self addSubview:title];
    [self.volunteerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.top.equalTo(self).offset(30);
    }];
}
- (void)addAllTimeBackImage {
    UIImageView *allTimeBackImage = [[UIImageView alloc]init];
    self.allTimeBackImage = allTimeBackImage;
    [allTimeBackImage setImage:[UIImage imageNamed:@"志愿时长"]];
    [self addSubview:allTimeBackImage];
    [self.allTimeBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.volunteerTitle);
        make.top.equalTo(self.volunteerTitle.mas_bottom).offset(16);
        make.width.height.equalTo(@64);
    }];
    [self addAllTime];
    [self addShi];
}
- (void)addAllTime {
    UILabel *allTime = [[UILabel alloc]init];
    self.allTime = allTime;
    allTime.text = @"0";
    allTime.font = [UIFont fontWithName:ImpactRegular size:32];
    if (@available(iOS 11.0, *)) {
        allTime.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    } else {
        // Fallback on earlier versions
    }
    [self.allTimeBackImage addSubview:allTime];
    [self.allTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.allTimeBackImage).offset(-5);
        make.centerY.equalTo(self.allTimeBackImage).offset(2);
    }];
}
- (void)addShi {
    UILabel *shi = [[UILabel alloc]init];
    self.shi = shi;
    shi.text = @"时";
    shi.font = [UIFont fontWithName:PingFangSCBold size:10];
    if (@available(iOS 11.0, *)) {
        shi.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:1] darkColor:[UIColor colorWithHexString:@"#DFDFE3" alpha:1]];
    } else {
        // Fallback on earlier versions
    }
    [self.allTimeBackImage addSubview:shi];
    [self.shi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.allTime.mas_trailing).offset(2);
        make.bottom.equalTo(self.allTime).offset(-7);
    }];
}
//MARK: 已绑定部分
- (void)addBindingView {
    [self addRecentTitle];
    [self addRecentDate];
    [self addRecentTime];
    [self addRecentTeam];
}

- (void)addRecentTitle {
    UILabel *recentTitle = [[UILabel alloc]init];
    self.recentTitle = recentTitle;
    recentTitle.text = self.volunteerItem.eventsArray.firstObject.title;
    recentTitle.font = [UIFont fontWithName: PingFangSCRegular size:15];
    if (@available(iOS 11.0, *)) {
        recentTitle.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    } else {
        // Fallback on earlier versions
    }
    [self addSubview:recentTitle];
    [self.recentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allTimeBackImage.mas_right).offset(22);
        make.top.equalTo(self.allTimeBackImage);
        make.right.equalTo(self).offset(-80);
    }];
}
- (void)addRecentDate {
    UILabel *recentDate = [[UILabel alloc]init];
    self.recentDate = recentDate;
    recentDate.text = self.volunteerItem.eventsArray.firstObject.creatTime;
    recentDate.font = [UIFont fontWithName:PingFangSCLight size: 10];
    if (@available(iOS 11.0, *)) {
        recentDate.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    } else {
        // Fallback on earlier versions
    }
    recentDate.alpha = 0.54;
    [self addSubview:recentDate];
    [self.recentDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recentTitle);
        make.right.equalTo(self).offset(-15);
    }];
}
- (void)addRecentTime {
    UILabel *recentTime = [[UILabel alloc]init];
    self.recentTime = recentTime;
    recentTime.text = self.volunteerItem.eventsArray.firstObject.hour;
    recentTime.font = [UIFont fontWithName:PingFangSCLight size: 11];
    if (@available(iOS 11.0, *)) {
        recentTime.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    } else {
        // Fallback on earlier versions
    }
    recentTime.alpha = 0.8;
    [self addSubview:recentTime];
    [self.recentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recentTitle);
        make.top.equalTo(self.recentTitle.mas_bottom).offset(4);
    }];
}
- (void)addRecentTeam {
    UILabel *recentTeam= [[UILabel alloc]init];
    self.recentTeam = recentTeam;
    recentTeam.text = self.volunteerItem.eventsArray.firstObject.server_group;
    recentTeam.font = [UIFont fontWithName:PingFangSCLight size: 13];
    if (@available(iOS 11.0, *)) {
        recentTeam.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    } else {
        // Fallback on earlier versions
    }
    recentTeam.alpha = 0.8;
    [self addSubview:recentTeam];
    [self.recentTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recentTime);
        make.top.equalTo(self.recentTime.mas_bottom).offset(4);
        make.right.equalTo(self).offset(-15);
    }];
}
@end
