//
//  QAAnswerViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAAnswerViewController.h"

@interface QAAnswerViewController ()
@property(strong,nonatomic)NSNumber *questionId;
@property(copy,nonatomic)NSString *content;
@end

@implementation QAAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(instancetype)initWithQuestionId:(NSNumber *)questionId content:(NSString *)content{
    self = [super init];
    self.questionId = questionId;
    self.content = content;
    [self setNavigationBar:@"回答"];
    [self setupUI];
    return self;
}
-(void)setNavigationBar:(NSString *)title{
    //设置标题
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    [label setFrame:CGRectMake(0, 0, SCREEN_WIDTH, NVGBARHEIGHT)];
    label.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 23], NSForegroundColorAttributeName: [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    label.alpha = 1.0;
    self.navigationItem.titleView = label;
    
    //设置返回按钮样子
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#122D55"];
    
}
- (void)configNavagationBar {
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.backgroundColor = [UIColor colorNamed:@"navicolor" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    } else {
        // Fallback on earlier versions
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]}];
    //隐藏导航栏的分割线
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorNamed:@"navicolor" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    } else {
        // Fallback on earlier versions
    }
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}
-(void)setupUI{
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    
    UIView *separateView = [[UIView alloc]init];
    separateView.backgroundColor = [UIColor colorWithHexString:@"#2A4E84"];
    separateView.alpha = 0.1;
    [self.view addSubview:separateView];
    
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(TOTAL_TOP_HEIGHT);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel setText:@"问题描述"];
    [titleLabel setAlpha:0.64];
    [titleLabel setTextColor: [UIColor colorWithHexString:@"#15315B"]];
    [titleLabel setFont:[UIFont fontWithName:PingFangSCRegular size:15]];
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.top.mas_equalTo(separateView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.content attributes:@{NSFontAttributeName: [UIFont fontWithName:PingFangSCRegular size: 15], NSForegroundColorAttributeName: [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]}];
    
    contentLabel.attributedText = string;
    contentLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    contentLabel.alpha = 1.0;
    
    [self.view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(9);
    }];
    
    UITextView *answerTextView = [[UITextView alloc]init];
    answerTextView.backgroundColor = [UIColor colorWithHexString:@"#e8edfd"];
    [answerTextView setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    //自适应高度
    answerTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    answerTextView.text = @"回复。。";
    [answerTextView setFont:[UIFont fontWithName:PingFangSCRegular size:16]];
    [self.view addSubview:answerTextView];
    [answerTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(215);
    }];
    [self setAddImageView];
    
    
}
-(void)setAddImageView{
    
}
@end
