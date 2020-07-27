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
//    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height);
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //    NSLog(@"%@",NSStringFromCGRect(frame));
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.bottom.equalTo(self);
    }];
    return self;
    
}
- (void)layoutSubviews{
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1500);
}
- (void)setupUIwithDic:(NSDictionary *)dic answersData:(nonnull NSArray *)answersData{
    UIView *userInfoView = [[UIView alloc]init];
    userInfoView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:userInfoView];
    
    UIImageView *userIcon = [[UIImageView alloc]init];
    userIcon.layer.cornerRadius = 20;
    userIcon.layer.masksToBounds = YES;
    NSString *userIconUrl = [dic objectForKey:@"photo_thumbnail_src"];
    [userIcon setImageWithURL:[NSURL URLWithString:userIconUrl] placeholder:[UIImage imageNamed:@"默认头像"]];
    [userInfoView addSubview:userIcon];
    
    UILabel *userNameLabel = [[UILabel alloc]init];
    userNameLabel.font = [UIFont fontWithName:PingFangSCBold size:15];
    [userNameLabel setText:[dic objectForKey:@"nickname"]];
    [userInfoView addSubview:userNameLabel];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.font = [UIFont fontWithName:PingFangSCRegular size:11];
    NSString *date = [dic objectForKey:@"created_at"];
    [dateLabel setText:[date substringWithRange:NSMakeRange(0, 10)]];
    [userInfoView addSubview:dateLabel];
    
    UIImageView *integralIcon = [[UIImageView alloc]init];
    NSInteger hasAdoptedAnswer = [[dic objectForKey:@"hasAdoptedAnswer"] intValue];
    if (hasAdoptedAnswer > 0) {
        [integralIcon setImage:[UIImage imageNamed:@"integralIcon2"]];
    }else{
        [integralIcon setImage:[UIImage imageNamed:@"integralIcon"]];
    }
    [userInfoView addSubview:integralIcon];
    
    UILabel *integralNumLabel = [[UILabel alloc]init];
    NSString *integralNum = [NSString stringWithFormat:@"%@积分",[dic objectForKey:@"reward"]];
    [integralNumLabel setText:integralNum];
    integralNumLabel.font = [UIFont fontWithName:PingFangSCRegular size:11];
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
        make.right.mas_equalTo(userInfoView.mas_right).mas_offset(-40);
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
contentLabel.text = content;
    [contentLabel setFont:[UIFont fontWithName:PingFangSCRegular size:15]];
    contentLabel.alpha = 1.0;
    
    [self.scrollView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.mas_left).mas_offset(20);
        make.top.mas_equalTo(userInfoView.mas_bottom).mas_offset(5);
    }];
    
    if (@available(iOS 11.0, *)) {
        userNameLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        dateLabel.textColor = [UIColor colorNamed:@"QAListAnswerLableColor"];
        integralNumLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        contentLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
    } else {
        [userNameLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
        [dateLabel setTextColor:[UIColor colorWithHexString:@"#2A4E84"]];
        [integralNumLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
        contentLabel.textColor = [UIColor colorWithHexString:@"#15315B"];
    }
    
    
    UIView *separateView = [[UIView alloc]init];
    separateView.backgroundColor = [UIColor colorWithHexString:@"#2A4E84"];
    separateView.alpha = 0.1;
    [self.scrollView addSubview:separateView];
    
    self.imageUrlArray = [dic objectForKey:@"photo_url"];
    NSInteger count = self.imageUrlArray.count;
    NSInteger width;
    NSInteger height;
    if (count <= 3) {
        width = (SCREEN_WIDTH - 40)/count;
        height = width * 0.6;
    }else{
        width = (SCREEN_WIDTH - 60)/3;
        height = width;
    }
    if (self.imageUrlArray.count != 0) {
        
        for (int i = 0; i < self.imageUrlArray.count; i++) {

            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.layer.cornerRadius = 8;
            imgView.clipsToBounds = YES;
            NSString *urlString = [NSString stringWithFormat:@"%@",self.imageUrlArray[i]];
            NSURL *url = [NSURL URLWithString:urlString];
            [imgView setImageURL:url];
            imgView.userInteractionEnabled = YES;
            //添加点击手势
//            UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToViewBigImage:)];
//            [imgView addGestureRecognizer:tapGesture];
            [self.scrollView addSubview:imgView];
            UIButton *imageBtn = [[UIButton alloc]init];
            imageBtn.tag = i;
            imageBtn.backgroundColor = UIColor.clearColor;
            [imageBtn addTarget:self action:@selector(tapToViewBigImage:) forControlEvents:UIControlEventTouchUpInside];
            // 图片多余6个时，最后一个按钮显示“+n”
            if (self.imageUrlArray.count > 6 && i == 5) {
                imageBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50];
                [imageBtn setTitle:[NSString stringWithFormat:@"%lu+", (unsigned long)self.imageUrlArray.count - 5] forState:UIControlStateNormal];
                imageBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:30];
                imageBtn.layer.cornerRadius = 8;
            }
            [self.scrollView addSubview:imageBtn];
            
//            [self.imageViewArray addObject:imgView];
            if (i<=2&&i>=0) {

                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).mas_offset(20+(width+10)*i);
                    make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(10);
                    make.width.mas_equalTo(width);
                    make.height.mas_equalTo(height);

                }];
                [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo(imgView);

                }];

            }else if (i>=3&&i<=5){

                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).mas_offset(20+(width+10)*(i-3));
                    make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(width + 20);
                    make.width.mas_equalTo(width);
                    make.height.mas_equalTo(height);

                }];
                [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo(imgView);

                }];

            }else{

            }
        }
        [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.right.mas_equalTo(self.mas_right).mas_offset(0);
                           make.left.mas_equalTo(self.mas_left).mas_offset(0);
                           make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(250);
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

    if (@available(iOS 11.0, *)) {
        answerLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
    } else {
        answerLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    }

  
    NSNumber *isSelf = [dic objectForKey:@"is_self"];
    if (isSelf.integerValue == 0) {
        self.isSelf = NO;
    }else{
        self.isSelf = YES;
    }
    //如果不是自己提的问题，显示回答按钮
    if (!self.isSelf) {
        
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
    }
    //加载回答列表
    NSArray *answerList = answersData;
//    UIView *view = [[UIView alloc]init];
//    [self.scrollView addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.mas_equalTo(answerLabel.mas_bottom).mas_offset(5);
//        make.right.mas_equalTo(self.mas_right).mas_offset(0);
//        make.left.mas_equalTo(self.mas_left).mas_offset(0);
//        make.height.mas_equalTo(answerList.count*190);
//    }];
    //判断h是否有回答
    if (answerList.count != 0) {
        CGFloat answerViewY = 0;
        for (int i=0;i<answerList.count; i++) {
            NSDictionary *dic = answerList[i];
            NSString *content = [dic objectForKey:@"content"];
            CGFloat fontsize = 17;
            CGFloat labelWidth = SCREEN_WIDTH - 90 - 1;
            CGFloat labelHeight = [self calculateLabelHeight:content width:labelWidth fontsize:fontsize];
            CGFloat answerViewHeight = labelHeight + 135;
            QADetailAnswerListView *answerView = [[QADetailAnswerListView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, answerViewHeight)];
            [answerView setupView:dic isSelf:self.isSelf];
//            NSLog(@"%lD",(long)[answerView getViewHeight]);
            [self.scrollView addSubview:answerView];
            
        
            if (i == 0) {

                [answerView mas_makeConstraints:^(MASConstraintMaker *make){
                    make.top.mas_equalTo(answerLabel.mas_bottom).mas_offset(5);
                    make.height.mas_equalTo(answerViewHeight);
//                    make.height.mas_lessThanOrEqualTo(250);
                    make.left.right.equalTo(self);
                }];
                answerViewY += (answerViewHeight + 5);
            }else{
                    
                [answerView mas_makeConstraints:^(MASConstraintMaker *make){
                    make.top.mas_equalTo(answerLabel.mas_bottom).mas_offset(answerViewY + 5);
                    make.height.mas_equalTo(answerViewHeight);
//                    make.height.mas_lessThanOrEqualTo(250);
                    make.left.right.equalTo(self);
                }];
                answerViewY += (answerViewHeight + 5);
            }
//            NSLog(@"%lD",(long)[answerView getViewHeight]);

        }
        
    }else{
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView setImage:[UIImage imageNamed:@"QADetailNoAnswer"]];
        [self.scrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.equalTo(@170);
            make.height.equalTo(@130);
            make.centerX.equalTo(self);
            make.top.mas_equalTo(answerLabel.mas_bottom).mas_offset(70);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"还没有回答哦~";
        label.font = [UIFont fontWithName:PingFangSCLight size:12];
        [label setTextColor:[UIColor colorWithHexString:@"#15315B"]];
        label.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.equalTo(@170);
            make.height.equalTo(@20);
            make.centerX.equalTo(self);
            make.top.mas_equalTo(imageView.mas_bottom).offset(15);
        }];
    }
    
}
- (CGFloat)calculateLabelHeight:(NSString *)text width:(CGFloat)width fontsize:(CGFloat)fontsize{
    CGSize labelSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size;
    return labelSize.height;
}
////根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
//+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
//{
//    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
//
//    return rect.size.height;
//}
//查看大图
- (void)tapToViewBigImage:(UIButton *)sender{
    [self.delegate tapToViewBigImage:sender.tag];
}

- (void)replyComment:(UIButton *)sender{
    [self.delegate replyComment:[NSNumber numberWithInteger:sender.tag]];
}

- (void)tapCommentBtn:(UIButton *)sender{
    [self.delegate tapCommentBtn:[NSNumber numberWithInteger:sender.tag]];
}
//点赞
- (void)tapPraiseBtn:(UIButton *)sender{
    [self.delegate tapPraiseBtn:sender answerId:[NSNumber numberWithInteger:sender.tag]];
    sender.selected = !sender.selected;
}
//采纳
- (void)tapAdoptBtn:(UIButton *)sender{
    [self.delegate tapAdoptBtn:[NSNumber numberWithInteger:sender.tag]];
    sender.selected = !sender.selected;
}
//查看评论
- (void)tapToViewComment:(UIView *)sender{
    [self.delegate tapToViewComment:[NSNumber numberWithInteger:sender.tag]];
}
@end
