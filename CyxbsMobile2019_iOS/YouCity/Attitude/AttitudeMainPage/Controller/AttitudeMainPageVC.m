//
//  AttitudeMainPageVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "AttitudeMainPageVC.h"
#import "AttitudeHomeCell.h"
#import "AttitudeMainModel.h"

@interface AttitudeMainPageVC () <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation AttitudeMainPageVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getRequestData];
    [self.view addSubview:self.tableView];
//    self.view.backgroundColor = [UIColor colorNamed:@"xxx"];
    self.VCTitleStr = @"表态区";
    self.topBarView.backgroundColor = [UIColor whiteColor];
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
}

- (void)getRequestData {
    [AttitudeMainModel requestAttitudeDataWithSuccess:^(NSArray * _Nonnull array) {
        self.dataArray = array;
        } Failure:^{
        }];
}


#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"identify";
    AttitudeHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[AttitudeHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    AttitudeMainModel *model = self.dataArray[indexPath.row];
    cell.title.text = model.title;
    return cell;
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat y = self.topBarView.bottom;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, kScreenHeight - y) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 13.0, *)) {
            _tableView.backgroundColor = [UIColor systemGray4Color];
        } else {
            // Fallback on earlier versions
        }
    }
    return _tableView;
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
