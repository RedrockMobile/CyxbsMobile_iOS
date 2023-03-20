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
#import "ExpressPickPutModel.h"
#import "ExpressPickPutItem.h"

// view
#import "ExpressDetailCell.h"

@interface ExpressDetailPageVC () <
    UITableViewDelegate,
    UITableViewDataSource
>
/// id
@property (nonatomic, copy) NSNumber *theId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *detailTitle;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) ExpressPickGetModel *detailModel;
@property (nonatomic, strong) ExpressPickGetItem *detailItem;
/// PUT 投票
@property (nonatomic, strong) ExpressPickPutModel *pickModel;
@property (nonatomic, strong) ExpressPickPutItem *pickItem;
@property (nonatomic, copy) NSArray *dataArray;// 放模型的数组
@property (nonatomic, strong) NSMutableArray *percentArray;// 放票数百分比的数组

@end

@implementation ExpressDetailPageVC

- (ExpressDetailPageVC *)initWithTheId:(NSNumber *)theId {
    self = [super init];
    if (self) {
        [self.detailModel requestGetDetailDataWithId:theId Success:^(NSArray * _Nonnull array) {
            self.theId = theId;
            self.dataArray = array;
            self.detailItem = self.dataArray[0];
            // 标题
            self.detailTitle.text = self.detailItem.title;
            [self votedPercentCalculate:self.percentArray];
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
//    self.detailItem = self.dataArray[0];
//    [self votedPercentCalculate:self.percentArray];
    
    [self.view addSubview:self.backgroundImage];
    [self.view addSubview:self.detailTitle];
    [self.view addSubview:self.tableView];
    
    [self setFrontView];
    
}

#pragma mark - Method

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

#pragma mark - Delegate



// MARK: <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    TODO: section 数量
//    return self.detailItem.choices.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cell";
    ExpressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ExpressDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.title = self.detailItem.choices[indexPath.row];
    cell.percent.text = self.percentArray[indexPath.row];
    cell.title.text = @"dddddd";
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

// 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpressDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // TODO: 鉴权？和PUT
    [self.pickModel requestPickDataWithId:self.theId Choice:cell.title.text Success:^(NSArray * _Nonnull array) {
        NSLog(@"发布成功");
        // 拿到具体数据
        ExpressPickPutItem *putItem = array[0];
        // TODO: 展示已投票结果
        
        // TODO: 雷达
        [self tapFeedback];
        // TODO: 动画
        [self putAnimation:cell Percent:0.5];
    } Failure:^{
        NSLog(@"发布失败");
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/// 投票动画
- (void)putAnimation:(UITableViewCell *)cell Percent:(CGFloat)percent {
    // 所有的cell都变颜色
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        
    }
    
    CGFloat buttonWidth = cell.bounds.size.width;
    CGFloat gradientWidth = buttonWidth * percent;
    
    // 检查是否存在绿色填充层，如果存在则移除
    UIView *gradientView = [cell viewWithTag:1001];
    if (gradientView) {
        [gradientView removeFromSuperview];
        // TODO: 所有的都要存在另一个深色投票情况，只有一个有动画
        cell.backgroundColor = [UIColor colorWithHexString:@"#0028FC" alpha:1.0];
        return;
    }
    
    gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, cell.bounds.size.height)];
    gradientView.backgroundColor = [UIColor colorWithHexString:@"#554FFD" alpha:1.0];
    gradientView.tag = 1001;
    [cell addSubview:gradientView];
    
    [UIView animateWithDuration:1.0 animations:^{
        gradientView.frame = CGRectMake(0, 0, gradientWidth, cell.bounds.size.height);
    } completion:^(BOOL finished) {
        cell.backgroundColor = [UIColor colorWithHexString:@"#6C68EE" alpha:1.0];
        gradientView.frame = CGRectMake(0, 0, gradientWidth, cell.bounds.size.height);
    }];
}

/// 雷达效果
- (void)tapFeedback {
    // 创建触觉反馈生成器
    UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
}


#pragma mark - Getter

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
//        _detailTitle.text = self.detailItem.title;
        _detailTitle.text = @"你是否支持iPhone的接口将要被统—为type-c接口?你是否支持iPhone的接口将要被统?";
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


//- (ExpressPickGetItem *)detailItem {
//    if (!_detailItem) {
//        _detailItem = [[ExpressPickGetItem alloc] init];
//    }
//    return _detailItem;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
