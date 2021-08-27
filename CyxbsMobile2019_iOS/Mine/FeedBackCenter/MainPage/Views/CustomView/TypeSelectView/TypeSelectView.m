//
//  TypeSelectView.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/25.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "TypeSelectView.h"

@implementation TypeSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
        [self addSubview:self.otherBtn];
        [self addSubview:self.profileProblemBtn];
        [self addSubview:self.recommendBtn];
        [self addSubview:self.systemProblemBtn];
    }
    return self;
}

- (TypeButton *)recommendBtn{
    if (!_recommendBtn) {
        _recommendBtn = [[TypeButton alloc]initWithFrame:CGRectMake(16, 24, 84, 30) AndTitle:@"意见建议"];
        _recommendBtn.delegate = self;
    }
    return _recommendBtn;
}

- (TypeButton *)systemProblemBtn{
    if (!_systemProblemBtn) {
        _systemProblemBtn = [[TypeButton alloc]initWithFrame:CGRectMake(112, 24, 84, 30) AndTitle:@"系统问题"];
    }
    return _systemProblemBtn;
}

- (TypeButton *)profileProblemBtn{
    if (!_profileProblemBtn) {
        _profileProblemBtn = [[TypeButton alloc]initWithFrame:CGRectMake(207, 24, 84, 30) AndTitle:@"账号问题"];
    }
    return _profileProblemBtn;
}

- (TypeButton *)otherBtn{
    if (!_otherBtn) {
        _otherBtn = [[TypeButton alloc]initWithFrame:CGRectMake(302, 24, 56, 30) AndTitle:@"其他"];
    }
    return _otherBtn;
}

- (void)selected:(TypeButton *)sender{
    sender.backgroundColor = [UIColor colorNamed:@"typeBG"];
    [sender setTitleColor:[UIColor colorNamed:@"type"] forState:UIControlStateNormal];
    sender.layer.borderColor = [UIColor colorNamed:@"type"].CGColor;
}

@end
