//
//  PMPFansAndFollowerViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPFansAndFollowingViewController.h"
//view
#import "FansAndFollowingSegmentView.h"
#import "FansTableViewCell.h"
#import "FollowersTableViewCell.h"
// models
#import "FansAndFollowersModel.h"
// pod
#import <MJRefresh.h>
// controller
#import "PMPHomePageViewController.h"

@interface PMPFansAndFollowingViewController ()
<UITableViewDelegate,
SegmentViewDelegate,
UITableViewDataSource,
BaseTableViewCellDelegate>

@property (nonatomic, strong) NSString * currentRedid;
///首页在我的关注还是粉丝 0 - 粉丝 1 - 关注
@property (nonatomic, assign) NSInteger index;

/// 分隔栏
@property (nonatomic, strong) FansAndFollowingSegmentView *segmentView;
/// 水平滑动背景
@property (nonatomic, strong) UIScrollView *horizontalScrollView;
///我的粉丝
@property (nonatomic, strong) UITableView *fansTableView;
///我的关注
@property (nonatomic, strong) UITableView *followersTableView;
///无粉丝文字
@property (nonatomic, strong) UILabel *noFansLabel;
///无粉丝图片
@property (nonatomic, strong) UIImageView *noFansImgView;
///无关注文字
@property (nonatomic, strong) UILabel *noFollowingLabel;
///无关注图片
@property (nonatomic, strong) UIImageView *noFollowingImgView;

/// 粉丝
@property (nonatomic, copy) NSArray *fansAry;
/// 关注
@property (nonatomic, copy) NSArray *followAry;

@end

@implementation PMPFansAndFollowingViewController

- (instancetype)initWithRedid:(NSString *)redid {
    self = [super init];
    if (self) {
        _currentRedid = redid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self configureView];
}
- (void)dealloc {
    // 移除KVO，否则会导致错误
    [self.horizontalScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - configure

- (void)loadData {
    [FansAndFollowersModel
     getDataWithRedid:self.currentRedid
     Success:^(NSArray * _Nonnull fans, NSArray * _Nonnull followers) {
        self.fansAry = fans;
        [self.fansTableView reloadData];
        if (self.fansAry.count == 0) {
            self.noFansLabel.hidden = NO;
            self.noFansImgView.hidden = NO;
        } else {
            self.noFansLabel.hidden = YES;
            self.noFansImgView.hidden = YES;
        }
        self.followAry = followers;
        [self.followersTableView reloadData];
        if (self.followAry.count == 0) {
            self.noFollowingLabel.hidden = NO;
            self.noFollowingImgView.hidden = NO;
        } else {
            self.noFollowingLabel.hidden = YES;
            self.noFollowingImgView.hidden = YES;
        }
    }
     Failure:^{
        // 提示失败
        [NewQAHud showHudWith:@" 没有网络!即将退出这个界面. "
                      AddView:self.view
                      AndToDo:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)configureView {
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:RGBColor(251, 252, 255, 1) darkColor:UIColor.blackColor];
    self.VCTitleStr = @"详情";
    self.titleColor = [UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 1) darkColor:RGBColor(223, 223, 227, 1)];
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    self.topBarBackgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
    self.backBtnImage = [UIImage imageNamed:@"navBar_back"];
    
    // segmentView
    [self.view addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.right.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topBarView.mas_bottom);
        make.height.mas_equalTo(56);
    }];
    
    // horizontalScrollView
    [self.view addSubview:self.horizontalScrollView];
    [self.horizontalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    //FansTableView
    [self.horizontalScrollView addSubview:self.fansTableView];
    [self.fansTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.horizontalScrollView);
        make.size.mas_equalTo(self.horizontalScrollView);
    }];
    
    //FollowingTableView
    [self.horizontalScrollView addSubview:self.followersTableView];
    [self.followersTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self.horizontalScrollView);
        make.size.mas_equalTo(self.horizontalScrollView);
        make.left.mas_equalTo(self.fansTableView.mas_right);
    }];
    
    //无粉丝时
    [self.fansTableView addSubview:self.noFansLabel];
    [self.noFansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.fansTableView);
    }];

    [self.fansTableView addSubview:self.noFansImgView];
    [self.noFansImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.fansTableView);
        make.bottom.mas_equalTo(self.noFansLabel.mas_top);
    }];

    self.noFansLabel.hidden = YES;
    self.noFansImgView.hidden = YES;

    //无关注
    [self.followersTableView addSubview:self.noFollowingLabel];
    [self.noFollowingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.followersTableView);
    }];

    [self.followersTableView addSubview:self.noFollowingImgView];
    [self.noFollowingImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.followersTableView);
        make.bottom.mas_equalTo(self.noFollowingLabel.mas_top);
    }];

    self.noFollowingLabel.hidden = YES;
    self.noFollowingImgView.hidden = YES;
    self.segmentView.selectedIndex = 0;
}
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    CGPoint offset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
    NSInteger currentIndex = (NSInteger)offset.x / self.horizontalScrollView.frame.size.width + 0.5;
    
    if (self.segmentView.selectedIndex == currentIndex) {
        return;
    }
    self.segmentView.selectedIndex = currentIndex;
}
#pragma mark - delegate

//MARK:点击右侧的按钮

