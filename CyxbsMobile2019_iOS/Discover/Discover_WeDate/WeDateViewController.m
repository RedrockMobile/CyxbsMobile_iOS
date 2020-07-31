//
//  WeDateViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/30.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "WeDateViewController.h"
#import "PeopleListTableViewCell.h"

#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
@interface WeDateViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,PeopleListTableViewCellDelegateDelete,PeopleListTableViewCellDelegateAdd>
/**推出没课约的按钮*/
@property (nonatomic, strong)UIButton *backButton;
/**显示“没课约”3个字的label*/
@property (nonatomic, strong)UILabel *titleLabel;
/**搜索框*/
@property (nonatomic ,strong)UITextField *searchField;
/**显示已经被添加的人的tableView*/
@property (nonatomic ,strong)UITableView *peoleAddedList;

@property (nonatomic, strong)UIButton *enquiryBtn;
@end

@implementation WeDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
}
- (NSMutableArray *)dataArray{
    if(_dataArray==nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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

- (void)addSearchField {
    UITextField *textField = [[UITextField alloc] init];
    [self.view addSubview:textField];
    self.searchField = textField;
    textField.backgroundColor = [UIColor colorWithRed:239/255.0 green:244/255.0 blue:253/255.0 alpha:1.0];
    textField.placeholder = @"添加同学";
    textField.layer.cornerRadius = MAIN_SCREEN_H*0.0271;
    
    textField.delegate = self;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(MAIN_SCREEN_H*0.1441);
        make.left.equalTo(self.view).offset(MAIN_SCREEN_W*0.0427);
        make.bottom.equalTo(self.view).offset(-MAIN_SCREEN_H*0.8017);
        make.right.equalTo(self.view).offset(-MAIN_SCREEN_W*0.0427);
    }];
    
}
/**添加显示已经被添加的人的tableView*/
- (void)addPeoleAddedList{
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.peoleAddedList = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.searchField.mas_bottom).offset(MAIN_SCREEN_H*0.03);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

//添加查询按钮
- (void)addEnquiryBtn {
    UIButton *btn = [[UIButton alloc] init];
    [self.view addSubview:btn];
    self.enquiryBtn = btn;
    btn.layer.cornerRadius = MAIN_SCREEN_H*0.02465;
    btn.backgroundColor = [UIColor colorWithRed:73/255.0 green:66/255.0 blue:230/255.0 alpha:1.0];
    [btn setTitle:@"查询" forState:UIControlStateNormal];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(MAIN_SCREEN_H*0.8805);
        make.left.equalTo(self.view).offset(MAIN_SCREEN_W*0.3413);
        make.bottom.equalTo(self.view).offset(MAIN_SCREEN_H*0.0702);
        make.right.equalTo(self.view).offset(MAIN_SCREEN_W*0.3387);
    }];
    
    [btn addTarget:self action:@selector(enquiry) forControlEvents:UIControlEventTouchUpInside];
}

//MARK:点击某按钮后调用的方法
//点击键盘上的search键搜人时调用
- (void)search{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField==self.searchField){
        [self search];
    }
    return YES;
}

- (void)enquiry{
    
}

//MARK:需实现的代理方法：
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PeopleListTableViewCell *cell = [[PeopleListTableViewCell alloc] initWithInfoDict:@{} andRightBtnType:(PeopleListTableViewCellRightBtnTypeDelete)];
    cell.delegateDelete = self;
    return cell;
}

- (void)PeopleListTableViewCellAddBtnClickInfoDict:(NSDictionary *)infoDict{
    if(self.dataArray.count>6){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:(MBProgressHUDModeText)];
        hud.labelText = @"最多添加六个";
        [hud hide:YES afterDelay:1];
    }else{
        int mark = 0;
        for (NSDictionary *dict in self.dataArray) {
            if([[infoDict class] isKindOfClass:[NSDictionary class]]){
                if([dict[@"stuNum"] isEqual:infoDict[@"stuNUm"]]){
                    mark = 1;
                    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [hud setMode:(MBProgressHUDModeText)];
                    hud.labelText = @"请勿重复添加";
                    [hud hide:YES afterDelay:1];
                }
            }
        }
        
        if(mark==0){
            [self.dataArray addObject:infoDict];
            [self.peoleAddedList reloadData];
        }
    }
}

- (void)PeopleListTableViewCellDeleteBtnClickInfoDict:(NSDictionary *)infoDict{
    for (NSDictionary *dict in self.dataArray) {
        if([[infoDict class] isKindOfClass:[NSDictionary class]]){
            if([dict[@"stuNum"] isEqual:infoDict[@"stuNUm"]]){
                [self.dataArray removeObject:infoDict];
                [self.peoleAddedList reloadData];
            }
        }
    }
}
@end
