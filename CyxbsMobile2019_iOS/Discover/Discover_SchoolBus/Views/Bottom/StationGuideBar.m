//
//  StationGuideBar.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2022/5/15.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "StationGuideBar.h"

@implementation StationGuideBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.runtimeLabel];
        [self addSubview:self.runtypeBtn];
        [self addSubview:self.sendtypeBtn];
        [self addSubview:self.lineBtn];
        self.lineBtn.alpha = 0;
    }
    return self;
}



- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 19, 200, 31)];
        _titleLabel.font = [UIFont fontWithName:PingFangSCBold size: 22];
    }
    return _titleLabel;
}
- (UILabel *)runtimeLabel {
    if (!_runtimeLabel) {
        _runtimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, 160, 17)];
        _runtimeLabel.right = self.right - 16;
        _runtimeLabel.font = [UIFont fontWithName:PingFangSCLight size: 12];
        _runtimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _runtimeLabel;
}
- (UIButton *)sendtypeBtn {
    if (!_sendtypeBtn) {
        _sendtypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 62, 17)];
        _sendtypeBtn.titleLabel.font = [UIFont fontWithName:PingFangSCLight size: 11];
        [_sendtypeBtn setTitleColor: [UIColor colorNamed:@"7_191_225_1"] forState:UIControlStateNormal];
        _sendtypeBtn.backgroundColor = [UIColor colorNamed:@"7_191_225_0.09"];
        _sendtypeBtn.layer.cornerRadius = _sendtypeBtn.height / 2;
        _sendtypeBtn.right = _runtypeBtn.left - 8;
        _sendtypeBtn.top = _runtimeLabel.bottom + 8;
        _sendtypeBtn.userInteractionEnabled = NO;
    }
    return _sendtypeBtn;
}
- (UIButton *)runtypeBtn {
    if (!_runtypeBtn) {
        _runtypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 19)];
        _runtypeBtn.titleLabel.font = [UIFont fontWithName:PingFangSCLight size: 11];
        _runtypeBtn.right = self.right - 16;
        _runtypeBtn.top = _runtimeLabel.bottom + 8;
        _runtypeBtn.userInteractionEnabled = NO;
        _runtypeBtn.layer.cornerRadius = _runtypeBtn.height / 2;
        [_runtypeBtn setTitleColor:[UIColor colorNamed:@"255_69_185_1"] forState:UIControlStateNormal];
        _runtypeBtn.backgroundColor = [UIColor colorNamed:@"255_69_185_0.08"];
    }
    return _runtypeBtn;
}
- (NextStationBtn *)lineBtn {
    if (!_lineBtn) {
        _lineBtn = [[NextStationBtn alloc]initWithFrame:CGRectMake(0, 16, 80, 30)];
        _lineBtn.right = self.right - 10;
        _lineBtn.layer.cornerRadius = 16;    
    }
    return _lineBtn;
}

@end
