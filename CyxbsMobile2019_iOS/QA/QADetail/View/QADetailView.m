//
//  QADetailView.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QADetailView.h"
#import "QADetailAnswerListView.h"
@interface QADetailView()<QADetailAnswerListViewDelegate>
///用来作为添加回答view时进行约束的参照物
@property (nonatomic,strong)UIView *anchorView;
///下一次上拉刷新所要加载的参数page
@property (nonatomic,strong)NSNumber *page;
///是否在加载
@property (nonatomic,assign)BOOL isLoadingData;
@property (nonatomic,assign)BOOL isNoMoreAnswer;
@end
@implementation QADetailView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.scrollView = [[UIScrollView alloc]init];
//    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height);
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollviewHeight = 0;
    //    NSLog(@"%@",NSStringFromCGRect(frame));
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.bottom.equalTo(self);
    }];
    //设置为2，因为第一次加载就是请求第二页的数据
    self.page = [NSNumber numberWithInt:2];
    return self;
    
}
- (void)layoutSubviews{
    self.scrollviewHeight += 40;
    
    if (self.scrollviewHeight < MAIN_SCREEN_H) {
        self.scrollviewHeight = MAIN_SCREEN_H;
    }
    self.scrollView.contentSize = CGSizeMake(0, self.scrollviewHeight + 100);
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
    [userNameLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    [userNameLabel setText:[dic objectForKey:@"nickname"]];
    [userInfoView addSubview:userNameLabel];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.font = [UIFont fontWithName:PingFangSCRegular size:11];
    [dateLabel setTextColor:[UIColor colorWithHexString:@"#2A4E84"]];
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
    [integralNumLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    [userInfoView addSubview:integralNumLabel];
    
    [userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.top.mas_equalTo(self.scrollView.mas_top);
        make.width.equalTo(@SCREEN_WIDTH);
        make.height.equalTo(@57);
    }];
    self.scrollviewHeight += 57;
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
    contentLabel.textColor = [UIColor colorWithHexString:@"#15315B"];
    contentLabel.alpha = 1.0;
    
    [self.scrollView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.mas_left).mas_offset(20);
        make.top.mas_equalTo(userInfoView.mas_bottom).mas_offset(5);
    }];
    self.scrollviewHeight += [self calculateLabelHeight:content width:(SCREEN_WIDTH - 40) fontsize:15];
    
    // 深色模式
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
            NSString *urlString = [NSString stringWithFormat:@"%@",self.imageUrlArray[i]];
            NSURL *url = [NSURL URLWithString:urlString];
            [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
            imgView.userInteractionEnabled = YES;
            imgView.layer.cornerRadius = 8;
            imgView.clipsToBounds = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
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
            self.scrollviewHeight += height;
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
    if (@available(iOS 11.0, *)) {
        [answerLabel setTextColor:[UIColor colorNamed:@"QANavigationTitleColor"]];
    } else {
        [answerLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    }
    answerLabel.font = [UIFont fontWithName:PingFangSCBold size:18];
    [self.scrollView addSubview:answerLabel];
    
    [answerLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(separateView.mas_bottom).mas_offset(14);
        make.right.mas_equalTo(self.scrollView.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.scrollView.mas_left).mas_offset(20);
    }];
    self.scrollviewHeight += 14;
    self.scrollviewHeight += [self calculateLabelHeight:@"回复" width:(SCREEN_WIDTH - 40) fontsize:18];
    

  
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
    //判断是否有回答
    if (answersData.count != 0) {
        //调用addAnswerListViewWithDataArray前，对self.anchorView进行赋值
        self.anchorView = answerLabel;
        [self addAnswerListViewWithDataArray:answersData];
        /**        CGFloat answerViewY = 0;
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
            self.scrollviewHeight += answerViewHeight;
        
            
            [answerView mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.mas_equalTo(answerLabel.mas_bottom).mas_offset(answerViewY + 5);
                make.height.mas_equalTo(answerViewHeight);
                make.left.right.equalTo(self);
            }];
            answerViewY += (answerViewHeight + 5);
        }
        */
    }else{
        self.isNoMoreAnswer = YES;
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
        if (@available(iOS 11.0, *)) {
            [label setTextColor:[UIColor colorNamed:@"color21_49_91&#F0F0F2"]];
        } else {
            [label setTextColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1]];
        }
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

- (void)tapToViewBigAnswerImage:(UIButton *)sender {
    [self.delegate tapToViewBigAnswerImage:sender.tag];
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
//点击某条回答后调用，answerId是某条回答的tag
- (void)tapToViewComment:(UIView *)sender{
//    QADetailViewController
    [self.delegate tapToViewComment:[NSNumber numberWithInteger:sender.tag]];
}
//通过scrollView的代理方法得知是要刷新还是加载。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView isEqual:self.scrollView]){
        //下拉超100就刷新
        if(scrollView.contentOffset.y<-100){
            [self.delegate reloadData];
        }
        //上拉到一定距离时并且当前没有在加载数据，那么就调用代理的方法加载数据。
        if(scrollView.contentOffset.y>scrollView.contentSize.height-MAIN_SCREEN_H&&self.isLoadingData==NO&&self.isNoMoreAnswer==NO){
                self.isLoadingData=YES;
                //代理是QADetailViewController
                [self.delegate loadMoreAtPage:self.page];
        }
    }
}


//添加回答列表，调用这个函数前请确保已经对self.anchorView进行赋值，
//第一次添加时的anchorView是显示回复2字的answerLabel
- (void)addAnswerListViewWithDataArray:(NSArray*)answerList{
    CGFloat answerViewY = 0;
    QADetailAnswerListView *answerView;
    for (int i=0;i<answerList.count; i++) {
        NSDictionary *dic = answerList[i];
        NSString *content = [dic objectForKey:@"content"];
        CGFloat fontsize = 17;
        CGFloat labelWidth = SCREEN_WIDTH - 90 - 1;
        CGFloat labelHeight = [self calculateLabelHeight:content width:labelWidth fontsize:fontsize];
        CGFloat answerViewHeight = labelHeight + 135;
        answerView = [[QADetailAnswerListView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, answerViewHeight)];
        answerView.actionDelagate = self;
        [self.scrollView addSubview:answerView];
        [answerView setupView:dic isSelf:self.isSelf];
        self.scrollviewHeight += answerViewHeight;
    
         
        [answerView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(self.anchorView.mas_bottom).mas_offset(answerViewY + 5);
            make.height.mas_equalTo(answerViewHeight);
            make.left.right.equalTo(self);
        }];
        answerViewY += (answerViewHeight + 5);
    }
    self.anchorView = answerView;
}

//代理是QADetailViewController
//调用代理的loadMoreAtPage方法加载更多后，由代理调用这个方法，入果请求成功isSuccessful==YES
//这里answersData的结构和setupUIwithDic:里面的answersData结构一样
- (void)loadMoreWithArray:(NSArray*) answersData ifSuccessful:(BOOL)isSuccessful{
    if(isSuccessful==YES){
        if(answersData.count!=0){
            //回答数不等0那就是还有回答，那么page++
            [self addAnswerListViewWithDataArray:answersData];
            self.page = [NSNumber numberWithInt:self.page.intValue+1];
            [self layoutSubviews];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            [hud setMode:(MBProgressHUDModeText)];
            hud.labelText = @"没有更多回答了";
            [hud hide:YES afterDelay:0.8];
            self.isNoMoreAnswer = YES;
        }
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        [hud setMode:(MBProgressHUDModeText)];
        hud.labelText = @"加载失败";
        [hud hide:YES afterDelay:0.8];
    }
    self.isLoadingData = NO;
}

@end
