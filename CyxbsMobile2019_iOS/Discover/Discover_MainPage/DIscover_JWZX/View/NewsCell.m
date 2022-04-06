//
//  NewsCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "NewsCell.h"
#define ColorHaveFile  [UIColor colorNamed:@"ColorHaveFile" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorNewsTime  [UIColor colorNamed:@"ColorNewsTime" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorNewsCellTitle  [UIColor colorNamed:@"ColorNewsCellTitle" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorSeperateLine  [UIColor colorNamed:@"ColorSeperateLine" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]


@implementation NewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (@available(iOS 11.0, *)) {
            self.textLabel.textColor = ColorNewsTime;
            self.detailTextLabel.textColor = ColorNewsCellTitle;
        } else {
            // Fallback on earlier versions
        }
        self.textLabel.font = [UIFont fontWithName:PingFangSCBold size:15];
        self.detailTextLabel.font = [UIFont fontWithName:PingFangSCRegular size:13];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addHaveFileLabel];
        [self addSeperateLine];
    }
    return self;
}
- (void)addHaveFileLabel {
    UILabel *label = [[UILabel alloc]init];
    [self.contentView addSubview:label];
    self.haveFileLabel = label;
    label.font = [UIFont fontWithName:PingFangSCRegular size:11];
    if (@available(iOS 11.0, *)) {
        label.textColor = ColorHaveFile;
    } else {
        // Fallback on earlier versions
    }
}
- (void)addSeperateLine {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,1000, 2)];
    [self.contentView addSubview:view];
    if (@available(iOS 11.0, *)) {
        view.backgroundColor = ColorSeperateLine;
    } else {
        // Fallback on earlier versions
    }
    
}
- (void)layoutSubviews {
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(21);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.equalTo(self.textLabel.mas_bottom).offset(11);
        make.right.lessThanOrEqualTo(self).offset(-59);
    }];
    [self.haveFileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textLabel);
        make.right.equalTo(self).offset(-15);
    }];
}
@end
