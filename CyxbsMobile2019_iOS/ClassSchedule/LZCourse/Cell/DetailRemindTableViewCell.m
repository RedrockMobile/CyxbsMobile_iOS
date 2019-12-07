//
//  DetailRemindTableViewCell.m
//  Demo
//
//  Created by 李展 on 2016/12/2.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import "DetailRemindTableViewCell.h"
#import "UIFont+AdaptiveFont.h"
@implementation DetailRemindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.stackView.layer.cornerRadius = 4.f;
    self.stackView.layer.masksToBounds = YES;
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#42a9fe"];
    self.timeLabel.font = [UIFont adaptFontSize:12];
    self.weekLabel.textColor = [UIColor colorWithHexString:@"#42a3ff"];
    self.weekLabel.font = [UIFont adaptFontSize:13];
    self.segmentView.backgroundColor = [UIColor colorWithHexString:@"#e1e1e1"];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#737373"];
    self.contentLabel.font = [UIFont adaptFontSize:12];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.titleLabel.font = [UIFont adaptFontSize:16];
    self.remindTimeLabel.textColor = [UIColor colorWithHexString:@"#c7c7c7"];
    self.remindTimeLabel.font = [UIFont adaptFontSize:11];
    self.editView.alpha = 0;
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"椭圆"] forState:UIControlStateNormal];
    self.contentLabel.numberOfLines = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
