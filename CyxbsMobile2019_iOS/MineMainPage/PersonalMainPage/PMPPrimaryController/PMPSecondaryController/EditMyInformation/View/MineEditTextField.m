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
