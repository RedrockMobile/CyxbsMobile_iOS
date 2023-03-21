//
//  ExpressDetailPageVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

// vc
#import "ExpressDetailPageVC.h"
// model
#import "ExpressPickGetModel.h"
#import "ExpressPickGetItem.h"
// view
#import "ExpressDetailCell.h"

@interface ExpressDetailPageVC () <
    UITableViewDelegate,
    UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *detailTitle;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) ExpressPickGetModel *detailModel;
@property (nonatomic, strong) ExpressPickGetItem *detailItem;
@property (nonatomic, copy) NSArray *dataArray;// 放模型的数组
@property (nonatomic, strong) NSMutableArray *percentArray;// 放票数百分比的数组

@end

@implementation ExpressDetailPageVC

- (ExpressDetailPageVC *)initWithTheId:(NSNumber *)theId {
    self = [super init];
    if (self) {
        [self.detailModel requestGetDetailDataWithId:theId Success:^(NSArray * _Nonnull array) {
            self.dataArray = array;
            NSLog(@"%@",array);
            } Failure:^{
                NSLog(@"请求详情页失败");
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.splitLineHidden = YES;
    self.titleColor = [UIColor whiteColor]; // 导航栏标题颜色
    [self.backBtn setImage:[UIImage imageNamed:@"Express_whiteBackBtn"] forState:UIControlStateNormal]; // 导航栏返回按钮
    self.detailItem = self.dataArray[0];
    [self votedPercentCalculate:self.percentArray];
    
    [self.view addSubview:self.backgroundImage];
    [self.view addSubview:self.detailTitle];
    [self.view addSubview:self.tableView];
    
    [self setFrontView];
    
}


- (void)setFrontView {
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@226);
    }];
    
    [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).mas_offset(@16);
        make.right.equalTo(self.view).mas_offset(@-15);
        make.bottom.equalTo(self.backgroundImage).mas_offset(@-30);
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.detailItem.choices.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cell";
    ExpressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ExpressDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
//    cell.title = self.detailItem.choices[indexPath.row];
//    cell.percent.text = self.percentArray[indexPath.row];
    cell.title.text = @"dddddd";
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

// 选中
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    <#code#>
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 226, kScreenWidth, kScreenHeight);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UILabel *)detailTitle {
    if (!_detailTitle) {
        _detailTitle = [[UILabel alloc] init];
        _detailTitle.numberOfLines = 0;
        _detailTitle.textColor = [UIColor whiteColor];
        _detailTitle.font = [UIFont fontWithName:PingFangSCBold size:18];
        _detailTitle.text = self.detailItem.title;
        NSLog(@"%@",self.detailItem.title);
//        _detailTitle.text = @"你是否支持iPhone的接口将要被统—为type-c接口?你是否支持iPhone的接口将要被统?";
    }
    return _detailTitle;
}

- (UIImageView *)backgroundImage {
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc] init];
        _backgroundImage.image = [UIImage imageNamed:@"Express_detailBackground"];
    }
    return _backgroundImage;
}

- (void)votedPercentCalculate:(NSMutableArray *)percentArray {
    NSDictionary *staticDic = self.detailItem.getStatistic;
    NSInteger total = 0;
    NSArray *valueArray = [staticDic allValues];
    for (int i = 0; i < valueArray.count; ++i) {
        total += (long)valueArray[i];
    }
    for (int j = 0; j < valueArray.count; ++j) {
        NSInteger percent = (long)valueArray[j] / total;
        [percentArray addObject:[NSString stringWithFormat:@"%.ld", (long)percent]];
    }
}

- (ExpressPickGetItem *)detailItem {
    if (!_detailItem) {
        _detailItem = [[ExpressPickGetItem alloc] init];
    }
    return _detailItem;
}

- (ExpressPickGetModel *)detailModel {
    if (!_detailModel) {
        _detailModel = [[ExpressPickGetModel alloc] init];
    }
    return _detailModel;
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
