//
//  ChooseStudentListViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/29.
//  Copyright © 2020 Redrock. All rights reserved.
//点击键盘上的搜索按钮后跳转的那个选择人的界面就是这个类

#import "ChooseStudentListViewController.h"
#import "ScheduleViewController.h"
#import "PeopleListCellTableViewCell.h"
#import "WYCClassBookViewController.h"
//#import "WYCClassAndRemindDataModel.h"

@interface ChooseStudentListViewController ()<UITableViewDelegate, UITableViewDataSource, AddPeopleClassDelegate>

@property (nonatomic, strong) ClassmatesList *classmatesList;

@property (nonatomic, weak)UITableView *tableView;
/**返回按钮*/
@property (nonatomic, weak)UIButton *backButton;
/**显示“同学课表”四个字的label*/
@property (nonatomic, weak)UILabel *titleLabel;
@end

@implementation ChooseStudentListViewController
- (instancetype)initWithClassmatesList:(ClassmatesList *)classmatesList {
    if (self = [super init]) {
        self.classmatesList = classmatesList;
    }
    return self;
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    NSLog(@"-----------------------==");
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.classmatesList);
    //添加tableView
    [self addTableView];
    //添加返回按钮
    [self addBackButton];
    //添加显示同学课表四个字的label
    [self addTitleLabel];
    
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000101" alpha:1]];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

//MARK: - 初始化子控件的方法：
//添加tableView
- (void)addTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 87, self.view.width, self.view.height - 87) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

//添加返回按钮
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

//添加显示“同学课表”四个字的label
- (void)addTitleLabel {
    UILabel *label = [[UILabel alloc]init];
    self.titleLabel = label;
    if(self.peopleType==PeopleTypeStudent){
        label.text = @"同学课表";
    }else{
        label.text = @"老师课表";
    }
    label.font = [UIFont fontWithName:PingFangSCBold size:21];
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton).offset(14);
        make.centerY.equalTo(self.backButton);
    }];
}


//MARK: - 需要实现的代理方法：
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PeopleListCellTableViewCell *cell = [[PeopleListCellTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PeopleListCell"];
    cell.textLabel.text = self.classmatesList.classmatesArray[indexPath.row].name;
    cell.detailTextLabel.text = self.classmatesList.classmatesArray[indexPath.row].major;
    cell.stuNumLabel.text = self.classmatesList.classmatesArray[indexPath.row].stuNum;

    cell.cellIndex = indexPath;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classmatesList.classmatesArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    ClassmateItem *item = self.classmatesList.classmatesArray[indexPath.row];
    
    WYCClassBookViewController *vc = [[WYCClassBookViewController alloc] init];
    
    WYCClassAndRemindDataModel *model = [[WYCClassAndRemindDataModel alloc]init];
    
    vc.schedulType = ScheduleTypeClassmate;
    
    model.delegate = vc;
    
    vc.model = model;
    
    if(self.peopleType==PeopleTypeStudent){
        [model getClassBookArrayFromNet:item.stuNum];
    }else{
        [model getTeaClassBookArrayFromNet:@{
            @"teaName":item.name,
            @"tea":item.teaNum
        }];
    }
    [self presentViewController:vc animated:YES completion:nil];
     */
    ClassmateItem *item = self.classmatesList.classmatesArray[indexPath.row];
    id info;
    ScheduleType type;
    if(self.peopleType==PeopleTypeStudent){
        info = item.stuNum;
        type = ScheduleTypeClassmate;
    }else{
        info = @{
            @"teaName":item.name,
            @"tea":item.teaNum
        };
        type = ScheduleTypeTeacher;
    }
    
    WYCClassBookViewController *vc = [[WYCClassBookViewController alloc] initWithType:type andInfo:info];
    [self presentViewController:vc animated:YES completion:nil];
}


//MARK: - 点击某按钮后调用的方法：
//点击返回按钮后调用的方法
- (void)popController {
    UINavigationController *nav = self.navigationController;
    [nav popViewControllerAnimated:YES];
    UIViewController *vc = nav.topViewController;
    [vc viewWillAppear:YES];
    /*
    // 1.新建vc使其可使用block：
    ScheduleViewController *stu = [[ScheduleViewController alloc] initWithUserDefaultKey:ClassSchedule_stuFindHistory_String andPeopleType:PeopleTypeStudent];
    
    ScheduleViewController *tea = [[ScheduleViewController alloc] initWithUserDefaultKey:ClassSchedule_teaFindHistory_String andPeopleType:PeopleTypeTeacher];
    // 2.block中：
        // 2.1 获得当前的数据
    stu.reloadCorrelationBlock = ^(NSString * _Nonnull name, NSString * _Nonnull major, NSString * _Nonnull number) {
        // 1.数据
        name = [NSUserDefaults.standardUserDefaults objectForKey:ClassSchedule_correlationName_String];
        major = [NSUserDefaults.standardUserDefaults objectForKey:ClassSchedule_correlationMajor_String];
        number = [NSUserDefaults.standardUserDefaults objectForKey:ClassSchedule_correlationStuNum_String];
        // 2.跳
        [self.navigationController popViewControllerAnimated:YES];
    };
    tea.reloadCorrelationBlock = ^(NSString * _Nonnull name, NSString * _Nonnull major, NSString * _Nonnull number) {
        // 1.数据
        name = [NSUserDefaults.standardUserDefaults objectForKey:ClassSchedule_correlationName_String];
        major = [NSUserDefaults.standardUserDefaults objectForKey:ClassSchedule_correlationMajor_String];
        number = [NSUserDefaults.standardUserDefaults objectForKey:ClassSchedule_correlationStuNum_String];
        // 2.跳
        [self.navigationController popViewControllerAnimated:YES];
    };
     */
        // 跳回的方法
//    [self.navigationController popViewControllerAnimated:YES];
    
}

// 点击关联按钮后
- (void)addPeopleClass:(NSIndexPath *)indexPath {
    // 1.如果没有关联，关联成功 名字学号专业
    if (![NSUserDefaults.standardUserDefaults boolForKey:ClassSchedule_correlationClass_BOOL]) {
        // 1.1
        [NewQAHud showHudWith:@"关联成功！" AddView:self.view];
        // 1.2 存储
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:ClassSchedule_correlationClass_BOOL];
            // 名字
        [NSUserDefaults.standardUserDefaults setObject:self.classmatesList.classmatesArray[indexPath.row].name forKey:ClassSchedule_correlationName_String];
            // 专业
        [NSUserDefaults.standardUserDefaults setObject:self.classmatesList.classmatesArray[indexPath.row].major forKey:ClassSchedule_correlationMajor_String];
            // 学号
        [NSUserDefaults.standardUserDefaults setObject: self.classmatesList.classmatesArray[indexPath.row].stuNum forKey:ClassSchedule_correlationStuNum_String];
        // 1.3 显示
        
    }
    // 2.如果已经有关联
    else {
        // 2.1 Alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你已有一位关联同学" message:@"确定要替换吗" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"取消"                  style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *deleteAC = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
                // 1.删原来的
                
                // 2.存储当前同学
            
                // 3.@“已取消关联”
            [NewQAHud showHudWith:@"已取消关联" AddView:self.view];
                // 4.显示
        }];
        
        [alert addAction:deleteAC];
        [alert addAction:cancelAC];
    }
}



@end
