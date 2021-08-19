//
//  PopupView.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/8/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PopupView.h"
#import <Masonry/Masonry.h>
#import "Goods.h"

@implementation PopupView

- (instancetype)initWithFrame:(CGRect)frame AndID:(NSString *)ID {
    self = [super initWithFrame:frame];
    if (self) {
        self.goodsID = ID;
        [self addgrayView];
        [self addwhiteView];
        [self addLabel];
        _is = 1;
//        [self addNoamountButton];
        [self addButton];
    }
    return self;
}

//添加灰色框
- (void)addgrayView {
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self addSubview:grayView];
    _grayView = grayView;
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
    whiteView.layer.cornerRadius = 20;
}
//添加按钮
- (void)addButton {
    [Goods getDataDictWithId:self.goodsID Success:^(NSDictionary * _Nonnull dict) {
        self->_grayView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
        self->_whiteView.backgroundColor = [UIColor whiteColor];
        int amount = [dict[@"amount"] intValue];
            if (amount <= 0) {
                [self addNoamountButton];
                self->_textLabel.text = @"啊哦！手慢了！下次再来吧！";
            }else{
                [self addExchangeButton];
                self->_textLabel.text = [[[[@"确认要用" stringByAppendingString: [NSString stringWithFormat:@"%@",dict[@"price"]]] stringByAppendingString:@"邮票兑换"] stringByAppendingString:dict[@"title"]]stringByAppendingString:@"吗"];
            }
        } failure:^{
            
        }];
}
///没库存按钮
- (void)addNoamountButton {
    UIButton *noamountcomfirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_whiteView addSubview:noamountcomfirmBtn];
    _noamountComfirmBtn = noamountcomfirmBtn;
    noamountcomfirmBtn.frame = CGRectMake(138, 110, 129, 34);
    [noamountcomfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_grayView);
            make.top.equalTo(_whiteView).offset(110);
            make.width.mas_equalTo(129);
            make.height.mas_equalTo(34);
    }];
    noamountcomfirmBtn.layer.cornerRadius = 18;
    noamountcomfirmBtn.backgroundColor = [UIColor colorNamed:@"74_67_228&86_86_242"];
    [noamountcomfirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [noamountcomfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [noamountcomfirmBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
}
///有库存按钮
- (void)addExchangeButton {
    //取消按钮
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancleBtn = cancleBtn;
    [_whiteView addSubview:cancleBtn];
    cancleBtn.frame = CGRectMake(26, 110, 93, 34);
    cancleBtn.layer.cornerRadius = 18;
    cancleBtn.backgroundColor = [UIColor colorNamed:@"195_212_238"];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    //确认按钮
    UIButton *comfirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_whiteView addSubview:comfirmBtn];
    _comfirmBtn = comfirmBtn;
    comfirmBtn.frame = CGRectMake(138, 110, 93, 34);
    comfirmBtn.layer.cornerRadius = 18;
    comfirmBtn.backgroundColor = [UIColor colorNamed:@"74_67_228&86_86_242"];
    [comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comfirmBtn addTarget:self action:@selector(comfirm) forControlEvents:UIControlEventTouchUpInside];
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
}
///移除弹窗
- (void)remove {
    [self removeFromSuperview];
}
///确定
- (void)comfirm {
        
}
@end
