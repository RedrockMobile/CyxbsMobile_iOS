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
#import "ExpressDeclareItem.h"
#import "ExpressDeclareModel.h"

// view
#import "ExpressDetailCell.h"

@interface ExpressDetailPageVC () <
    UITableViewDelegate,
    UITableViewDataSource
>
/// id
@property (nonatomic, copy) NSNumber *theId;

/// 投票选项的NSInteger，未投票时是-1，每一次更改投票都会随之改变
@property (nonatomic, assign) NSInteger votedRow;

@property (nonatomic, strong) UITableView *tableView;
/// 标题
@property (nonatomic, strong) UILabel *detailTitle;
@property (nonatomic, strong) UIImageView *backgroundImage;

@property (nonatomic, strong) ExpressPickGetModel *detailModel;

/// 详细信息
@property (nonatomic, strong) ExpressPickGetItem *detailItem;

/// PUT 投票
@property (nonatomic, strong) ExpressPickPutModel *pickModel;

/// 发布投票
@property (nonatomic, strong) ExpressPickPutItem *pickItem;

/// 撤销投票
@property (nonatomic, strong) ExpressDeclareModel *declareModel;

@property (nonatomic, strong) ExpressDeclareItem *declareItem;

///// 投票后的数组
//@property (nonatomic, strong) NSArray *putPercentArray;  // 放票数百分比的数组

@end

@implementation ExpressDetailPageVC

- (ExpressDetailPageVC *)initWithTheId:(NSNumber *)theId {
    self = [super init];
    if (self) {
        self.theId = theId;
        
    }
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.splitLineHidden = YES;
    self.titleColor = [UIColor whiteColor]; // 导航栏标题颜色
    [self.backBtn setImage:[UIImage imageNamed:@"Express_whiteBackBtn"] forState:UIControlStateNormal]; // 导航栏返回按钮
    
    [self.view addSubview:self.backgroundImage];
    [self.view addSubview:self.detailTitle];
    [self.view addSubview:self.tableView];
    
    [self setFrontView];
    
    // request
    [self requestDetails];
}

#pragma mark - Method

/// 首先请求获取详情信息
- (void)requestDetails {
    [self.detailModel requestGetDetailDataWithId:self.theId Success:^(ExpressPickGetItem * _Nonnull model) {
        self.detailItem = model;
        // 标题
        self.detailTitle.text = model.title;
        // 不管有没有投过票，都要展示choice
        // 重新加载tableView
        [self.tableView reloadData];
        NSLog(@"detailModel---%@", model.title);
    } Failure:^{
        // TODO: 弹窗
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
        [cell removeAllSubviews];
//        cell.contentView.backgroundColor = UIColor.clearColor;
        cell.backgroundColor = [UIColor colorWithHexString:@"#0028FC" alpha:0.05];
        
        
        // 分别得到gradientWidth
//        gradientWidth = cellWidth * [self.pickItem.percentNumArray[indexPath.row] floatValue];
        gradientWidth = 160;  // test
        // 深色填充层
        UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, cell.bounds.size.height)];
        if (indexPath == selectIndexPath) {
            // 是选中的cell
            gradientView.backgroundColor = [UIColor colorWithHexString:@"#534EF3" alpha:1.0];
            // 加入对勾
            [cell setCheckImagePosition];
//            cell.contentView.backgroundColor = UIColor.clearColor;
            cell.backgroundColor = [UIColor colorWithHexString:@"#6C68EE" alpha:1.0];
        } else {
            gradientView.backgroundColor = [UIColor colorWithHexString:@"#4A44E4" alpha:0.1];
        }
//        gradientView.tag = 1001;
        [cell addSubview:gradientView];
        // 渐变动画
        [UIView animateWithDuration:1.0 animations:^{
            gradientView.frame = CGRectMake(0, 0, gradientWidth, cell.bounds.size.height);
        } completion:^(BOOL finished) {
            gradientView.frame = CGRectMake(0, 0, gradientWidth, cell.bounds.size.height);
        }];
        
    }
    
//    // TODO: 是否是在别的点击中才用到
//    // 检查是否存在深色填充层，如果存在则移除
//    UIView *gradientView = [selectCell viewWithTag:1001];
//
//    if (gradientView) {
//        [gradientView removeFromSuperview];
//        selectCell.backgroundColor = [UIColor colorWithHexString:@"#0028FC" alpha:1.0];
//        return;
//    }
}

/// 雷达效果
- (void)tapFeedback {
    // 创建触觉反馈生成器
    UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    // 触发震动效果
    [feedbackGenerator impactOccurred];
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
    // 展示数据
    if (self.detailItem != NULL) {
        cell.title = self.detailItem.choices[indexPath.row];
        // TODO: 百分比
        // 如果已经投票
        if (self.detailItem.getVoted != NULL) {
            cell.percent.text = self.detailItem.percentStrArray[indexPath.row];
            // 动画
            if ([cell.title.text isEqual:self.detailItem.getVoted]) {
                self.votedRow = indexPath.row;
                [self putAnimation:indexPath];
            }
        } else {
            self.votedRow = -1;
        }
        
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

// 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpressDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self putAnimation:indexPath];
    // TODO: 鉴权
    
    // DELETE 撤销投票
    // 只有没有投过票才不用撤销投票
    if (self.votedRow != -1) {
        [self.declareModel requestDeclareDataWithId:self.theId Success:^(bool declareSuccess) {
            if (declareSuccess) {
                NSLog(@"撤销成功");
            }
        } Failure:^{
            // TODO: 弹窗
            
        }];
    }
    // 更新投票选项
    self.votedRow = indexPath.row;
    // PUT 投票
    [self.pickModel requestPickDataWithId:self.theId Choice:cell.title.text Success:^(ExpressPickPutItem * _Nonnull model) {
        NSLog(@"发布成功");
        // TODO: 展示已投票结果

        // TODO: 雷达
        [self tapFeedback];
        // TODO: 动画
        [self putAnimation:indexPath];
    } Failure:^{
        NSLog(@"发布失败");
        // TODO: 弹窗

    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
