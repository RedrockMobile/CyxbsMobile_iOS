//
//  MyTableViewCell.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/9.
//

#import "TaskTableViewCell.h"
#import "PrefixHeader.pch"


@implementation TaskTableViewCell

- (instancetype)init{
    if (self = [super init]) {
        self.contentView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
        [self.contentView addSubview:self.mainLabel];
        [self.contentView addSubview:self.gotoButton];
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}

- (UILabel *)mainLabel{
    if (!_mainLabel) {
        UILabel *mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH, 18, 200, 22)];
        mainLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        mainLabel.textColor = [UIColor colorWithHexString:@"#15315B"];
        mainLabel.text = @"每日打卡";
        _mainLabel = mainLabel;
    }
    return _mainLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH,45,200, 20)];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        detailLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:0.4] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.4]];;
        detailLabel.text = @"每日签到 +15";
        _detailLabel = detailLabel;
    }
    return _detailLabel;
}

- (GotoButton *)gotoButton{
    if (!_gotoButton) {
        GotoButton *gotobutton = [[GotoButton alloc]initWithFrame:CGRectMake(0.781*SCREEN_WIDTH, 30, 66, 28) AndTitle:@"去签到"];
        _gotoButton = gotobutton;
    }
    return _gotoButton;
}

@end
