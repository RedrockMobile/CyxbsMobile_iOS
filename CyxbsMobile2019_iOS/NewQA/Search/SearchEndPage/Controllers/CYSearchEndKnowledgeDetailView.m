//
//  CYSearchEndKnowledgeDetailView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/3/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "CYSearchEndKnowledgeDetailView.h"


@interface CYSearchEndKnowledgeDetailView()
/// 知识库标题的label
@property (nonatomic, strong) UILabel *titleLbl;
/// 展示内容的Label
@property (nonatomic, strong) UILabel *contentTextLbl;

/// 展示来源的label
@property (nonatomic, strong) UILabel *sourceLabl;

/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;

@end
@implementation CYSearchEndKnowledgeDetailView

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
}

#pragma mark- private methonds
- (void)buildFrame{
    //内容标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"邮问知识库";
    label.font = [UIFont fontWithName:PingFangSCSemibold size:21*fontSizeScaleRate_SE];
    label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(STATUSBARHEIGHT);
    }];
    
   
        //返回的图标
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"返回的小箭头"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(MAIN_SCREEN_W * 0.0427);
//        make.bottom.equalTo(self.view.mas_top).offset(STATUSBARHEIGHT + NVGBARHEIGHT);
        make.centerY.equalTo(label);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.0186, 2 *MAIN_SCREEN_W * 0.0186 ));
    }];
    
    //返回按钮
//    self.backBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.centerY.equalTo(label);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.1, 45 * HScaleRate_SE));
    }];
    
    //底部的分割线
    UIView *bottomDividerView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomDividerView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E3E8ED" alpha:1] darkColor:[UIColor colorWithHexString:@"#343434" alpha:1]];
    [self.view addSubview:bottomDividerView];
    [bottomDividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_top).offset(STATUSBARHEIGHT + NVGBARHEIGHT);
        make.top.equalTo(label.mas_bottom).offset(MAIN_SCREEN_H * 0.018);
        make.height.mas_equalTo(1);
    }];
    
    //titleLbl
    [self.view addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(MAIN_SCREEN_W * 0.0427);
        make.top.equalTo(bottomDividerView).offset(MAIN_SCREEN_H * 0.024);
    }];
    
    
    //ContentTextView
    [self.view addSubview:self.contentTextLbl];
    [self.contentTextLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(MAIN_SCREEN_W * 0.0427);
//        make.centerY.equalTo(self.view);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(MAIN_SCREEN_H * 0.021);
        make.right.equalTo(self.view).offset(- MAIN_SCREEN_W * 0.0427);
    }];
    
}

#pragma mark- event response
- (void)jumpBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- setter
- (void)setModel:(CYSearchEndKnowledgeDetailModel *)model{
    _model = model;
    self.titleLbl.text = model.titleStr;
    self.contentTextLbl.text = model.contentStr;
    
    [self buildFrame];
}

#pragma mark- getter
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLbl.font = [UIFont fontWithName:PingFangSCBold size:16*fontSizeScaleRate_SE];
        titleLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#112C57" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        titleLbl.backgroundColor = [UIColor clearColor];
        //设置字体以及颜色
        _titleLbl = titleLbl;
    }
    return _titleLbl;
}

- (UILabel *)contentTextLbl{
    if (!_contentTextLbl) {
        UILabel *contentTextView = [[UILabel alloc] initWithFrame:CGRectZero];
        contentTextView.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#556C89" alpha:1] darkColor:[UIColor colorWithHexString:@"#B5B5B5" alpha:1]];
        contentTextView.font = [UIFont fontWithName:PingFangSCMedium size:13*fontSizeScaleRate_SE];
        contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextLbl = contentTextView;
        _contentTextLbl.preferredMaxLayoutWidth = MAIN_SCREEN_W * (1 - 0.0427*2);
        _contentTextLbl.numberOfLines = 0;
//        _contentTextLbl.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
    }
    return _contentTextLbl;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_backBtn addTarget:self action:@selector(jumpBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}


@end
