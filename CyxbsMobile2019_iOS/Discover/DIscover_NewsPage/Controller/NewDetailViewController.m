//
//  NewDetailViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "NewDetailViewController.h"
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorWhite  [UIColor colorNamed:@"colorWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorNewsTime  [UIColor colorNamed:@"ColorNewsTime" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorNewsCellTitle  [UIColor colorNamed:@"ColorNewsCellTitle" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorSeperateLine  [UIColor colorNamed:@"ColorSeperateLine" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorButtonHighLighted  [UIColor colorNamed:@"color21_49_91&#F0F0F2_alpha0.59" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]


@interface NewDetailViewController ()

@property (nonatomic, weak)UIButton *backButton;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UIView *seperateLine;

@property (nonatomic, weak)UILabel *NewsTimeLabel;
@property (nonatomic, weak)UILabel *NewsTitleLabel;
@property (nonatomic, weak)UITextView *NewsDetailLabel;
@property (nonatomic, weak)UIButton *downButton;//下载附件
@end

@implementation NewDetailViewController
- (instancetype)initWithNewsTime:(NSString *)time NewsTitle:(NSString*)NewsTitle NewsID:(NSString *)NewsID{
    if(self = [super init]) {
        self.NewsTitle = NewsTitle;
        self.NewsTime = time;
        self.NewsID = NewsID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = ColorWhite;
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
    [self addBackButton];
    [self addTitleLabel];
    [self addSeperateLine];
    [self addNewsTime];
    [self addNewsTitle];
    [self addNewsDetail];
    [self addBackButton];
    [self fetchData];
    // Do any additional setup after loading the view.
}

- (void)addBackButton {
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    self.backButton = button;
    [button setImage:[UIImage imageNamed:@"LQQBackButton"] forState:normal];
    [button setImage: [UIImage imageNamed:@"EmptyClassBackButton"] forState:UIControlStateHighlighted];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(17);
        make.top.equalTo(self.view).offset(53);
        make.width.equalTo(@7);
        make.height.equalTo(@14);
    }];
    [button addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
}
- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addTitleLabel {
    UILabel *label = [[UILabel alloc]init];
    self.titleLabel = label;
    self.titleLabel.text = @"教务新闻";
    self.titleLabel.numberOfLines = 0;
    label.font = [UIFont fontWithName:PingFangSCBold size:21];
    if (@available(iOS 11.0, *)) {
        label.textColor = Color21_49_91_F0F0F2;
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton).offset(14);
        make.centerY.equalTo(self.backButton);
    }];
}
- (void)addSeperateLine {
    UIView *view = [[UIView alloc]init];
    if (@available(iOS 11.0, *)) {
        view.backgroundColor = ColorSeperateLine;
    }
    self.seperateLine = view;
        [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.height.equalTo(@1);
    }];
    
}
- (void)addNewsTime {
    UILabel *label = [[UILabel alloc]init];
    self.NewsTimeLabel = label;
    [self.view addSubview:label];
    label.font = [UIFont fontWithName:PingFangSCRegular size:13];
    if (@available(iOS 11.0, *)) {
        label.textColor = ColorNewsTime;
    } else {
        // Fallback on earlier versions
    }
    label.text = self.NewsTime;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton).offset(2);
        make.top.equalTo(self.seperateLine).offset(22);
    }];
}
- (void)addNewsTitle {
    UILabel *label = [[UILabel alloc]init];
    self.NewsTitleLabel = label;
    [self.view addSubview:label];
    label.numberOfLines = 0;
    label.text = self.NewsTitle;
    label.font = [UIFont fontWithName:PingFangSCBold size:18];
    if (@available(iOS 11.0, *)) {
        label.textColor = ColorNewsCellTitle;
    } else {
        // Fallback on earlier versions
    }
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.NewsTimeLabel);
        make.top.equalTo(self.NewsTimeLabel.mas_bottom).offset(8);
        make.right.equalTo(self.view).offset(-23);
    }];
}
- (void)addNewsDetail {
    UITextView *label = [[UITextView alloc]init];
    self.NewsDetailLabel = label;
//    label.numberOfLines = 0;
    [self.view addSubview:label];
    label.font = [UIFont fontWithName:PingFangSCRegular size:15];
    if (@available(iOS 11.0, *)) {
        label.textColor = ColorNewsCellTitle;
    } else {
        // Fallback on earlier versions
    }
    label.text = @"新闻详情加载中......";
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.NewsTitleLabel);
        make.top.equalTo(self.NewsTitleLabel.mas_bottom).offset(14);
        make.bottom.equalTo(self.view).offset(-TABBARHEIGHT);
    }];
}
- (void)fetchData {
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:NEWSDETAIL method:HttpRequestGet parameters:@{@"id": self.NewsID} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.NewsDetailLabel.text = responseObject[@"data"][@"content"];
        if(![responseObject[@"files"]  isEqual: @[]]) {
            [self addDownButton];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)addDownButton {
    //
    UIButton *button = [[UIButton alloc]init];
    self.downButton = button;
    [self.view addSubview:button];
    [button setTitle:@"下载附件" forState:normal];
    [button setTitleColor:self.titleLabel.textColor forState:normal];
    if (@available(iOS 11.0, *)) {
        [button setTitleColor:ColorButtonHighLighted forState:UIControlStateHighlighted];
    } else {
        // Fallback on earlier versions
    }
    button.titleLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.right.equalTo(self.view).offset(-15);
        make.width.equalTo(@87);
        make.height.equalTo(@29);
    }];
}

@end