- (void)tableViewCell:(UITableViewCell *)cell
              Clicked:(nonnull UIButton *)sender {
    NSIndexPath * indexPath = [self.fansTableView indexPathForCell:cell];
    FansAndFollowersModel * model = self.fansAry[indexPath.row];
    [PMPInfoModel
     focusWithRedid:model.redid
     success:^(BOOL isSuccess) {
        if (isSuccess) {
            model.is_focus = !model.is_focus;
            [(FollowersTableViewCell *)cell followBtn].selected = model.is_focus;
            [NewQAHud
             showHudWith:[(FollowersTableViewCell *)cell followBtn].selected ?  @"关注成功" : @"取关成功"
             AddView:self.fansTableView];
        }
    }
     failure:^{
        [NewQAHud
         showHudWith:
             [@" 没有网络!"
              stringByAppendingString:sender.selected ? @"取关失败. " : @"关注失败. "]
         AddView:self.fansTableView];
    }];
}

//MARK:SegmentViewDelegate

- (void)segmentView:(FansAndFollowingSegmentView *)segmentView alertWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.5 animations:^{
        self.horizontalScrollView.contentOffset = CGPointMake(self.view.frame.size.width * index, 0);
    }];
}

//MARK:table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:self.fansTableView]) {
        FansAndFollowersModel * model = self.fansAry[indexPath.row];
        PMPHomePageViewController * vc = [[PMPHomePageViewController alloc] initWithRedid:model.redid];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([tableView isEqual:self.followersTableView]) {
        FansAndFollowersModel * model = self.followAry[indexPath.row];
        PMPHomePageViewController * vc = [[PMPHomePageViewController alloc] initWithRedid:model.redid];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // you can do any else here
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.fansTableView]) {
        FansTableViewCell * fansCell = (FansTableViewCell *)cell;
        fansCell.cellModel = self.fansAry[indexPath.row];
    }
    else if ([tableView isEqual:self.followersTableView]) {
        FollowersTableViewCell * followersCell = (FollowersTableViewCell *)cell;
        followersCell.cellModel = self.followAry[indexPath.row];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.fansTableView]) {
        return self.fansAry.count;
    } else if ([tableView isEqual:self.followersTableView]) {
        return self.followAry.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.fansTableView]) {
        FansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FansTableViewCell.reuseIdentifier];
        cell.delegate = self;
        return cell;
    } else if ([tableView isEqual:self.followersTableView]) {
        FollowersTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:FollowersTableViewCell.reuseIdentifier];
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

#pragma mark - getter

- (FansAndFollowingSegmentView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[FansAndFollowingSegmentView alloc] initWithTitles:[self.currentRedid isEqualToString:[UserItem defaultItem].redid] ? @[@"我的粉丝", @"我的关注"] : @[@"Ta的粉丝", @"Ta的关注"]];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (UIScrollView *)horizontalScrollView {
    if (_horizontalScrollView == nil) {
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame:(CGRectZero)];
        _horizontalScrollView.backgroundColor = [UIColor dm_colorWithLightColor:UIColor.whiteColor darkColor:UIColor.blackColor];
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        _horizontalScrollView.pagingEnabled = YES;
        [_horizontalScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
        _horizontalScrollView.layer.cornerRadius = 10;
        _horizontalScrollView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.08].CGColor;
        _horizontalScrollView.layer.shadowOpacity = 0.4;
        _horizontalScrollView.layer.shadowOffset = CGSizeMake(0, -5);
        _horizontalScrollView.clipsToBounds = NO;
    }
    return _horizontalScrollView;
}

- (UITableView *)fansTableView {
    if (_fansTableView == nil) {
        _fansTableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _fansTableView.delegate = self;
        _fansTableView.dataSource = self;
        _fansTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _fansTableView.backgroundColor = [UIColor clearColor];
        _fansTableView.rowHeight = 74;
        _fansTableView.layer.cornerRadius = 10;
        [_fansTableView registerClass:[FansTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FansTableViewCell class])];
    }
    return _fansTableView;
}

- (UITableView *)followersTableView {
    if (_followersTableView == nil) {
        _followersTableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _followersTableView.delegate = self;
        _followersTableView.dataSource = self;
        _followersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _followersTableView.backgroundColor = [UIColor clearColor];
        _followersTableView.rowHeight = 74;
        _followersTableView.layer.cornerRadius = 10;
        [_followersTableView registerClass:[FollowersTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FollowersTableViewCell class])];
    }
    return _followersTableView;
}

///无粉丝图片与文字
- (UILabel *)noFansLabel {
    if (_noFansLabel == nil) {
        _noFansLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _noFansLabel.textColor =
        [UIColor dm_colorWithLightColor:RGBColor(17, 44, 84, 1) darkColor:RGBColor(223, 223, 227, 1)];
        _noFansLabel.text = [self.currentRedid isEqualToString:[UserItem defaultItem].redid] ? @"关注你的人正在山上..." : @"暂时没有人关注他呢...";
        _noFansLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
    }
    return _noFansLabel;
}
- (UIImageView *)noFansImgView {
    if (_noFansImgView == nil) {
        _noFansImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_fans"]];
    }
    return _noFansImgView;
}
///无关注图片与文字
- (UILabel *)noFollowingLabel {
    if (_noFollowingLabel == nil) {
        _noFollowingLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _noFollowingLabel.textColor = [UIColor dm_colorWithLightColor:RGBColor(17, 44, 84, 1) darkColor:RGBColor(223, 223, 227, 1)];
        _noFollowingLabel.text = [self.currentRedid isEqualToString:[UserItem defaultItem].redid] ? @"快去搜索发现可爱的挚友吧..." : @"他还没有关注任何掌友...";
        _noFollowingLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
    }
    return _noFollowingLabel;
}
- (UIImageView *)noFollowingImgView {
    if (_noFollowingImgView == nil) {
        _noFollowingImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_followers"]];
    }
    return _noFollowingImgView;
}

@end
