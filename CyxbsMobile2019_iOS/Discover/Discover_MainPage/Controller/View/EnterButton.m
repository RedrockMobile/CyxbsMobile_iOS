//
//  EnterButton.m
//  testForLargeTitle
//
//  Created by 千千 on 2019/10/22.
//  Copyright © 2019 千千. All rights reserved.
//

#import "EnterButton.h"

@implementation EnterButton
- (instancetype)initWithImageButton:(UIButton *)button label:(UILabel *)label{
    if(self = [super init]){
        self.imageButton = button;
        self.label = label;
        [self addImageButton];
        [self addLabel];
    }
    return self;
}
- (void) addImageButton {
    [self.imageButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.imageButton];
}
- (void) addLabel {
    [self addSubview:self.label];
    self.label.contentMode = UIViewContentModeCenter;
    self.label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    self.label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(self.imageButton.mas_width);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageButton.mas_bottom).offset(2);
        make.centerX.equalTo(self.imageButton);
    }];
    [self.imageButton.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.imageButton);
    }];
}
@end
