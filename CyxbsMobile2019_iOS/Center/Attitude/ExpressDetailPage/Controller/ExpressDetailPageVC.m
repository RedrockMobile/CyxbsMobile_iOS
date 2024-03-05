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
#import "ExpressDeclareModel.h"

// view
#import "ExpressDetailCell.h"
#import "AttitudeNetWrong.h"

//swift桥接头文件（需要用swift的邮票任务管理类）
#import "掌上重邮-Swift.h"

@interface ExpressDetailPageVC () <
    UITableViewDelegate,
    UITableViewDataSource
>
/// id
@property (nonatomic, copy) NSNumber *theId;

/// 投票选项的NSInteger，未投票时是-1，每一次更改投票都会随之改变
@property (nonatomic, assign) NSInteger votedRow;
/// 投票选项的indexPath，在进入页面时用来加载动画
@property (nonatomic, strong) NSIndexPath* votedIndex;

@property (nonatomic, strong) UITableView *tableView;

/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;

/// 标题
@property (nonatomic, strong) UILabel *titleLab;

/// 标题
@property (nonatomic, strong) UILabel *detailTitle;
@property (nonatomic, strong) UIImageView *backgroundImage;

/// 详细信息
@property (nonatomic, strong) ExpressPickGetModel *getDetailModel;

@property (nonatomic, strong) ExpressPickGetItem *getDetailItem;

/// PUT 投票
@property (nonatomic, strong) ExpressPickPutModel *putPickModel;

/// 发布投票
@property (nonatomic, strong) ExpressPickPutItem *putPickItem;

/// 撤销投票
@property (nonatomic, strong) ExpressDeclareModel *declareModel;

/// 投票百分比数组
@property (nonatomic, strong) NSArray *putPercentArray;  // 放票数百分比的数组

/// 网络错误页面
@property (nonatomic, strong) AttitudeNetWrong *netWrong;
@end

@implementation ExpressDetailPageVC

- (ExpressDetailPageVC *)initWithTheId:(NSNumber *)theId {
    self = [super init];
    if (self) {
        self.theId = theId;
        self.putPercentArray = [NSArray array];
    }
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViews];
    [self setPosition];
    [self addSEL];
    // request
    [self requestDetails];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadAnimate];
}

#pragma mark - Method

- (void)loadAnimate {
    if (self.votedRow != -1) {
        [UIView setAnimationsEnabled:YES];
        [self putAnimation:self.votedIndex];
    }
}

- (void)addViews {
    [self.view addSubview:self.backgroundImage];
    [self.view addSubview:self.backBtn];
    [self.backgroundImage addSubview:self.titleLab];
    [self.view addSubview:self.detailTitle];
    [self.view addSubview:self.tableView];
}

- (void)addSEL {
    [self.backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
}

/// 首先请求获取详情信息
- (void)requestDetails {
    
    [self.getDetailModel requestGetDetailDataWithId:self.theId Success:^(ExpressPickGetItem * _Nonnull model) {
        self.getDetailItem = model;
        NSLog(@"self.getDetailItem = model;");
        // 标题
        self.detailTitle.text = model.title;
        self.putPercentArray = self.getDetailItem.percentStrArray;
        // 重新加载tableView
        [self.tableView reloadData];
        NSLog(@"detailModel---%@", model.title);
    } Failure:^(NSError * _Nonnull error) {
        // 网络错误页面
        [self.view removeAllSubviews];
        [self.view addSubview:self.netWrong];
        NSLog(@"💰%@",error.userInfo);
        NSLog(@"💰%ld",(long)error.code);
        NSLog(@"💰%@",error.description);
        NSLog(@"请求详情页失败");
    }];
}

/// 投票动画
- (void)putAnimation:(NSIndexPath *)selectIndexPath {
    ExpressDetailCell *cell = [self.tableView cellForRowAtIndexPath:selectIndexPath];
    // 获取cell的宽度
    CGFloat cellWidth = cell.bounds.size.width;
    // 占比宽度
    CGFloat gradientWidth;
    // 所有的cell都变颜色
    for (ExpressDetailCell *cell in self.tableView.visibleCells) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        // 先全部恢复原始状态
        [cell backToOriginState];
        // 分别得到gradientWidth
        gradientWidth = cellWidth * [self.putPickItem.percentNumArray[indexPath.row] doubleValue];
        if (indexPath == selectIndexPath) {
            // 是选中的cell
            [cell selectCell];
        } else {
            [cell otherCell];
        }
        // 渐变动画
        [UIView animateWithDuration:2.0 animations:^{
            cell.gradientView.frame = CGRectMake(0, 0, gradientWidth, cell.bounds.size.height);
        } completion:^(BOOL finished) {
            cell.gradientView.frame = CGRectMake(0, 0, gradientWidth, cell.bounds.size.height);
        }];
    }
}

/// 雷达效果
- (void)tapFeedback {
    // 创建触觉反馈生成器
    UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    // 触发震动效果
    [feedbackGenerator impactOccurred];
}

- (void)setPosition {
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.right.left.equalTo(self.view);
        make.height.equalTo(@226);
    }];
    
    self.backBtn.frame = CGRectMake(16, STATUSBARHEIGHT + 33, 14, 32);
    self.titleLab.frame = CGRectMake(self.backBtn.bounds.origin.x + self.backBtn.bounds.size.width + 30, STATUSBARHEIGHT + 33, 66, 31);
    
    [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(@16);
        make.right.equalTo(self.view).mas_offset(@-15);
        make.bottom.equalTo(self.backgroundImage).mas_offset(@-31);
    }];
}

