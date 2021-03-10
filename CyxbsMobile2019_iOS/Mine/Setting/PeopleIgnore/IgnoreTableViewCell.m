//
//  IgnoreTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/12/18.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IgnoreTableViewCell.h"
#import "NewQAHud.h"
#define CJHcancelInorePeopel @"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/ignore/cancelIgnoreUid"

#define CJHinorePeopel @"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/ignore/addIgnoreUid"
@interface IgnoreTableViewCell()
@property(nonatomic, strong)UIView *separateLine;
@property(nonatomic, strong)IgnoreDataModel *model;
@property(nonatomic, strong)UIButton *cancelBtn;
@end
@implementation IgnoreTableViewCell

- (instancetype)init{
    self = [self initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"IgnoreTableViewCell"];
    if (self) {
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0.0427*SCREEN_WIDTH);
            make.top.equalTo(self).offset(0.0533*SCREEN_WIDTH);
            make.width.height.mas_equalTo(0.128*SCREEN_WIDTH);
        }];
        self.imageView.layer.cornerRadius = 0.064*SCREEN_WIDTH;
        self.imageView.clipsToBounds = YES;
        self.backgroundColor = UIColor.clearColor;
        
        [self addCancelBtn];
        [self setTextLabel];
        [self setDetailTextLabel];
        [self addSeparateLine];
        [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    }
    return self;
}
- (void)setDataWithDataModel:(IgnoreDataModel *)model {
    self.model = model;
    self.textLabel.text = model.nickName;
    self.detailTextLabel.text = model.introduction;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
}
- (void)addCancelBtn{
    UIButton *btn = [[UIButton alloc] init];
    [self.contentView addSubview:btn];
    self.cancelBtn = btn;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-0.0427*MAIN_SCREEN_W);
        make.top.equalTo(self.contentView).offset(0.084*MAIN_SCREEN_W);
        make.width.mas_equalTo(0.2387*SCREEN_WIDTH);
        make.height.mas_equalTo(0.0747*SCREEN_WIDTH);
    }];
    
    [btn setTitle:@"取消屏蔽" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    
    if (@available(iOS 11.0, *)) {
        btn.backgroundColor = [UIColor colorNamed:@"93_93_247&85_77_250"];
    } else {
        btn.backgroundColor = [UIColor colorWithRed:93/255.0 green:93/255.0 blue:247/255.0 alpha:1];
    }
    
    btn.layer.cornerRadius = 0.03735*SCREEN_WIDTH;
    
    [btn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}
/// 设置用户昵称label的方法
- (void)setTextLabel{
    UILabel *label = self.textLabel;
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0.188*SCREEN_WIDTH);
        make.top.equalTo(self.mas_top).offset(0.0747*SCREEN_WIDTH);
    }];
    
    label.font = [UIFont fontWithName:PingFangSCHeavy size:15];
}
/// 设置用户个性签名label的方法
- (void)setDetailTextLabel{
    UILabel *label = self.detailTextLabel;
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"116_139_176&131_131_132"];
    } else {
        label.textColor = [UIColor colorWithRed:116/255.0 green:139/255.0 blue:176/255.0 alpha:1];
    }
    
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
    [self.cancelBtn setEnabled:NO];
    if ([self.cancelBtn.titleLabel.text isEqualToString:@"取消屏蔽"]) {
        [[HttpClient defaultClient] requestWithPath:CJHcancelInorePeopel method:HttpRequestPost parameters:@{@"uid":self.model.uid} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.cancelBtn setTitle:@"屏蔽" forState:UIControlStateNormal];
            [NewQAHud showHudWith:@"已成功解除对该用户的屏蔽～" AddView:self.viewController.view];
            [self.cancelBtn setEnabled:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [NewQAHud showHudWith:@"网络错误" AddView:self.viewController.view];
        }];
    }else {
        [[HttpClient defaultClient] requestWithPath:CJHinorePeopel method:HttpRequestPost parameters:@{@"uid":self.model.uid} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.cancelBtn setTitle:@"取消屏蔽" forState:UIControlStateNormal];
            [NewQAHud showHudWith:@"屏蔽成功～" AddView:self.viewController.view];
            [self.cancelBtn setEnabled:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [NewQAHud showHudWith:@"网络错误" AddView:self.viewController.view];
        }];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
