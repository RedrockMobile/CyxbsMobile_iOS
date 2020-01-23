//
//  StudentScheduleViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "StudentScheduleViewController.h"
#import "HistoryView.h"
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface StudentScheduleViewController ()
@property (nonatomic, weak)UITextField *textField;
@property (nonatomic, strong)NSMutableArray *historyArray;
@end

@implementation StudentScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *historyArray = [NSMutableArray array];
    self.historyArray = historyArray;
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    [self addSearchField];
    [self addHistoryItem];
    // Do any additional setup after loading the view.
}
- (void)addSearchField {
    //add background cornerRadius view
    UIView *backView = [[UIView alloc]init];
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
    
    //跳转到同学的查询结果选择页面
//    ChooseStudentList *vc = [[ChooseStudentList alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addHistoryItem {
    UIButton *exampleButton = [[UIButton alloc]init];
    exampleButton.backgroundColor = [UIColor colorWithRed:221/255.0 green:229/255.0 blue:241/255.0 alpha:1];
    if (@available(iOS 11.0, *)) {
        exampleButton.titleLabel.textColor = Color21_49_91_F0F0F2;
        [exampleButton setTitleColor:Color21_49_91_F0F0F2 forState:normal];
    }
    [exampleButton.titleLabel setFont:[UIFont fontWithName:PingFangSCRegular size:12]];
    exampleButton.layer.cornerRadius = 15;
    HistoryView *view = [[HistoryView alloc]initWithFrame:CGRectMake(0, 200, self.view.width, 200) button:exampleButton dataArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FindStudentSchedule_historyArray"]];
    [self.view addSubview:view];
    view.backgroundColor = UIColor.yellowColor;
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
