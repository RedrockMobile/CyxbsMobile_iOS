//
//  NewDetailViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "NewDetailViewController.h"
#import "DownFileDetailCellTableViewCell.h"
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorWhite  [UIColor colorNamed:@"colorWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorNewsTime  [UIColor colorNamed:@"ColorNewsTime" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorNewsCellTitle  [UIColor colorNamed:@"ColorNewsCellTitle" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorSeperateLine  [UIColor colorNamed:@"ColorSeperateLine" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorButtonHighLighted  [UIColor colorNamed:@"color21_49_91&#F0F0F2_alpha0.59" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]


@interface NewDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UIButton *backButton;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UIView *seperateLine;

@property (nonatomic, weak)UILabel *NewsTimeLabel;
@property (nonatomic, weak)UILabel *NewsTitleLabel;
@property (nonatomic, weak)UITextView *NewsDetailTextView;
@property (nonatomic, weak)UIButton *downButton;//下载附件
@property (nonatomic, weak)UITableView *chooseFileTableView;
@property (nonatomic, strong)NSMutableArray<NSString*> *fileNameArray;//附件名称
@property (nonatomic, strong)NSMutableArray<NSString*> *fileIDArray;//附件id

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
    self.fileNameArray = [NSMutableArray array];
    self.fileIDArray = [NSMutableArray array];
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

    
    UITextView *textView = [[UITextView alloc]init];
    [textView setEditable:NO];
    self.NewsDetailTextView = textView;
//    label.numberOfLines = 0;
    [self.view addSubview:textView];
    textView.font = [UIFont fontWithName:PingFangSCRegular size:15];
    if (@available(iOS 11.0, *)) {
        textView.textColor = ColorNewsCellTitle;
    } else {
        // Fallback on earlier versions
    }
    textView.text = @"新闻详情加载中......";
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.NewsTitleLabel);
        make.top.equalTo(self.NewsTitleLabel.mas_bottom).offset(14);
        make.bottom.equalTo(self.view).offset(-TABBARHEIGHT);
    }];
}
- (void)fetchData {
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:NEWSDETAIL method:HttpRequestGet parameters:@{@"id": self.NewsID} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.NewsDetailTextView.text = responseObject[@"data"][@"content"];
        if(![responseObject[@"data"][@"files"]  isEqual: @[]]) {
            for (NSDictionary *dic in responseObject[@"data"][@"files"]) {
                [self.fileNameArray addObject:dic[@"name"]];
                [self.fileIDArray addObject:dic[@"id"]];
            }
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
    [button addTarget:self action:@selector(chooseAndDownFile) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.right.equalTo(self.view).offset(-15);
        make.width.equalTo(@87);
        make.height.equalTo(@29);
    }];
}
- (void) chooseAndDownFile {
    [self addFileDetailView];
}
- (void) addFileDetailView {
    UIButton *shadowButton = [[UIButton alloc]initWithFrame:self.view.frame];//一个模糊背景的View
    [self.view addSubview:shadowButton];
    shadowButton.backgroundColor = UIColor.grayColor;
    shadowButton.alpha = 0;
    [UIButton animateWithDuration:0.2 animations:^{
        shadowButton.alpha = 0.8;
    }];
    
    [shadowButton addTarget:self action:@selector(cancelDownload:) forControlEvents:UIControlEventTouchUpInside];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        tableView.backgroundColor = ColorWhite;
    } else {
        // Fallback on earlier versions
    }
    tableView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        tableView.alpha = 0.8;
    }];
    
    self.chooseFileTableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.right.equalTo(self.view).offset(-15);
        make.left.equalTo(self.view).offset(15);
        make.height.equalTo(@(70 * self.fileNameArray.count));
    }];
    
}
- (void)cancelDownload: (UIButton *)sender {
    [self.chooseFileTableView removeFromSuperview];
    [sender removeFromSuperview];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
   DownFileDetailCellTableViewCell *cell = [[DownFileDetailCellTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DownFileDetailCellTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.fileNameArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileNameArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"https://cyxbsmobile.redrock.team/234/newapi/jwNews/file?id=%@",self.fileIDArray[indexPath.row]]]];
}
@end
