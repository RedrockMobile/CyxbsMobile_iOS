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
        if (@available(iOS 11.0, *)) {
            underLine.backgroundColor = [UIColor colorNamed:@"Mine_EditInfo_SeparatorColor"];
        } else {
            underLine.backgroundColor = [UIColor colorWithRed:193/255.0 green:207/255.0 blue:232/255.0 alpha:0.3];
        }
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
