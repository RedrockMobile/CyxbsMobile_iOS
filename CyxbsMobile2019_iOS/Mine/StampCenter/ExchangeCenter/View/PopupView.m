//
//  PopupView.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/8/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PopupView.h"
#import <Masonry/Masonry.h>

@implementation PopupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addgrayView];
        [self addwhiteView];
        [self addButton];
        [self addLabel];
    }
    return self;
}
//添加灰色框
- (void)addgrayView {
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self addSubview:grayView];
    _grayView = grayView;
    grayView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
}
//添加白色框
- (void)addwhiteView {
    UIView *whiteView = [[UIView alloc]init];
    [_grayView addSubview:whiteView];
    _whiteView = whiteView;
    [whiteView  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(255);
                make.height.mas_equalTo(178);
                make.centerX.equalTo(_grayView);
                make.centerY.equalTo(_grayView);
    }];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 20;
}
//添加按钮
- (void)addButton {
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancleBtn = cancleBtn;
    [_whiteView addSubview:cancleBtn];
    cancleBtn.frame = CGRectMake(26, 110, 93, 34);
    cancleBtn.layer.cornerRadius = 18;
    cancleBtn.backgroundColor = [UIColor colorNamed:@"195_212_238"];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *comfirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_whiteView addSubview:comfirmBtn];
    _comfirmBtn = comfirmBtn;
    comfirmBtn.frame = CGRectMake(138, 110, 93, 34);
    comfirmBtn.layer.cornerRadius = 18;
    comfirmBtn.backgroundColor = [UIColor colorNamed:@"74_67_228&86_86_242"];
    [comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
///添加文字框
- (void)addLabel {
    UILabel *textlabel = [[UILabel alloc]init];
    [self.whiteView addSubview:textlabel];
    _textLabel = textlabel;
    [textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_grayView);
            make.top.equalTo(self.whiteView).offset(34);
            make.width.mas_equalTo(200);
    }];
    textlabel.numberOfLines = 0;
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor colorNamed:@"21_49_91"];
    textlabel.font = [UIFont systemFontOfSize:14];
    textlabel.text = @"确认要用100邮票兑换PM名片吗";
}
@end
