//
//  UserInfoView.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/12.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "UserInfoView.h"
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define Color42_78_132 [UIColor colorNamed:@"color42_78_132&#DFDFE3" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
#define ColorWhite  [UIColor colorNamed:@"colorLikeWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface UserInfoView()
@property (nonatomic, weak)UIImageView *userImage;//头像
@property (nonatomic, weak)UILabel *userNameLabel;//张树洞
@property (nonatomic, weak)UILabel *majorLabel;//软件工程学院
@property (nonatomic, weak)UILabel *idLabel;//2017******
@end
@implementation UserInfoView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
          if (@available(iOS 11.0, *)) {
                  self.backgroundColor = ColorWhite;
              } else {
                  // Fallback on earlier versions
              }
              [self addImage];
              [self addName];
              [self addMajor];
              [self addIDLabel];
    }
    return self;
}

- (void)addImage {
    UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 30, 40, 40)];
    [self addSubview:headerImageView];
    self.userImage = headerImageView;
    NSString *headImgUrl_str = [UserItemTool defaultItem].headImgUrl;
    NSURL *headImageUrl = [NSURL URLWithString:headImgUrl_str];
    [headerImageView sd_setImageWithURL:headImageUrl placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageFromCacheOnly context:nil progress:nil completed:nil];
}
- (void)addName {
    UILabel *label = [[UILabel alloc]init];
    label.text = [UserItemTool defaultItem].realName;
    self.userNameLabel = label;
    label.font = [UIFont fontWithName:PingFangSCBold size:15];
    if (@available(iOS 11.0, *)) {
        [label setTextColor:Color21_49_91_F0F0F2];
    } else {
        // Fallback on earlier versions
    }
    [self addSubview:label];
}
- (void)addMajor {
    UILabel *label = [[UILabel alloc]init];
    self.majorLabel = label;
    label.text = [UserItem defaultItem].college;
    if (@available(iOS 11.0, *)) {
        label.textColor = Color42_78_132;
    } else {
        // Fallback on earlier versions
    }
    [label setAlpha:0.67];
    label.font = [UIFont fontWithName:PingFangSCRegular size:11];
    [self addSubview:label];
}

- (void)addIDLabel {
    UILabel *label = [[UILabel alloc]init];
    self.idLabel = label;
    if (@available(iOS 11.0, *)) {
        label.textColor = Color42_78_132;
    } else {
        // Fallback on earlier versions
    }
    [label setAlpha:0.71];
    label.font = [UIFont fontWithName:PingFangSCRegular size:11];
    label.text = [UserItem defaultItem].stuNum;
    [self addSubview:label];
}
- (void)layoutSubviews {
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImage.mas_right).offset(14);
        make.top.equalTo(self.userImage);
    }];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userImage);
        make.right.equalTo(self).offset(-15);
    }];
    [self.majorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(4);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
