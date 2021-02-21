//
//  IgnoreTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/12/18.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IgnoreTableViewCell.h"


@interface IgnoreTableViewCell()
@property(nonatomic, strong)UIView *separateLine;
@end
@implementation IgnoreTableViewCell

- (instancetype)init{
    self = [self initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"IgnoreTableViewCell"];
    if (self) {
        [self.imageView setImage:[UIImage imageNamed:@"编辑资料问号"]];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0.0427*SCREEN_WIDTH);
            make.top.equalTo(self).offset(0.0533*SCREEN_WIDTH);
            make.width.height.mas_equalTo(0.128*SCREEN_WIDTH);
        }];
        
        self.backgroundColor = UIColor.clearColor;
        
        self.accessoryView = [self getCancelBtn];
        [self setTextLabelWithStrWithStr:@"用户昵称"];
        [self setDetailTextLabelWithStr:@"用户个性签名"];
        [self addSeparateLine];
        [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    }
    return self;
}

- (UIButton*)getCancelBtn{
    UIButton *btn = [[UIButton alloc] init];
    
    btn.frame = CGRectMake(0, 0, 0.2387*SCREEN_WIDTH, 0.0747*SCREEN_WIDTH);
    
    [btn setTitle:@"取消屏蔽" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    
    if (@available(iOS 11.0, *)) {
        btn.backgroundColor = [UIColor colorNamed:@"93_93_247&85_77_250"];
    } else {
        btn.backgroundColor = [UIColor colorWithRed:93/255.0 green:93/255.0 blue:247/255.0 alpha:1];
    }
    
    btn.layer.cornerRadius = 0.03735*SCREEN_WIDTH;
    
    [btn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
/// 设置用户昵称label的方法
- (void)setTextLabelWithStrWithStr:(NSString*)str{
    UILabel *label = self.textLabel;
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    
    label.text = str;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0.188*SCREEN_WIDTH);
        make.top.equalTo(self.mas_top).offset(0.0747*SCREEN_WIDTH);
    }];
    
    label.font = [UIFont fontWithName:PingFangSCHeavy size:15];
}
/// 设置用户个性签名label的方法
- (void)setDetailTextLabelWithStr:(NSString*)str{
    UILabel *label = self.detailTextLabel;
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"116_139_176&131_131_132"];
    } else {
        label.textColor = [UIColor colorWithRed:116/255.0 green:139/255.0 blue:176/255.0 alpha:1];
    }
    
    label.text = str;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0.1867*SCREEN_WIDTH);
        make.top.equalTo(self.mas_top).offset(0.1373*SCREEN_WIDTH);
    }];
    
    label.font = [UIFont fontWithName:PingFangSCMedium size:11];
}
/// 添加 底部分隔线 的方法
- (void)addSeparateLine{
    UIView *view = [[UIView alloc] init];
    self.separateLine = view;
    [self addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    if (@available(iOS 11.0, *)) {
        view.backgroundColor = [UIColor colorNamed:@"45_45_45_20&230_230_230_40"];
    } else {
        view.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:0.64];
    }
}

/// 点击 取消屏蔽按钮 后调用的方法
- (void)cancelBtnClicked{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
