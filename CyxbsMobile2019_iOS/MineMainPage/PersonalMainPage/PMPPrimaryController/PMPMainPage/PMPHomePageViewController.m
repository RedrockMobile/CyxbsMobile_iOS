//
//  PMPHomePageViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPHomePageViewController.h"
#import "PMPFansAndFollowingViewController.h"
// view
#import "PMPGestureScrollView.h"
#import "PMPHomePageHeaderView.h"
#import "JHPageController.h"
#import "PMPDynamicTableViewController.h"
#import "PMPIdentityTableViewController.h"
// models
#import "PMPInfoModel.h"
#import "PMPFansFollowsAndPraiseModel.h"
// tool
#import "NewQAHud.h"
// secondaryController
#import "PMPFansAndFollowingViewController.h"

@interface PMPHomePageViewController ()
<UIScrollViewDelegate,
PMPHomePageHeaderViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>
/// 背景图片
@property (nonatomic, strong) UIImageView * backgroundImageView;
/// 毛玻璃效果
@property (nonatomic, strong) UIVisualEffectView * visualEffectView;
/// 上下滑动的 scrollview
@property (nonatomic, strong) PMPGestureScrollView * containerScrollView;
/// 资料卡
@property (nonatomic, strong) PMPHomePageHeaderView * headerView;
/// pageController的容器
@property (nonatomic, strong) UIView * contentView;
/// 下方的页面
@property (nonatomic, strong) JHPageController * pageController;

/// 在滑到顶部之后展示
@property (nonatomic, strong) UIView * topBarView2;
/// 返回按钮
@property (nonatomic,strong) UIButton * backBtn2;
/// 控制器标题
@property (nonatomic,strong) UILabel * VCTitleLabel2;

// 数据
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, strong) NSArray * titles;
/// 当前的控制器的redid
@property (nonatomic, copy) NSString * currentRedid;

@property (nonatomic, strong) PMPDynamicTableViewController * dynamicTVC;
@property (nonatomic, strong) PMPIdentityTableViewController * identityTVC;

@property (nonatomic, assign) BOOL canScroll;


@property (nonatomic, strong) PMPInfoModel * infoModel;
@property (nonatomic, strong) PMPFansFollowsAndPraiseModel * fansFollowsAndPriseModel;

@end

@implementation PMPHomePageViewController

