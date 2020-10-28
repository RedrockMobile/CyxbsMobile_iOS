//
//  QueryViewController.m
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 05/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//
#import "QueryHeader.h"
#import "QueryViewController.h"
#import "QueryTableViewCell.h"
#import "QueryLoginViewController.h"
#import "AllYearsViewController.h"
#import "MineViewController.h"
#import "HeaderGifRefresh.h"
#import "VolunteerItem.h"
#import "NoLoginView.h"
//#import "LoginViewController.h"
#import "DiscoverViewController.h"

@interface QueryViewController() <UIScrollViewDelegate>

@property (nonatomic,strong) NoLoginView *noLoginView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIButton *allYears;
@property (nonatomic, strong) QueryHeader *headView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *subViewControllers;

@property (nonatomic, weak) UILabel *centerTitle;
@property (nonatomic, weak) UIButton * removeBind;
@property (nonatomic, weak)UIImageView *toolBarImageView;
@property (nonatomic, weak)UIButton *backButton;
@property (nonatomic, strong) AllYearsViewController *yearsVC;

@end

@implementation QueryViewController

- (instancetype)initWithVolunteerItem: (VolunteerItem *)volunteer {
    self = [self init];
    self.volunteer = volunteer;
    return self;
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    [self makeContains];//对按钮进行约束布局
    [self addViewControllsToScrollView];
}

- (void)buildUI {
    self.navigationController.navigationBar.hidden = YES;
    UIImageView *toolBarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,HEADERHEIGHT)];
    self.toolBarImageView = toolBarImageView;
    toolBarImageView.image = [UIImage imageNamed:@"toolbar_background"];
    [self.view addSubview:toolBarImageView];
    self.selectedIndex = 0;
    
    int heightH = (STATUSBARHEIGHT+HEADERHEIGHT/2)-(18.f/667)*MAIN_SCREEN_H;
//    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake((16.f/375)*MAIN_SCREEN_W,heightH,(12.f/375)*MAIN_SCREEN_W,(20.f/667)*MAIN_SCREEN_H)];
    UIButton *back = [[UIButton alloc]init];
    self.backButton = back;
    [back addTarget:self action:@selector(clickedBackButton) forControlEvents:UIControlEventTouchUpInside];
    [back setBackgroundImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [self.view addSubview:back];
    
    int padding = (155.f/375)*MAIN_SCREEN_W;
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(padding, heightH, MAIN_SCREEN_W-padding*2, (19.f/667)*MAIN_SCREEN_H)];
    UILabel *title = [[UILabel alloc]init];
    self.centerTitle = title;
    title.text = @"全部";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = [UIColor whiteColor];
    [self.view addSubview:title];
    
    //解除绑定button
//    UIButton *removeBind = [[UIButton alloc]initWithFrame:CGRectMake((280.f/375)*MAIN_SCREEN_W,heightH,(84.f/375)*MAIN_SCREEN_W,(18.f/667)*MAIN_SCREEN_H)];
    UIButton * removeBind = [[UIButton alloc]init];
    self.removeBind = removeBind;
    [removeBind addTarget:self action:@selector(buttonActionRemove) forControlEvents:UIControlEventTouchUpInside];
    [removeBind setBackgroundColor:[UIColor clearColor]];
    [removeBind setTitle:@"解绑账号" forState:UIControlStateNormal];
    removeBind.titleLabel.font = [UIFont systemFontOfSize:14];
    removeBind.titleLabel.textAlignment = NSTextAlignmentCenter;
    [removeBind setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:removeBind];
    //全部展开button
//    self.allYears = [[UIButton alloc]initWithFrame:CGRectMake(MAIN_SCREEN_W/2+(MAIN_SCREEN_W-padding*2)/2,heightH+6,(15.f/375)*MAIN_SCREEN_W,(8.f/667)*MAIN_SCREEN_H)];
    self.allYears = [[UIButton alloc]init];
    
    [self.allYears addTarget:self action:@selector(buttonActionUnfold) forControlEvents:UIControlEventTouchUpInside];
    [self.allYears setBackgroundImage:[UIImage imageNamed:@"展开后"] forState:UIControlStateNormal];
    [self.view addSubview:self.allYears];
    
    __weak typeof(self) weakSelf = self;
    self.view.backgroundColor=[UIColor whiteColor];
    _headView = [[QueryHeader alloc]initWithFrame:CGRectMake(0, HEADERHEIGHT, SCREEN_WIDTH, 39)];
    NSDate  *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger year=[components year];
    NSString *yearString = [NSString stringWithFormat:@"%ld",year];
    NSString *yearString1 = [NSString stringWithFormat:@"%ld",year-1];
    NSString *yearString2 = [NSString stringWithFormat:@"%ld",year-2];
    NSString *yearString3 = [NSString stringWithFormat:@"%ld",year-3];
    _headView.items = [NSArray arrayWithObjects:@"全部",yearString,yearString1,yearString2,yearString3, nil];;
    _headView.itemClickAtIndex = ^(NSInteger index){
        [weakSelf adjustScrollView:index];
        title.text = weakSelf.headView.items[index];
    };
    [self.view addSubview:_headView];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headView.frame),SCREEN_WIDTH,SCREEN_HEIGHT-CGRectGetMaxY(_headView.frame))];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*5, self.scrollView.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.directionalLockEnabled = YES;
    [self.view addSubview:self.scrollView];
}

