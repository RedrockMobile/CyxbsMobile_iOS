//
//  StudentScheduleViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "StudentScheduleViewController.h"
#import "HistoryView.h"
#import "ChooseStudentListViewController.h"
#import "ClassmatesList.h"

#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface StudentScheduleViewController ()
@property (nonatomic, weak)UITextField *textField;
@property (nonatomic, weak)UIView *searchBackView;//搜索栏背景框
@property (nonatomic, strong)NSMutableArray *historyArray;
@property (nonatomic, weak)UILabel *historyLabel;//"历史记录"四个字
@property (nonatomic, copy)NSString *searchName;
@property (nonatomic, strong)UINavigationController *nav;

@end

@implementation StudentScheduleViewController
//MARK: - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *historyArray = [NSMutableArray array];
    self.historyArray = historyArray;
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    [self addSearchField];
    [self addHistoryLabel];
    [self addHistoryItem];
    // Do any additional setup after loading the view.
}
//MARK: - 添加搜索栏
- (void)addSearchField {
    //add background cornerRadius view
    UIView *backView = [[UIView alloc]init];
    self.searchBackView = backView;
    [self.view addSubview:backView];
    backView.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:252/255.0 alpha:1];
    backView.layer.cornerRadius = 23;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(18);
        make.right.equalTo(self.view).offset(-18);
        make.top.equalTo(self.view).offset(30);
        make.height.equalTo(@44);
    }];
    
    //add search field
    UITextField *textField = [[UITextField alloc]init];
    self.textField = textField;
       [self.view addSubview:textField];
       [textField mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(backView).offset(17);
           make.right.equalTo(backView).offset(-37);
           make.top.equalTo(backView).offset(12);
           make.bottom.equalTo(backView).offset(-11);
       }];
       [textField setFont:[UIFont fontWithName:PingFangSCRegular size:15]];
       textField.placeholder = @"输入内容";
       if (@available(iOS 11.0, *)) {
           textField.textColor = Color21_49_91_F0F0F2;
           textField.tintColor = Color21_49_91_F0F0F2;
//           [textField setValue:Color21_49_91_F0F0F2 forKeyPath:@"_placeholderLabel.textColor"];

       } else {
           // Fallback on earlier versions
       }
       textField.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:252/255.0 alpha:1];
    //addSearchButton
    UIButton *searchButton = [[UIButton alloc]init];
    searchButton.backgroundColor = [UIColor blueColor];
    [searchButton addTarget: self action:@selector(touchSearchButton) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-20.16);
        make.centerY.equalTo(textField);
        make.height.width.equalTo(@17.83);
    }];
    
}
//MARK: - 添加历史记录的文字
- (void)addHistoryLabel {
    UILabel *label = [[UILabel alloc]init];
    self.historyLabel = label;
    label.text = @"历史记录";
    label.textColor = Color21_49_91_F0F0F2;
    label.font = [UIFont fontWithName:PingFangSCBold size:15];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBackView);
        make.top.equalTo(self.searchBackView.mas_bottom).offset(21);
    }];
}
//MARK: - 点击搜索按钮
- (void)touchSearchButton {
    //记录数据，用作展示历史记录
    [self.historyArray addObject:self.textField.text];
    //写入缓存
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"FindStudentSchedule_historyArray"]) {
        [defaults setObject:self.historyArray forKey:@"FindStudentSchedule_historyArray"];
    } else {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[defaults objectForKey:@"FindStudentSchedule_historyArray"]];
        [array addObject:self.textField.text];
        [defaults setObject:array forKey:@"FindStudentSchedule_historyArray"];
    }
    NSLog(@"当前缓存的数组是%@",[defaults objectForKey:@"FindStudentSchedule_historyArray"]);
    self.searchName = self.textField.text;
    //搜索输入框的内容，如果有返回则跳转t如选择同学页面
    [self requestStudentNameData];
}
//MARK: - 添加历史记录的人名

- (void)addHistoryItem {
    UIButton *exampleButton = [[UIButton alloc]init];
    exampleButton.backgroundColor = [UIColor colorWithRed:221/255.0 green:229/255.0 blue:241/255.0 alpha:1];
    if (@available(iOS 11.0, *)) {
        exampleButton.titleLabel.textColor = Color21_49_91_F0F0F2;
        [exampleButton setTitleColor:Color21_49_91_F0F0F2 forState:normal];
    }
    [exampleButton.titleLabel setFont:[UIFont fontWithName:PingFangSCRegular size:12]];
    exampleButton.layer.cornerRadius = 14;
    HistoryView *view = [[HistoryView alloc]initWithFrame:CGRectMake(0, 200, self.view.width, 200) button:exampleButton dataArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FindStudentSchedule_historyArray"]];
    [self.view addSubview:view];
    for (UIButton *button in view.buttonArray) {
        [button addTarget:self action:@selector(touchHistoryButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.historyLabel.mas_bottom).offset(9);
        make.left.equalTo(self.searchBackView);
        make.right.equalTo(self.searchBackView);
        make.height.equalTo(@400);
    }];
}
- (void)touchHistoryButton:(UIButton *)sender {
    self.searchName = sender.titleLabel.text;
    [self requestStudentNameData];
}
//MARK: - 请求同学名称数据
- (void)requestStudentNameData {
    [self.view endEditing:YES];
       
       if ([self.searchName isEqualToString:@""]) {
           MBProgressHUD *noInput = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
           noInput.mode = MBProgressHUDModeText;
           noInput.labelText = @"输入为空";
           [noInput hide:YES afterDelay:1];
           return;
       }
       
       __block MBProgressHUD *loading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       loading.mode = MBProgressHUDModeIndeterminate;
       loading.labelText = @"加载中";
       
       ClassmatesList *classmates = [[ClassmatesList alloc] init];
       [classmates getListWithName:self.searchName success:^(ClassmatesList * _Nonnull classmatesList) {
           [loading hide:YES];
           if (classmatesList.classmatesArray.count == 0) {
               MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               hud.mode = MBProgressHUDModeText;
               hud.labelText = @"无结果";
               [hud hide:YES afterDelay:1];
               return;
           }
//#error 跳转到搜索结果页面

           ChooseStudentListViewController *studentListVC = [[ChooseStudentListViewController alloc]initWithClassmatesList:classmatesList];
           [self.delegate pushToController: studentListVC];

       } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
           [loading hide:YES];
           MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
           hud.mode = MBProgressHUDModeText;
           hud.labelText = @"加载失败";
           [hud hide:YES afterDelay:1];
       }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
