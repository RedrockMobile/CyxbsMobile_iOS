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
   [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:0.6];
    if (@available(iOS 11.0, *)) {
         self.label.textColor =[UIColor colorNamed:@"color21_49_91_&#8c8c8c" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(self.imageButton.mas_width);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageButton.mas_bottom);
        make.centerX.equalTo(self.imageButton);
    }];
    [self.imageButton.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.imageButton);
    }];
}
@end
