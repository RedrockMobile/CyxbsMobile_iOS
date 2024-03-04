//
//  TopBlurView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MineTopBlurView.h"
#define YOUSHE @"YouSheBiaoTiHei"

@interface MineTopBlurView ()
@property (nonatomic, strong)UIView *headWhiteEdgeView;
@end

@implementation MineTopBlurView

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.9066666667*SCREEN_WIDTH);
            make.height.mas_equalTo(0.5546666667*SCREEN_WIDTH);
        }];
        [self addBlurImgView];
        [self addHeadImgBtn];
        [self addBackview];
//        [self addBlogBtn];
//        [self addRemarkBtn];
//        [self addPraiseBtn];
        [self addHomePageBtn];
    }
    return self;
}

- (void)addBlurImgView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mineBackImgBlur"]];
    self.blurImgView = imgView;
    [self addSubview:imgView];
    
    imgView.layer.shadowOffset = CGSizeMake(0, -0.005997001499*SCREEN_HEIGHT);
    imgView.layer.shadowColor = RGBColor(46, 89, 152, 0.05).CGColor;
    imgView.layer.shadowOpacity = 1;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)addHeadImgBtn {
    //++++++++++++++++++添加头像的背景板++++++++++++++++++++  Begain
    UIView *whiteEdgeView = [[UIView alloc] init];
    [self addSubview:whiteEdgeView];
    self.headWhiteEdgeView = whiteEdgeView;
    
    whiteEdgeView.backgroundColor = [UIColor whiteColor];
    whiteEdgeView.layer.cornerRadius = 0.08533333333*SCREEN_WIDTH;
    whiteEdgeView.clipsToBounds = YES;
    
    [whiteEdgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.03466666667*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.096*SCREEN_WIDTH);
        make.width.height.equalTo(@(0.1706666667*SCREEN_WIDTH));
    }];
    //++++++++++++++++++添加头像的背景板++++++++++++++++++++  End
    
    //++++++++++++++++++添加头像按钮++++++++++++++++++++  Begain
    UIButton *btn = [[UIButton alloc] init];
    [whiteEdgeView addSubview:btn];
    self.headImgBtn = btn;
    
    btn.clipsToBounds = YES;
    [btn setImage:[UIImage imageNamed:@"cat"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 0.08*SCREEN_WIDTH;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(whiteEdgeView);
        make.width.height.equalTo(@(0.16*SCREEN_WIDTH));
    }];
    //++++++++++++++++++添加头像按钮++++++++++++++++++++  End
}

- (void)addBackview {
    //++++++++++++++++++添加姓名label++++++++++++++++++++  Begain
    UILabel *realNameLabel = [[UILabel alloc] init];
    [self addSubview:realNameLabel];
    self.realNameLabel = realNameLabel;
    
    realNameLabel.font = [UIFont boldSystemFontOfSize:22];
    realNameLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B"] darkColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    [realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgBtn.mas_right).offset(0.01866666667*SCREEN_WIDTH);
        make.centerY.equalTo(self.headWhiteEdgeView);
        make.width.lessThanOrEqualTo(@(0.5*SCREEN_WIDTH));
    }];
    
    //++++++++++++++++++添加昵称label++++++++++++++++++++  End
    
    
    //++++++++++++++++++添加快来红岩网校和我一起玩吧⁓的label++++++++++++++++++++  Begain
    UILabel *introductionLabel = [[UILabel alloc] init];
    [self addSubview:introductionLabel];
    self.mottoLabel = introductionLabel;
    introductionLabel.font = [UIFont boldSystemFontOfSize:15];
    introductionLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B"] darkColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    introductionLabel.numberOfLines = 2;
    [self.mottoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headWhiteEdgeView.mas_left).offset(10);
        make.top.equalTo(realNameLabel.mas_bottom).offset(0.04679802955665*SCREEN_HEIGHT);
        make.width.lessThanOrEqualTo(@(0.6*SCREEN_WIDTH));
    }];
    //++++++++++++++++++添加快来红岩网校和我一起玩吧⁓的label++++++++++++++++++++  End
    
//    nicknameLabel.text = @"鱼鱼鱼鱼鱼鱼鱼鱼1";
//    introductionLabel.text = @"这是一条不普通的签名这是一条不普通的给这是一条不普通的签名这是一条不普通的给";
    
}

//- (void)addBlogBtn {
//    MainPageNumBtn *btn = [[MainPageNumBtn alloc] init];
//    [self addSubview:btn];
//    self.blogBtn = btn;
//    
//    btn.hideTipView = YES;
//    
//    //按钮标题，用来显示动态/评论/获赞的总数
////    [btn setTitle:@"9999" forState:UIControlStateNormal];
//    
//    //按钮的名字
//    btn.btnNameLabel.text = @"动态";
//    
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).mas_equalTo(0.03466666667*SCREEN_WIDTH);
//        make.top.equalTo(self).mas_equalTo(0.336*SCREEN_WIDTH);
//    }];
//}


//- (void)addRemarkBtn {
//    MainPageNumBtn *btn = [[MainPageNumBtn alloc] init];
//    [self addSubview:btn];
//    self.remarkBtn = btn;
//    
//    btn.hideTipView = YES;
//    
//    //按钮标题，用来显示动态/评论/获赞的总数
////    [btn setTitle:@"9999" forState:UIControlStateNormal];
//    
//    //按钮的名字
//    btn.btnNameLabel.text = @"评论";
//    
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.blogBtn.mas_right).offset(0.128*SCREEN_WIDTH);
//        make.top.mas_equalTo(0.336*SCREEN_WIDTH);
//    }];
//}

//- (void)addPraiseBtn {
//    MainPageNumBtn *btn = [[MainPageNumBtn alloc] init];
//    [self addSubview:btn];
//    self.praiseBtn = btn;
//    
//    btn.hideTipView = YES;
//    
//    //按钮标题，用来显示动态/评论/获赞的总数
////    [btn setTitle:@"9999" forState:UIControlStateNormal];
//    
//    //按钮的名字
//    btn.btnNameLabel.text = @"获赞";
//    
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.remarkBtn.mas_right).offset(0.128*SCREEN_WIDTH);
//        make.top.mas_equalTo(0.336*SCREEN_WIDTH);
//    }];
//}
- (void)addHomePageBtn {
    UIButton *btn = [[UIButton alloc] init];
    self.homePageBtn = btn;
    [self addSubview:btn];
    
    [btn setImage:[UIImage imageNamed:@"btn2homePage"] forState:UIControlStateNormal];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0.152*SCREEN_WIDTH);
        make.right.equalTo(self).offset(-0.04666666667*SCREEN_WIDTH);
    }];
}
@end
