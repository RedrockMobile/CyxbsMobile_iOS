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

///标题
@property (nonatomic, strong) NSString *attitudeTitle;

///投票选项数组
@property (nonatomic, strong) NSArray *choices;

///被投票的选项名
@property (nonatomic, strong) NSString *votedChoice;

///展示投票选项的表格视图
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

/// PUT 投票
@property (nonatomic, strong) ExpressPickPutModel *putPickModel;

/// 撤销投票
@property (nonatomic, strong) ExpressDeclareModel *declareModel;

/// 投票百分比字符串数组
@property (nonatomic, strong) NSArray *percentStringArray;

/// 投票比例（NSNumber）数组
@property (nonatomic, strong) NSArray *percentNumArray;

/// 网络错误页面
@property (nonatomic, strong) AttitudeNetWrong *netWrong;
@end

@implementation ExpressDetailPageVC

- (ExpressDetailPageVC *)initWithTheId:(NSNumber *)theId {
    self = [super init];
    if (self) {
        self.theId = theId;
        self.percentStringArray = [NSArray array];
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
    NSLog(@"%@", self.votedChoice);
    //如果已投票
    if (![self.votedChoice isEqualToString:@""]) {
        [UIView setAnimationsEnabled:YES];
        [self putAnimation];
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
        // 标题
        self.detailTitle.text = model.title;
        self.attitudeTitle = model.title;
        self.choices = model.choices;
        self.percentStringArray = model.percentStrArray;
        self.percentNumArray = model.percentNumArray;
        self.votedChoice = model.getVoted;
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
- (void)putAnimation {
    ExpressDetailCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
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
        gradientWidth = cellWidth * [self.percentNumArray[indexPath.row] doubleValue];
        if (cell.titleLab.text == self.votedChoice) {
            // 是选中的cell
            [cell selectCell];
        } else {
            [cell otherCell];
        }
        if (![self.votedChoice isEqualToString:@""]) {
            // 渐变动画
            [UIView animateWithDuration:2.0 animations:^{
                cell.gradientView.frame = CGRectMake(0, 0, gradientWidth, cell.bounds.size.height);
            } completion:^(BOOL finished) {
                cell.gradientView.frame = CGRectMake(0, 0, gradientWidth, cell.bounds.size.height);
            }];
        }
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
    return self.choices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cell";
    ExpressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ExpressDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    // 展示已投票数据
    if (self.attitudeTitle != nil) {
        // cell的标题
        cell.titleLab.text = self.choices[indexPath.row];
        // 如果已经投票
        if (![self.votedChoice isEqualToString:@""]) {
            cell.percent.text = self.percentStringArray[indexPath.row];
            NSLog(@"cell百分比:%@",cell.percent.text);
            // 没有数据情况.空值或不为字符串
            if (cell.percent.text == NULL || ![cell.percent.text isKindOfClass:[NSString class]]) {
                cell.percent.text = @"nil";
            }
        } else {
            cell.percent.text = @"";
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
    [self tapFeedback];
    // MARK: DELETE 撤销投票
    // 如果已经投票
    if (![self.votedChoice isEqualToString:@""]) {
        //撤销投票
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
    if (![self.votedChoice isEqualToString:cell.titleLab.text]) {
        // 选中选项不为之前选中的选项
        // 更新投票选项
        // MARK: PUT 投票
        [self.putPickModel requestPickDataWithId:self.theId Choice:cell.titleLab.text Success:^(ExpressPickPutItem * _Nonnull model) {
            self.votedChoice = cell.titleLab.text;
            self.percentNumArray = model.percentNumArray;
            NSLog(@"发布成功");
            // 更新百分比数组
            self.percentStringArray = model.percentStrArray;
            NSLog(@"百分比array:%@",self.percentStringArray);
            [self.tableView reloadData];
            [self putAnimation];  // 动画
            [self tapFeedback];  // 雷达效果
            
        } Failure:^(NSError * _Nonnull error) {
            NSLog(@"发布失败");
            // 网络错误页面
            [NewQAHud showHudAtWindowWithStr:@"投票失败" enableInteract:YES];
    //        [self.view removeAllSubviews];
    //        [self.view addSubview:self.netWrong];
        }];
    } else {
        // 选中选项为之前选中的选项
        // 仅取消投票
        self.votedChoice = @"";
        [self.tableView reloadData];
        [self putAnimation];
    }
    
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
        _detailTitle.text = self.attitudeTitle;
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