// MARK: SEL

/// 返回上一级
- (void)clickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate

// MARK: <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 修改cell个数
    return self.getDetailItem.choices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cell";
    ExpressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ExpressDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    // 展示已投票数据
    if (self.getDetailItem != NULL) {
        // cell的标题
        cell.titleLab.text = self.getDetailItem.choices[indexPath.row];
        // 如果已经投票
        if (self.getDetailItem.getVoted != NULL) {
            cell.percent.text = self.getDetailItem.percentStrArray[indexPath.row];
            NSLog(@"cell百分比:%@",cell.percent.text);
            // 没有数据情况.空值或不为字符串
            if (cell.percent.text == NULL || ![cell.percent.text isKindOfClass:[NSString class]]) {
                cell.percent.text = @"nil";
            }
            // 动画
            if ([cell.titleLab.text isEqual:self.getDetailItem.getVoted]) {
                // 记录投票的选项
                self.votedRow = indexPath.row;
                self.votedIndex = indexPath;
//                [self putAnimation:indexPath];
                NSLog(@"记录投票的选项:%ld",(long)self.votedRow);
            }
        } else {
            self.votedRow = -1;
        }
    }
    return cell;
}


// MARK: <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

// 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //邮票任务进度上传
    [TaskManager.shared uploadTaskProgressWithTitle:@"发表一次动态" stampCount:10 remindText:@"今日已完成表态1次，获得10张邮票"];
    ExpressDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self putAnimation:indexPath];
    [self tapFeedback];
    // MARK: DELETE 撤销投票
    // 只有没有投过票才不用撤销投票
    if (self.votedRow != -1) {
        [cell backToOriginState];// cell撤销动画
        [self.declareModel requestDeclareDataWithId:self.theId Success:^(bool declareSuccess) {
            if (declareSuccess) {
                NSLog(@"撤销成功");
            }
        } Failure:^(NSError * _Nonnull error) {
            // 网络错误页面
            [NewQAHud showHudAtWindowWithStr:@"撤销投票失败" enableInteract:YES];
//            [self.view removeAllSubviews];
//            [self.view addSubview:self.netWrong];
        }];
    }
    // 更新投票选项
    self.votedRow = indexPath.row;
    // MARK: PUT 投票
    [self.putPickModel requestPickDataWithId:self.theId Choice:cell.titleLab.text Success:^(ExpressPickPutItem * _Nonnull model) {
        self.putPickItem = model;// 传入model，使用percentNumArray
        NSLog(@"发布成功");
        // 更新百分比数组
        self.putPercentArray = model.percentStrArray;
        NSLog(@"百分比array:%@",self.putPercentArray);
        [self putAnimation:indexPath];  // 动画
        [self tapFeedback];  // 雷达效果

        
    } Failure:^(NSError * _Nonnull error) {
        NSLog(@"发布失败");
        // 网络错误页面
        [NewQAHud showHudAtWindowWithStr:@"投票失败" enableInteract:YES];
//        [self.view removeAllSubviews];
//        [self.view addSubview:self.netWrong];
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Getter

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"Express_whiteBackBtn"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"表态区";
        _titleLab.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1.0];
        _titleLab.font = [UIFont fontWithName:PingFangSCMedium size:22];
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.layer.cornerRadius = 8;
        _tableView.frame = CGRectMake(0, 215, kScreenWidth, kScreenHeight);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UILabel *)detailTitle {
    if (_detailTitle == nil) {
        _detailTitle = [[UILabel alloc] init];
        _detailTitle.numberOfLines = 0 ;
        _detailTitle.textAlignment = NSTextAlignmentLeft;
        _detailTitle.textColor = [UIColor whiteColor];
        _detailTitle.font = [UIFont fontWithName:PingFangSCSemibold size:18];
        _detailTitle.text = self.getDetailItem.title;
    }
    return _detailTitle;
}

- (UIImageView *)backgroundImage {
    if (_backgroundImage == nil) {
        _backgroundImage = [[UIImageView alloc] init];
        _backgroundImage.image = [UIImage imageNamed:@"Express_detailBackground"];
    }
    return _backgroundImage;
}


- (ExpressPickGetItem *)getDetailItem {
    if (!_getDetailItem) {
        _getDetailItem = [[ExpressPickGetItem alloc] init];
    }
    return _getDetailItem;
}

- (ExpressPickGetModel *)getDetailModel {
    if (!_getDetailModel) {
        _getDetailModel = [[ExpressPickGetModel alloc] init];
    }
    return _getDetailModel;
}

- (ExpressPickPutModel *)putPickModel {
    if (!_putPickModel) {
        _putPickModel = [[ExpressPickPutModel alloc] init];
    }
    return _putPickModel;
}

- (ExpressPickPutItem *)putPickItem {
    if (!_putPickItem) {
        _putPickItem = [[ExpressPickPutItem alloc] init];
    }
    return _putPickItem;
}

- (ExpressDeclareModel *)declareModel {
    if (!_declareModel) {
        _declareModel = [[ExpressDeclareModel alloc] init];
    }
    return _declareModel;
}

- (AttitudeNetWrong *)netWrong {
    if (!_netWrong) {
        _netWrong = [[AttitudeNetWrong alloc] initWithNetWrong];
        _netWrong.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _netWrong;
}

@end
