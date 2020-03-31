//
//  QADetailView.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QADetailView.h"
#import "QADetailAnswerListView.h"
@implementation QADetailView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height);
//    NSLog(@"%@",NSStringFromCGRect(frame));
    [self addSubview:self.scrollView];
    return self;
    
}
- (void)layoutSubviews{
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
}
- (void)setupUIwithDic:(NSDictionary *)dic answersData:(nonnull NSArray *)answersData{
    UIView *userInfoView = [[UIView alloc]init];
    userInfoView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:userInfoView];
    
    UIImageView *userIcon = [[UIImageView alloc]init];
    NSString *userIconUrl = [dic objectForKey:@"photo_thumbnail_src"];
    [userIcon setImageWithURL:[NSURL URLWithString:userIconUrl] placeholder:[UIImage imageNamed:@"userIcon"]];
    [userInfoView addSubview:userIcon];
    
    UILabel *userNameLabel = [[UILabel alloc]init];
    userNameLabel.font = [UIFont fontWithName:PingFangSCBold size:15];
    [userNameLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    [userNameLabel setText:[dic objectForKey:@"nickname"]];
    [userInfoView addSubview:userNameLabel];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.font = [UIFont fontWithName:PingFangSCRegular size:11];
    [dateLabel setTextColor:[UIColor colorWithHexString:@"#2A4E84"]];
    NSString *date = [dic objectForKey:@"disappear_at"];
    [dateLabel setText:[date substringWithRange:NSMakeRange(0, 10)]];
    [userInfoView addSubview:dateLabel];
    
    UIImageView *integralIcon = [[UIImageView alloc]init];
    [integralIcon setImage:[UIImage imageNamed:@"integralIcon2"]];
    [userInfoView addSubview:integralIcon];
    
    UILabel *integralNumLabel = [[UILabel alloc]init];
    NSString *integralNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"reward"]];
    [integralNumLabel setText:integralNum];
    integralNumLabel.font = [UIFont fontWithName:PingFangSCRegular size:11];
    [integralNumLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    [userInfoView addSubview:integralNumLabel];
    
    [userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.top.mas_equalTo(self.scrollView.mas_top);
        make.width.equalTo(@SCREEN_WIDTH);
        make.height.equalTo(@57);
    }];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userInfoView).mas_offset(16);
        make.top.equalTo(userInfoView).mas_offset(16);
        make.height.width.equalTo(@40);
    }];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userIcon.mas_right).mas_offset(14);
        make.top.mas_equalTo(userIcon.mas_top);
    }];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameLabel);
        make.bottom.equalTo(userIcon);
        //        make.height.equalTo(@57);
    }];
    [integralIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(userInfoView.mas_right).mas_offset(-33);
        make.top.mas_equalTo(userInfoView.mas_top).mas_offset(33);
        make.height.width.mas_equalTo(17);
        //        make.height.equalTo(@57);
    }];
    [integralNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(integralIcon.mas_right).mas_offset(3);
        make.centerY.equalTo(integralIcon);
    }];
    //    UILabel *contentLabel = [[UILabel alloc]init];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    NSString *content = [dic objectForKey:@"description"];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName: [UIFont fontWithName:PingFangSCRegular size: 15], NSForegroundColorAttributeName: [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]}];
    
    contentLabel.attributedText = string;
    contentLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    contentLabel.alpha = 1.0;
    
    [self.scrollView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.mas_left).mas_offset(20);
        make.top.mas_equalTo(userInfoView.mas_bottom).mas_offset(5);
    }];
    
    
    UIView *separateView = [[UIView alloc]init];
    separateView.backgroundColor = [UIColor colorWithHexString:@"#2A4E84"];
    separateView.alpha = 0.1;
    [self.scrollView addSubview:separateView];
    
    
    NSArray *imgUrlArray = [dic objectForKey:@"photo_url"];
    if (imgUrlArray.count != 0) {
        
        //    NSArray *imgUrlArray = @[@"http://img.wenjiwu.com/life/201704/9-1F422105602357.png"];
        UIImageView *imgView = [[UIImageView alloc]init];
        NSString *urlString = [NSString stringWithFormat:@"%@",imgUrlArray[0]];
        NSURL *url = [NSURL URLWithString:urlString];
        [imgView setImageWithURL:url placeholder:[UIImage imageNamed:@"userIcon"]];
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(14);
            make.right.mas_equalTo(self.scrollView.mas_right).mas_offset(-20);
            make.left.mas_equalTo(self.scrollView.mas_left).mas_offset(20);
            make.height.mas_equalTo(@200);
        }];
        [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(0);
            make.left.mas_equalTo(self.mas_left).mas_offset(0);
            make.top.mas_equalTo(imgView.mas_bottom).mas_offset(20);
            make.height.mas_equalTo(1);
        }];
    }else{
        [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(0);
            make.left.mas_equalTo(self.mas_left).mas_offset(0);
            make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(20);
            make.height.mas_equalTo(1);
        }];
    }
    UILabel *answerLabel = [[UILabel alloc]init];
    answerLabel.text = @"回复";
    [answerLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    answerLabel.font = [UIFont fontWithName:PingFangSCBold size:18];
    [self.scrollView addSubview:answerLabel];

    [answerLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(separateView.mas_bottom).mas_offset(14);
        make.right.mas_equalTo(self.scrollView.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.scrollView.mas_left).mas_offset(20);
    }];
    self.answerButton = [[UIButton alloc]init];
    self.answerButton.backgroundColor = [UIColor colorWithHexString:@"#4841E2"];
    [self.answerButton setTitle:@"回答" forState:UIControlStateNormal];
    [self.answerButton.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18]];
    self.answerButton.layer.cornerRadius = 20;
 
    [self addSubview:self.answerButton];
    [self.answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-60);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(120);
    }];
    NSNumber *isSelf = [dic objectForKey:@"is_self"];
    if (isSelf.integerValue == 0) {
        self.isSelf = NO;
    }else{
        self.isSelf = YES;
    }
    //加载回答列表
    NSArray *answerList = answersData;
    UIView *view = [[UIView alloc]init];
    [self.scrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(answerLabel.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self.mas_right).mas_offset(0);
        make.left.mas_equalTo(self.mas_left).mas_offset(0);
        make.height.mas_equalTo(answerList.count*190);
    }];
    for (int i=0;i<answerList.count; i++) {
        NSDictionary *dic = answerList[i];
        QADetailAnswerListView *answerView = [[QADetailAnswerListView alloc]initWithFrame:CGRectMake(0, 190*i, SCREEN_WIDTH, 190)];
        [answerView setupView:dic isSelf:self.isSelf];
        [view addSubview:answerView];
    }
    
}

- (void)replyComment:(UIButton *)sender{
    [self.delegate replyComment:[NSNumber numberWithInteger:sender.tag]];
}

- (void)tapCommentBtn:(UIButton *)sender{
    [self.delegate tapCommentBtn:[NSNumber numberWithInteger:sender.tag]];
}

- (void)tapPraiseBtn:(UIButton *)sender{
    [self.delegate tapPraiseBtn:sender answerId:[NSNumber numberWithInteger:sender.tag]];
    sender.selected = !sender.selected;
}
- (void)tapAdoptBtn:(UIButton *)sender{
    [self.delegate tapAdoptBtn:[NSNumber numberWithInteger:sender.tag]];
    sender.selected = !sender.selected;
}
@end
