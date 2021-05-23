//
//  CYRleaseSaveDraftAlertBtn.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/3/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "CYRleaseSaveDraftAlertBtn.h"

@implementation CYRleaseSaveDraftAlertBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor yellowColor];
        _textLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLbl.font = [UIFont fontWithName:PingFangSCBold size:15];
        [self addSubview:_textLbl];
        [_textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

@end
