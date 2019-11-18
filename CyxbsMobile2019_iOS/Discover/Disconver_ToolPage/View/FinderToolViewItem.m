//
//  FinderToolViewItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2019/11/15.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "FinderToolViewItem.h"


@interface FinderToolViewItem()
@property (nonatomic, weak)UIImageView *iconView;
@property (nonatomic, weak)UILabel *myTitleLabel;//前缀加my是为了防止与原命名重名
@property (nonatomic, weak)UILabel *myDetailLabel;

@end
@implementation FinderToolViewItem

- (instancetype)initWithIconView:(NSString *)iconViewName Title:(NSString *)title Detail:(NSString *)detail {
    if(self = [super init]) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 10;
        [self addIconView];
        [self addTitleLabel];
        [self addDetailLabel];
        self.iconView.image = [UIImage imageNamed:iconViewName];
        self.myTitleLabel.text = title;
        self.myDetailLabel.text = detail;
    }
    return self;
}
- (void) addIconView {
    UIImageView *iconView = [[UIImageView alloc]init];
    self.iconView = iconView;
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:iconView];
}
- (void) addTitleLabel {
    UILabel *label = [[UILabel alloc]init];
    self.myTitleLabel = label;
    label.textColor = Color42_78_132;
    label.font = [UIFont fontWithName:PingFangSCBold size:24];
    [self addSubview:label];
}
- (void) addDetailLabel {
    UILabel *label =[[UILabel alloc]init];
    self.myDetailLabel = label;
    label.textColor = Color42_78_132;
    label.font = [UIFont fontWithName:PingFangSCRegular size:11];
    label.numberOfLines = 0;
    [self addSubview:label];
}
- (void)layoutSubviews {
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.myTitleLabel.mas_top).offset(-31);
        make.left.equalTo(self).offset(23);
        make.width.height.equalTo(@40);
    }];
    [self.myTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView);
        make.bottom.equalTo(self.myDetailLabel.mas_top).offset(-7);
    }];
    [self.myDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView);
        make.top.equalTo(self.mas_bottom).offset(-73);
    }];
}
@end
