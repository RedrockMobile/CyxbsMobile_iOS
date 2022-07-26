//
//  IgnoreTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/12/18.
//  Copyright © 2020 Redrock. All rights reserved.
//  屏蔽的人页面的cell

#import "IgnoreTableViewCell.h"

@interface IgnoreTableViewCell()
@property(nonatomic, strong)UIView *separateLine;
@property(nonatomic, strong)IgnoreDataModel *model;
@property(nonatomic, strong)UIButton *cancelBtn;
@property(nonatomic, strong)UIImageView *headImgView;
@property(nonatomic, strong)UILabel *nickNameLabel;
@property(nonatomic, strong)UILabel *mottoLabel;

@end
@implementation IgnoreTableViewCell

- (instancetype)init{
    self = [self initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"IgnoreTableViewCell"];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [self addHeadImgView];
        [self addCancelBtn];
        [self addNickNameAndMottoLabel];
        [self addSeparateLine];
    }
    return self;
}

- (void)setDataWithDataModel:(IgnoreDataModel *)model {
    self.model = model;
    self.nickNameLabel.text = model.nickName;
    self.mottoLabel.text = model.introduction;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
}

- (void)addHeadImgView {
    UIImageView *imgView = [[UIImageView alloc] init];
    self.headImgView = imgView;
    [self.contentView addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.0427*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.0533*SCREEN_WIDTH);
        make.width.height.mas_equalTo(0.128*SCREEN_WIDTH);
    }];
    imgView.layer.cornerRadius = 0.064*SCREEN_WIDTH;
    imgView.clipsToBounds = YES;
}

- (void)addNickNameAndMottoLabel {
    UILabel *label;
    UIView *backView = [[UIView alloc] init];
    [self.contentView addSubview:backView];
    
    //++++++++++++++++++设置用户昵称label++++++++++++++++++++  Begain
    label = [[UILabel alloc] init];
    [backView addSubview:label];
    self.nickNameLabel = label;
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.top.equalTo(backView);
    }];
    
    label.font = [UIFont fontWithName:PingFangSCMedium size:15*fontSizeScaleRate_SE];
    
    //++++++++++++++++++设置用户昵称label++++++++++++++++++++  End
    
    
    //++++++++++++++++++设置用户个性签名labe++++++++++++++++++++  Begain
    label = [[UILabel alloc] init];
    self.mottoLabel = label;
    [backView addSubview:label];
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"116_139_176&131_131_132"];
    } else {
        label.textColor = [UIColor colorWithRed:116/255.0 green:139/255.0 blue:176/255.0 alpha:1];
    }
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(2*HScaleRate_SE);
        make.bottom.equalTo(backView);
    }];
    
    label.font = [UIFont fontWithName:PingFangSCRegular size:11*fontSizeScaleRate_SE];
    
    //++++++++++++++++++设置用户个性签名label++++++++++++++++++++  End
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0.188*SCREEN_WIDTH);
        make.centerY.equalTo(self.headImgView);
        make.width.mas_equalTo(30);
    }];
    
//    backView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
}
- (void)addCancelBtn{
    UIButton *btn = [[UIButton alloc] init];
    [self.contentView addSubview:btn];
    self.cancelBtn = btn;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-0.0427*MAIN_SCREEN_W);
        make.top.equalTo(self.contentView).offset(0.084*MAIN_SCREEN_W);
        make.width.mas_equalTo(0.2387*SCREEN_WIDTH*WScaleRate_SE);
        make.height.mas_equalTo(0.0747*SCREEN_WIDTH*HScaleRate_SE);
    }];
    
    btn.layer.cornerRadius = 0.03735*SCREEN_WIDTH*HScaleRate_SE;
    
    [btn setTitle:@"取消屏蔽" forState:UIControlStateNormal];
    
    [btn.titleLabel setFont:[UIFont fontWithName:PingFangSCBold size:13*fontSizeScaleRate_SE]];
    
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
   
    btn.backgroundColor = [UIColor colorWithRed:93/255.0 green:94/255.0 blue:246/255.0 alpha:1];
    
    
    [btn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
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
        [[HttpClient defaultClient] requestWithPath:Mine_POST_cancelIgnorePeople_API method:HttpRequestPost parameters:@{@"uid":self.model.uid} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.cancelBtn setTitle:@"屏蔽" forState:UIControlStateNormal];
            [NewQAHud showHudWith:@"已成功解除对该用户的屏蔽～" AddView:self.viewController.view];
            [self.cancelBtn setEnabled:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [NewQAHud showHudWith:@"网络错误" AddView:self.viewController.view];
        }];
    }else {
        [[HttpClient defaultClient] requestWithPath:Mine_POST_ignorePeople_API method:HttpRequestPost parameters:@{@"uid":self.model.uid} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.cancelBtn setTitle:@"取消屏蔽" forState:UIControlStateNormal];
            [NewQAHud showHudWith:@"屏蔽成功～" AddView:self.viewController.view];
            [self.cancelBtn setEnabled:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [NewQAHud showHudWith:@"网络错误" AddView:self.viewController.view];
        }];
    }
    
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//}

@end
