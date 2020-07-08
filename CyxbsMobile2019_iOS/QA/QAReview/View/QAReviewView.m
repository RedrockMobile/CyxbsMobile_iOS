//
//  QAReviewView.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAReviewView.h"
#import "QAReviewAnswerListView.h"
@implementation QAReviewView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.scrollView = [[UIScrollView alloc]init];
    //    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height);
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //    NSLog(@"%@",NSStringFromCGRect(frame));
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.bottom.equalTo(self);
    }];
    return self;
    
}
- (void)layoutSubviews{
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
}
- (void)setupUIwithDic:(NSDictionary *)dic reviewData:(nonnull NSArray *)reviewData{
    self.answerId = [dic objectForKey:@"id"];
    
    UIView *userInfoView = [[UIView alloc]init];
    userInfoView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:userInfoView];
    
    UIImageView *userIcon = [[UIImageView alloc]init];
    userIcon.layer.cornerRadius = 20;
    userIcon.layer.masksToBounds = YES;
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
    NSString *date = [dic objectForKey:@"created_at"];
    [dateLabel setText:[date substringWithRange:NSMakeRange(0, 10)]];
    [userInfoView addSubview:dateLabel];
    
    
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
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    NSString *content = [dic objectForKey:@"content"];
    contentLabel.text = content;
    [contentLabel setFont:[UIFont fontWithName:PingFangSCRegular size:15]];
    contentLabel.textColor = [UIColor colorWithHexString:@"#15315B"];
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
    
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(0);
        make.left.mas_equalTo(self.mas_left).mas_offset(0);
        make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(1);
    }];
    
    
    //底下的评论条
    self.reviewBar = [[UIButton alloc]init];
    [self addSubview:self.reviewBar];
    [self.reviewBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(self.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.mas_right).mas_offset(0);
        make.height.mas_equalTo(60);
    }];
    //点赞数量
    UILabel *praiseNum = [[UILabel alloc]init];
    praiseNum.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"praise_num"]];
    [self.reviewBar addSubview:praiseNum];
    [praiseNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.reviewBar);
        make.right.mas_equalTo(self.reviewBar.mas_right).mas_offset(-25);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(10);
        
    }];
    //点赞按钮
    self.praiseBtn = [[UIButton alloc]init];
    [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"likeIcon"] forState:UIControlStateNormal];
    [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"selectedLikeIcon"] forState:UIControlStateSelected];
    NSNumber *is_praised = [dic objectForKey:@"is_praised"];
    if (is_praised.integerValue == 1) {
        [self.praiseBtn setSelected:YES];
    }
    self.praiseBtn.tag = [[dic objectForKey:@"id"] integerValue];
    [self.praiseBtn addTarget:self action:@selector(tapPraiseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.reviewBar addSubview:self.praiseBtn];
    [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.reviewBar);
        make.right.mas_equalTo(praiseNum).mas_offset(-15);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(18);
    }];
    //评论输入栏
    self.replyTextField = [[UITextField alloc]init];
    self.replyTextField.layer.cornerRadius = 15;
    self.replyTextField.placeholder = @"发布评论";
    self.replyTextField.backgroundColor = [UIColor colorWithHexString:@"#EFF4FD"];
    self.replyTextField.keyboardType = UIKeyboardTypeDefault;
    self.replyTextField.returnKeyType = UIReturnKeySend;
    self.replyTextField.delegate = self;
    [self.reviewBar addSubview:self.replyTextField];
    [self.replyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.reviewBar);
        make.right.mas_equalTo(self.praiseBtn).mas_offset(-30);
        make.left.mas_equalTo(self).mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    //加载回答列表
    NSArray *answerList = reviewData;
    //判断h是否有回答
    if (answerList.count != 0) {
        CGFloat answerViewY = 0;
        for (int i=0;i<answerList.count; i++) {
            NSDictionary *dic = answerList[i];
            NSString *content = [dic objectForKey:@"content"];
            CGFloat fontsize = 17;
            CGFloat labelWidth = SCREEN_WIDTH - 90 - 1;
            CGFloat labelHeight = [self calculateLabelHeight:content width:labelWidth fontsize:fontsize];
            CGFloat answerViewHeight = labelHeight + 80;
            QAReviewAnswerListView *answerView = [[QAReviewAnswerListView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, answerViewHeight)];
            switch (i%3) {
                case 0:
                    answerView.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#F9F3F0"];
                    break;
                case 1:
                    answerView.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#F0F2FB"];
                    break;
                case 2:
                    answerView.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#F9EFF2"];
                    break;
                    
                default:
                    break;
            }
            
            [answerView setupView:dic isSelf:self.isSelf];
            //            NSLog(@"%lD",(long)[answerView getViewHeight]);
            [self.scrollView addSubview:answerView];
            
            
            if (i == 0) {
                
                [answerView mas_makeConstraints:^(MASConstraintMaker *make){
                    make.top.mas_equalTo(separateView.mas_bottom).mas_offset(5);
                    make.height.mas_equalTo(answerViewHeight);
                    //                    make.height.mas_lessThanOrEqualTo(250);
                    make.left.right.equalTo(self);
                }];
                answerViewY += (answerViewHeight + 5);
            }else{
                
                [answerView mas_makeConstraints:^(MASConstraintMaker *make){
                    make.top.mas_equalTo(separateView.mas_bottom).mas_offset(answerViewY + 5);
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
            make.top.mas_equalTo(separateView.mas_bottom).mas_offset(70);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"还没有评论哦~";
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


//- (void)replyComment:(NSString *)content answerId:(NSNumber *)answerId{
//    [self.delegate replyComment:[NSNumber numberWithInteger:sender.tag]];
//}

//点赞
- (void)tapPraiseBtn:(UIButton *)sender{
    [self.delegate tapPraiseBtn:sender answerId:[NSNumber numberWithInteger:sender.tag]];
    sender.selected = !sender.selected;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    NSLog(@"发送评论");
    [self.delegate replyComment:textField.text answerId:self.answerId];
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}
@end
