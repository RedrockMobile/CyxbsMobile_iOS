//
//  DLTimeSelectView.m
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "DLTimeSelectView.h"

#define kRateX [UIScreen mainScreen].bounds.size.width/375   //以iPhoneX为基准
#define kRateY [UIScreen mainScreen].bounds.size.height/812  //以iPhoneX为基准
@implementation DLTimeSelectView

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"backgroundColor"];
        } else {
             self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            // Fallback on earlier versions
        }
        self.layer.shadowColor = [UIColor colorWithRed:83/255.0 green:105/255.0 blue:188/255.0 alpha:0.8].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,5);
        self.layer.shadowRadius = 30*kRateY;
        self.layer.shadowOpacity = 1;
        self.layer.cornerRadius = 16*kRateX;
        self.layer.masksToBounds = YES;
        [self initAddButton];
        self.timePiker = [[UIPickerView alloc] init];
//        [self initTimePickerView];
    }
    return self;
}

- (void)initTimePickerView{
//    self.timePiker = [[UIPickerView alloc] init];
    self.frame = CGRectMake(15*kRateX, 0, 285*kRateX, 300*kRateY);
    self.timePiker.backgroundColor = [UIColor clearColor];
    [self addSubview: self.timePiker];
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).mas_offset(15*kRateY);
//        make.left.equalTo(self.mas_left).mas_offset(10*kRateX);
//        make.width.mas_equalTo(285*kRateX);
//        make.height.equalTo(self.mas_height).mas_offset(-30*kRateY);
//    }];
}

- (void)initAddButton{
    UIImageView *addImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timeAddImage"]];
    addImage.layer.cornerRadius = 13*kRateX;
    addImage.layer.masksToBounds = YES;
    addImage.backgroundColor = [UIColor clearColor];
    [self addSubview: addImage];
    [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(114*kRateY);
        make.right.equalTo(self.mas_right).mas_offset(-50*kRateX);
        make.width.mas_equalTo(22*kRateX);
        make.height.mas_equalTo(22*kRateX);
    }];
    self.addButton = [[UIButton alloc] init];
    self.addButton.layer.cornerRadius = 13*kRateX;
    self.addButton.layer.masksToBounds = YES;
    self.addButton.backgroundColor = [UIColor clearColor];
    [self addSubview: self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(114*kRateY);
        make.right.equalTo(self.mas_right).mas_offset(-50*kRateX);
        make.width.mas_equalTo(22*kRateX);
        make.height.mas_equalTo(22*kRateX);
    }];
}
@end
