//
//  ChooseStudentListViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ChooseStudentListViewController.h"
#import "PeopleListCellTableViewCell.h"
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface ChooseStudentListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ClassmatesList *classmatesList;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, weak)UIButton *backButton;
@property (nonatomic, weak)UILabel *titleLabel;
@end

@implementation ChooseStudentListViewController
- (instancetype)initWithClassmatesList:(ClassmatesList *)classmatesList {
    if (self = [super init]) {
        self.classmatesList = classmatesList;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.classmatesList);
    [self addTableView];
    [self addBackButton];
    [self addTitleLabel];
    self.view.backgroundColor = UIColor.whiteColor;
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 87, self.view.width, self.view.height - 87) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
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
    self.titleLabel.text = @"同学课表";
    label.font = [UIFont fontWithName:PingFangSCBold size:21];
    label.textColor = Color21_49_91_F0F0F2;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton).offset(14);
        make.centerY.equalTo(self.backButton);
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PeopleListCellTableViewCell *cell = [[PeopleListCellTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PeopleListCell"];
    cell.textLabel.text = self.classmatesList.classmatesArray[indexPath.row].name;
    cell.detailTextLabel.text = self.classmatesList.classmatesArray[indexPath.row].major;
    cell.stuNumLabel.text = self.classmatesList.classmatesArray[indexPath.row].stuNum;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classmatesList.classmatesArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SchedulForOneWeekController *schedul = [[SchedulForOneWeekController alloc]init];
    
    //传入被查课表者的num（学生学号？老师工号？）
    if([schedul loadSchedulWithNum:self.classmatesList.classmatesArray[indexPath.row].stuNum ForPeopleType:(self.peopleType)]==YES){
        [self presentViewController:schedul animated:YES completion:nil];
    }else{
        MBProgressHUD *noInput = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        noInput.mode = MBProgressHUDModeText;
        noInput.labelText = @"加载失败";
        [noInput hide:YES afterDelay:1];
    }
}
@end
