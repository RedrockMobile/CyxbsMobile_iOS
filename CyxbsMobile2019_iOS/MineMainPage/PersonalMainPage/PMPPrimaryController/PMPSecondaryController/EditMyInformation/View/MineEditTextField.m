//
//  MineEditTextField.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "MineEditTextField.h"

@interface MineEditTextField ()

@property (nonatomic, weak) UIView *underLine;

@end

@implementation MineEditTextField

- (instancetype)init
{
    self = [super init];
    /*由于掌邮迭代后社交属性减弱，资料详情界面不再用于显示昵称、个性签名等，原可修改的一些东西换成了
     固定展示的姓名、学号等内容，因此默认设置这个TextField不再可被用户交互*/
    self.enabled = NO;
    self.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B"] darkColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    self.font = [UIFont fontWithName:PingFangSCRegular size:15];
    if (self) {
        UIView *underLine = [[UIView alloc] init];
        underLine.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#BDCCE5" alpha:0.18] darkColor:[UIColor colorWithHexString:@"#56556A" alpha:0.16]];
        [self addSubview:underLine];
        self.underLine = underLine;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@1.3);
    }];
}



@end