#pragma mark - 添加子控制器
- (void)addViewControllsToScrollView {
    for (NSInteger index = 0; index < 5; index++) {
        self.yearsVC = [[AllYearsViewController alloc] initWithVolunteer:self.volunteer andYearIndex:index];
        self.yearsVC.view.frame = CGRectMake(_scrollView.bounds.size.width * index, 0, _scrollView.bounds.size.width, MAIN_SCREEN_H - HEADERHEIGHT);
        //    self.allYearsVC.tableView.mj_header = [HeaderGifRefresh headerWithRefreshingTarget:self refreshingAction:@selector(refresh:)];
        [_scrollView addSubview: self.yearsVC.view];
        //self.scrollView.backgroundColor = backgroundColor;
        [self addChildViewController: self.yearsVC];
    }
}

#pragma mark - 按钮的actions
// 返回按钮
- (void)clickedBackButton {
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    if ([user objectForKey:@"volunteer_account"]) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[DiscoverViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
//        return;
//    }
//    [self.navigationController popViewControllerAnimated:YES];
}

// 取消绑定
- (void)buttonActionRemove{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"亲，真的要取消已经绑定的账号咩" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [user removeObjectForKey:@"volunteer_account"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeVolunteerAccount" object:nil];
        [user synchronize];
        
//        [self.navigationController popViewControllerAnimated:YES];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[DiscoverViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }];
    [alertC addAction:cancel];
    [alertC addAction:confirm];
    [self presentViewController:alertC animated:YES completion:nil];
}

// 年份折叠与展开
- (void)buttonActionUnfold{
    // 展开
    if (_headView.hidden) {
        _headView.hidden = NO;
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.allYears.transform = CGAffineTransformMakeScale(1, 1);
            _headView.frame = CGRectMake(0, HEADERHEIGHT, SCREEN_WIDTH, 39);
            _scrollView.frame = CGRectMake(0, 39+HEADERHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-HEADERHEIGHT-39);
            
            for (int i = 0; i < self.childViewControllers.count; i++) {
                ((AllYearsViewController *)self.childViewControllers[i]).tableView.frame = CGRectMake(0, 0, MAIN_SCREEN_W, SCREEN_HEIGHT-HEADERHEIGHT - 39);
            }
        } completion:^(BOOL finished) {
            
        }];
    }
    // 折叠
    else {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _headView.frame = CGRectMake(0, HEADERHEIGHT, SCREEN_WIDTH, 0);
            self.allYears.transform = CGAffineTransformMakeScale(1, -1);
            _scrollView.frame = CGRectMake(0, HEADERHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-HEADERHEIGHT);
            
            for (int i = 0; i < self.childViewControllers.count; i++) {
                ((AllYearsViewController *)self.childViewControllers[i]).tableView.frame = CGRectMake(0, 0, MAIN_SCREEN_W, SCREEN_HEIGHT-HEADERHEIGHT);
            }
        } completion:^(BOOL finished) {
            _headView.hidden = YES;
        }];
    }
}

#pragma mark - 滚动ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = round(self.scrollView.contentOffset.x / self.scrollView.bounds.size.width);
    if (self.selectedIndex != index) {
        [self.scrollView setContentOffset:CGPointMake(index*scrollView.bounds.size.width, 0) animated:YES];
        [_headView setSelectAtIndex:index];
        self.selectedIndex = index;
    }
}

- (void)adjustScrollView:(NSInteger)index{
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.contentOffset = CGPointMake(index*self.scrollView.bounds.size.width, 0);
    }];
}

-(void)changeScrollview:(NSInteger)index{
    
    [UIView animateWithDuration:0.1f animations:^{
        self.scrollView.contentOffset = CGPointMake(index*self.scrollView.bounds.size.width, 0);
    }];
    
}
-(void)makeContains{
     [self.centerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.toolBarImageView);
         make.centerY.equalTo(self.toolBarImageView).offset(15);
    }];
//    UIBarButtonItem *removeBindButton = [[UIBarButtonItem alloc]initWithTitle:@"解除绑定" style:UIBarButtonItemStylePlain target:self action:@selector(buttonActionRemove)];
//    [self.navigationItem setRightBarButtonItem:removeBindButton];
    [self.removeBind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.toolBarImageView).offset(-10);
        make.centerY.equalTo(self.centerTitle);
    }];
    [self.allYears mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerTitle.mas_right).offset(5);
        make.centerY.equalTo(self.centerTitle);
        make.height.equalTo(@10);
        make.width.equalTo(@16);
        
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerTitle);
        make.left.equalTo(self.toolBarImageView).offset(10);
        make.height.equalTo(@16);
        make.width.equalTo(@10);
    }];
}
@end
