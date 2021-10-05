//
//  SecondHeaderView.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/11.
//

#import "SecondHeaderView.h"
#import "PrefixHeader.pch"
@implementation SecondHeaderView
- (UILabel *)mainLabel{
    if (!_mainLabel) {
        UILabel *mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.04*SCREEN_WIDTH, 14, 40, 28)];
        mainLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
        mainLabel.textColor = [UIColor colorNamed:@"#15315B"];
        mainLabel.text = @"邮货";
        _mainLabel = mainLabel;
    }
    return _mainLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.63*SCREEN_WIDTH, 18, 140, 16)];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        detailLabel.textColor = [UIColor colorNamed:@"#15315B66"];
        detailLabel.text = @"需要到红岩网校领取哦";
        _detailLabel = detailLabel;
    }
    return _detailLabel;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [self addSubview:self.detailLabel];
    [self addSubview:self.mainLabel];
}

@end