- (instancetype)initWithRedid:(NSString *)redid {
    self = [super init];
    if (self) {
        // 经过计算, headerView 在 iPhone X 的高度为 380
        _headerViewHeight = (380 / 812.f) * MAIN_SCREEN_H;
        _canScroll = YES;
        _currentRedid = redid;
    }
    return self;
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    [self loadInfoData];
//    [self configureView];
//    [self addNotification];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear: animated];
//    // 每次进入这个界面的时候刷新
//    [self loadFansAndFollowersData];
//}
//
//- (void)loadInfoData {
//
//    [PMPInfoModel
//     getDataWithRedid:self.currentRedid
//     Success:^(PMPInfoModel * _Nonnull infoModel) {
//        self.infoModel = infoModel;
//        self.infoModel.isSelf = [infoModel.redid isEqualToString:[UserItem defaultItem].redid];
//        self.VCTitleLabel2.text = infoModel.nickname;
//        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.background_url] placeholderImage:[UIImage imageNamed:@"UserDefaultBackgroundImg"] options:SDWebImageRefreshCached];
//        [self.headerView
//         refreshDataWithNickname:infoModel.nickname
//         grade:infoModel.grade
//         constellation:infoModel.constellation
//         gender:infoModel.gender
//         introduction:infoModel.introduction
//         uid:infoModel.uid
//         photo_src:infoModel.photo_src
//         isSelf:infoModel.isSelf
//         identityies:infoModel.identityies
//         isFocus:infoModel.isFocus];
//    }
//     failure:^{
//        // 提示失败
//        [NewQAHud showHudWith:@" 没有网络!即将退出这个界面. "
//                      AddView:self.view
//                      AndToDo:^{
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//    }];
//}
//
//- (void)loadFansAndFollowersData {
//    // 更新用户的关注,粉丝数量
//    [PMPFansFollowsAndPraiseModel
//     getDataWithRedid:self.currentRedid
//     success:^(PMPFansFollowsAndPraiseModel * model) {
//        self.fansFollowsAndPriseModel = model;
//        [self.headerView refreshDataWithFans:model.fans
//                                     follows:model.follows
//                                      praise:model.praise];
//    }
//     failure:^{
//        [NewQAHud showHudWith:@" 获取粉丝/关注失败! "
//                      AddView:self.view];
//    }];
//}
//
//#pragma mark - layout
//
//- (void)configureView {
//    // self
//    self.VCTitleStr = @"个人主页";
//    self.topBarBackgroundColor = [UIColor clearColor];
//
//    // self.backgoundImageView
//    [self.view addSubview:self.backgroundImageView];
//    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.mas_equalTo(self.view);
//        make.height.mas_equalTo(self.view.mas_height).multipliedBy(0.585);
//    }];
//    // Blur effect 模糊效果
//    //    [self.view layoutIfNeeded];
//    //    self.visualEffectView.frame = self.backgroundImageView.bounds;
//    [self.backgroundImageView addSubview:self.visualEffectView];
//    [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.centerX.centerY.mas_equalTo(self.backgroundImageView);
//    }];
//
//    // self.containerScrollView
//    [self.view addSubview:self.containerScrollView];
//    [self.containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.top.right.equalTo(self.view);
//    }];
//    /// 这样设置才能成为 没有隐藏navigationBar时的高度
//    self.containerScrollView.jh_contentInset_top = 44;
//
//    // self.headerView
//    [self.containerScrollView addSubview:self.headerView];
//    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.containerScrollView).offset(self.headerViewHeight / 2);
//        make.left.right.mas_equalTo(self.containerScrollView);
//        make.width.mas_equalTo(self.containerScrollView);
//        make.height.mas_equalTo(self.headerViewHeight);
//    }];
//
//    [self.containerScrollView addSubview:self.contentView];
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.headerView.mas_bottom).offset(- self.headerViewHeight / 2 - self.pageController.menuHeight);
//        make.left.right.bottom.mas_equalTo(self.containerScrollView);
//        make.width.mas_equalTo(self.containerScrollView);
//        make.height.mas_equalTo(self.containerScrollView).offset(-self.getTopBarViewHeight);
//    }];
//
//    [self.contentView addSubview:self.pageController.view];
//    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.left.bottom.mas_equalTo(self.contentView);
//    }];
//
//    [self.view addSubview:self.topBarView2];
//    [self.topBarView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.height.mas_equalTo(44 + getStatusBarHeight_Double);
//    }];
//    // configure backBtn
//    [self.topBarView2 addSubview:self.backBtn2];
//    [self.backBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.topBarView2);
//        make.bottom.equalTo(self.topBarView2);
//        make.height.width.mas_equalTo(44);
//    }];
//
//    [self.topBarView2 addSubview:self.VCTitleLabel2];
//    [self.VCTitleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.backBtn2);
//        make.left.mas_equalTo(self.backBtn2.mas_right);
//    }];
//
//    [self.view bringSubviewToFront:self.topBarView];
//    [self.view bringSubviewToFront:self.topBarView2];
//}
//
//#pragma mark - notification
//
//- (void)addNotification {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeLeaveTopNotification object:nil];
//}
//
//- (void)acceptMsg : (NSNotification *)notification {
//    NSDictionary * userInfo = notification.userInfo;
//    NSString * canScroll = userInfo[@"canScroll"];
//    if ([canScroll isEqualToString:@"1"]) {
//        _canScroll = YES;
//    }
//}
//
//#pragma mark - scrollview delegate
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat maxOffsetY = self.headerViewHeight - self.getTopBarViewHeight - self.pageController.menuHeight;
//    CGFloat offsetY = scrollView.jh_contentOffset_y;
//    // 透明度
//    self.topBarView.alpha = 1 - (offsetY + self.getTopBarViewHeight) / self.headerViewHeight;
//    // 头视图的大小
//    CGFloat scale = 1 - (offsetY + self.getTopBarViewHeight)  / self.headerViewHeight;
//    if (scale < 0) {
//        scale = 0;
//    } else if (scale > 1) {
//        scale = 1;
//    }
//    self.headerView.transform = CGAffineTransformMakeScale(scale, scale);
//
//    if (offsetY >= maxOffsetY) {
//        //将头视图滑动到刚好隐藏及其继续上划的位置
//        scrollView.contentOffset = CGPointMake(0, maxOffsetY);
//        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeGoTopNotification object:nil userInfo:@{@"canScroll":@"1"}];
//        _canScroll = NO;
//    } else {
//        if (_canScroll == NO) {
//            // 这个代码的作用:将底部的因safeArea而存在的偏移量抵消
//            scrollView.contentOffset = CGPointMake(0, maxOffsetY);
//        }
//    }
//
//    self.topBarView2.hidden = offsetY >= maxOffsetY / 3 * 2 ? NO : YES;
//    self.visualEffectView.hidden = offsetY >= maxOffsetY / 3 * 2 ? NO : YES;
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
//                  willDecelerate:(BOOL)decelerate {
//    CGFloat maxOffsetY = self.headerViewHeight - self.getTopBarViewHeight - self.pageController.menuHeight;
//    CGFloat offsetY = scrollView.jh_contentOffset_y;
//
//    [self.containerScrollView setContentOffset:offsetY <= maxOffsetY / 3 * 2 ? CGPointMake(0, -[self getTopBarViewHeight]) : CGPointMake(0, maxOffsetY + self.pageController.menuHeight) animated:YES];
//}
//
//#pragma mark - PMPHomePageHeaderViewDelegate
//
//- (void)textButtonClickedWithIndex:(NSUInteger)index {
//    if (index == 2) {
//        return;
//    }
//    PMPFansAndFollowingViewController * vc = [[PMPFansAndFollowingViewController alloc] initWithRedid:self.currentRedid];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (void)editingButtonClicked {
//    NSLog(@"editing");
//    EditMyInfoViewController *vc = [[EditMyInfoViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (void)backgroundViewClicked {
//    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//    controller.allowsEditing = YES;
//    controller.delegate = self;
//    [self presentViewController:controller animated:YES completion:nil];
//}
//
//- (void)followButtonClicked:(UIButton *)sender {
//    NSLog(@"%@", sender);
//    [PMPInfoModel
//     focusWithRedid:self.currentRedid
//     success:^(BOOL isSuccess) {
//        if (isSuccess) {
//            self.infoModel.isFocus = !self.infoModel.isFocus;
//            [self.headerView changeFollowStateSelected:self.infoModel.isFocus];
//            [NewQAHud
//             showHudWith:self.infoModel.isFocus ?  @"关注成功" : @"取关成功"
//             AddView:self.view];
//        }
//    }
//     failure:^{
//        [NewQAHud
//         showHudWith:
//             [@" 没有网络!"
//              stringByAppendingString:self.infoModel.isFocus ? @"取关失败. " : @"关注失败. "]
//         AddView:self.view];
//    }];
//}
//
//#pragma mark - UIImagePickerControllerDelegate
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
//    UIImage * image = info[UIImagePickerControllerEditedImage];
//    [self dismissViewControllerAnimated:YES completion:^{
//        [PMPInfoModel
//         uploadbackgroundImage:image
//         success:^(NSDictionary * _Nonnull dict) {
//            self.backgroundImageView.image = image;
//        }
//         failure:^(NSError * _Nonnull error) {
//            [NewQAHud showHudWith:@" 更换失败! " AddView:self.view];
//        }];
//    }];
//}
//
//#pragma mark - lazy
//
//- (UIImageView *)backgroundImageView {
//    if (_backgroundImageView == nil) {
//        _backgroundImageView = [[UIImageView alloc] init];
//        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
//        _backgroundImageView.backgroundColor = [UIColor clearColor];
//    }
//    return _backgroundImageView;
//}
//
//- (UIVisualEffectView *)visualEffectView {
//    if (_visualEffectView == nil) {
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    }
//    return _visualEffectView;
//}
//
//- (PMPGestureScrollView *)containerScrollView {
//    if (!_containerScrollView) {
//        _containerScrollView = [[PMPGestureScrollView alloc] init];
//        _containerScrollView.backgroundColor = [UIColor clearColor];
//        _containerScrollView.delegate = self;
//        _containerScrollView.showsVerticalScrollIndicator = NO;
//    }
//    return _containerScrollView;
//}
//
//- (PMPHomePageHeaderView *)headerView {
//    if (_headerView == nil) {
//        _headerView = [[PMPHomePageHeaderView alloc] init];
//        _headerView.delegate = self;
//        _headerView.layer.anchorPoint = CGPointMake(0.5, 1);
//    }
//    return _headerView;
//}
//
//- (UIView *)contentView {
//    if (_contentView == nil) {
//        _contentView = [[UIView alloc] init];
//        _contentView.backgroundColor = [UIColor clearColor];
//    }
//    return _contentView;
//}
//
//- (JHPageController *)pageController {
//    if (_pageController == nil) {
//        _pageController = [[JHPageController alloc] initWithTitles:self.titles Controllers:@[self.dynamicTVC, self.identityTVC]];
//    }
//    return _pageController;
//}
//
//- (NSArray *)titles {
//    if (_titles == nil) {
//        _titles = @[
//            @"我的动态",
//            @"我的身份",
//        ];
//    }
//    return _titles;
//}
//
//- (PMPDynamicTableViewController *)dynamicTVC {
//    if (_dynamicTVC == nil) {
//        _dynamicTVC = [[PMPDynamicTableViewController alloc] initWithStyle:UITableViewStylePlain redid:self.currentRedid];
//        [self addChildViewController:_dynamicTVC];
//    }
//    return _dynamicTVC;
//}
//
//- (PMPIdentityTableViewController *)identityTVC {
//    if (_identityTVC == nil) {
//        _identityTVC = [[PMPIdentityTableViewController alloc] initWithStyle:UITableViewStylePlain redid:self.currentRedid];
//        [self addChildViewController:_identityTVC];
//    }
//    return _identityTVC;
//}
//
//- (UIView *)topBarView2 {
//    if (_topBarView2 == nil) {
//        _topBarView2 = [[UIView alloc] initWithFrame:(CGRectZero)];
//        _topBarView2.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
//    }
//    return _topBarView2;
//}
//
//- (UIButton *)backBtn2 {
//    if (_backBtn2 == nil) {
//        _backBtn2 = [[UIButton alloc] initWithFrame:(CGRectZero)];
//        [_backBtn2 setImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
//        [_backBtn2 addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        _backBtn2.layer.cornerRadius = 10;
//        _backBtn2.backgroundColor = [UIColor clearColor];
//    }
//    return _backBtn2;
//}
//
//- (UILabel *)VCTitleLabel2 {
//    if (_VCTitleLabel2 == nil) {
//        _VCTitleLabel2 = [[UILabel alloc] initWithFrame:(CGRectZero)];
//        _VCTitleLabel2.font = [UIFont fontWithName:PingFangSCSemibold size:22];
//        _VCTitleLabel2.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
//        [_VCTitleLabel2 sizeToFit];
//    }
//    return _VCTitleLabel2;
//}


- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:UIColor.whiteColor darkColor:UIColor.blackColor];
    
    [self setBackButton];
    [self addStopView];
}

//服务功能暂停页
- (void)addStopView{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"人在手机里"]];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-20);
    }];
    
    UILabel *Lab = [[UILabel alloc] init];
    Lab.text = @"服务升级ing...敬请期待";
    Lab.font = [UIFont fontWithName:PingFangSCLight size: 12];
    Lab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#112C54" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    [self.view addSubview:Lab];
    [Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imgView.mas_bottom).offset(16);
    }];
}

- (void)setBackButton {
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setImage:[UIImage imageNamed:@"我的返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(STATUSBARHEIGHT + 15);
        make.leading.equalTo(self.view).offset(15);
        make.height.equalTo(@19);
        make.width.equalTo(@9);
    }];
}

/// 点击 返回按钮 后调用的方法
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
