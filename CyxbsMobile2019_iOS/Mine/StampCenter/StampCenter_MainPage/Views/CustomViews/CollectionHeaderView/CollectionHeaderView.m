//
//  CollectionTableView.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/11.
//

#import "CollectionHeaderView.h"
#import "PrefixHeader.pch"
@implementation CollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self addSubview:self.mainLabel];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (UILabel *)mainLabel{
    if (!_mainLabel) {
        UILabel *mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.04*SCREEN_WIDTH, 24, 40, 28)];
        mainLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
        mainLabel.textColor = [UIColor colorNamed:@"#15315B"];
        mainLabel.text = @"装扮";
        _mainLabel = mainLabel;
    }
    return _mainLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.663*SCREEN_WIDTH, 28, 108, 16)];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        detailLabel.textColor = [UIColor colorNamed:@"#15315B66"];
        detailLabel.text = @"请在个人资料里查看";
        _detailLabel = detailLabel;
    }
    return _detailLabel;
}

- (void)setup{
    self.backgroundColor = [UIColor colorNamed:@"#FBFCFF"];
    UIBezierPath  *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame =self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end
