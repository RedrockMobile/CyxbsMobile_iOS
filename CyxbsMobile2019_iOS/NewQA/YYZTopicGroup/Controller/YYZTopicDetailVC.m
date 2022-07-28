//
//  YYZTopicDetailVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 杨远舟 on 2021/3/16.
//  Copyright © 2021 Redrock. All rights reserved.
//
#import "YYZTopicDetailVC.h"
#import "YYZTopicGroupVC.h"
#import "YYZTopicCell.h"
#import "PostTableViewCell.h"
#import "PostArchiveTool.h"
#import "DynamicDetailMainVC.h"
#import "ClassTabBar.h"
#import "StarPostModel.h"
#import "YYZTopicModel.h"
#import "PostItem.h"
#import "MGDRefreshTool.h"
#import "MGDCurrentTimeStr.h"
#import "FollowGroupModel.h"
#import "ShieldModel.h"
#import "ReportModel.h"
#import "DeletePostModel.h"
#import "PostTableViewCellFrame.h"
#import <objc/runtime.h>


    
@interface YYZTopicDetailVC ()
<UITableViewDelegate,
UITableViewDataSource,
PostTableViewCellDelegate,
UITableViewDelegate,
ReportViewDelegate,
FuncViewProtocol,
ShareViewDelegate,
UIScrollViewDelegate,
SelfFuncViewProtocol,
UIGestureRecognizerDelegate>
@property(nonatomic,strong ) NSArray *array;  //所有圈子信息
@property(nonatomic,strong) YYZTopicCell *cell; //顶部cell
@property(nonatomic,strong) UIScrollView *backgroundScrollView;//最底部的scrollview
@property(nonatomic,strong) UIScrollView *topicScrollView;//在tableview下面的scrollview
@property(nonatomic,strong) UITableView *topicLeftTableView;
@property(nonatomic,strong) UITableView *topicRightTableView;
@property(nonatomic,strong) UIButton *leftButton; //最新按钮
@property(nonatomic,strong) UIButton *rightButton; //热门按钮
@property(nonatomic,strong) UIImageView *changeImageView; //按钮下面的蓝绿色提示线
//帖子数据,left为"最新",right为"热门"
@property (nonatomic, assign) NSInteger leftPage;
@property (nonatomic, strong) NSMutableArray *leftTableArray;
@property (nonatomic, strong) YYZTopicModel *leftPostmodel;
@property (nonatomic, assign) NSInteger rightPage;
@property (nonatomic, strong) NSMutableArray *rightTableArray;
@property (nonatomic, strong) YYZTopicModel *rightPostmodel;
//获取cell里item数据的NSDictionary
@property (nonatomic, strong) NSDictionary *itemDic;
//列表顶部底部刷新控件
@property (nonatomic, strong) MJRefreshBackNormalFooter *footer;
@property (nonatomic, strong) MJRefreshNormalHeader *header;

@property (nonatomic, assign) NSInteger cnt1;
@property (nonatomic, assign) NSInteger cnt2;
@property (nonatomic, assign) NSInteger offestInt;
@property (nonatomic, assign) NSInteger stausHeight;
@property (nonatomic, assign) NSInteger navHeight;

/// 是否已经显示reportView
@property (nonatomic, assign) BOOL isShowedReportView;
@property (nonatomic, assign) BOOL isChanged;

@end

@implementation YYZTopicDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isChanged = NO;
    self.leftPage = 1;//初始化当前页数
    self.rightPage = 1;
    //网络请求
    
    [HttpTool.shareTool
     request:NewQA_POST_QATopicGroup_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSArray *array = object[@"data"];
        self.array = array;
        [self setCell];  //设置cell;
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NewQAHud showHudWith:@"请求失败,请检查网络" AddView:self.view];
    }];
    
//    [[HttpClient defaultClient]requestWithPath:NewQA_POST_QATopicGroup_API method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSArray *array = responseObject[@"data"];
//        self.array = array;
//        [self setCell];//设置cell;
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            [NewQAHud showHudWith:@"请求失败,请检查网络" AddView:self.view];
//        }];
    
    //设置导航栏
    self.tabBarController.tabBar.hidden = YES;//隐藏tabbar
    self.navigationController.navigationBar.hidden = NO;//显示nav_bar
    self.navigationItem.title = @"";
    
    //按钮标题的宽度
    CGFloat stringWidth = [self.topicIdString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:21]} context:0].size.width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, stringWidth + 40 + 5, 40)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 13, 7, 14)];
    imageView.image = [UIImage imageNamed:@"返回的小箭头"];
    [view addSubview:imageView];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, stringWidth, 40)];
    titleLbl.text = self.topicIdString;
    [titleLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    titleLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
    [view addSubview:titleLbl];
    view.userInteractionEnabled = YES;
    //添加返回的手势
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpRootViewController)];
    [view addGestureRecognizer:gesture];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *spacebutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacebutton.width = -1000;//这个数值可以调整
    self.navigationItem.leftBarButtonItems = @[spacebutton,leftBarItem];
        self.navigationController.navigationBar.barTintColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F0F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
    self.navigationController.navigationBar.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F0F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
    self.navigationController.navigationBar.tintColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#748AAF" alpha:1] darkColor:[UIColor colorWithHexString:@"#5A5A5A" alpha:1]];//设置颜色
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.cnt1=0;
    self.cnt2=0;
    _isChanged = NO;
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    self.stausHeight = rectStatus.size.height;  // 高度
   // 导航栏（navigationbar）
    CGRect rectNav = self.navigationController.navigationBar.frame;
    self.navHeight = rectNav.size.height;  // 高度
    // 如果是刘海屏
        if ([self isNotchScreen] == YES) {
            self.navHeight  += 35;
        }
    [self setNotification];//设置通知中心
    [self setBackViewWithGesture];//设置弹出view
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F0F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];

    self.leftTableArray = [[NSMutableArray alloc]init];
    self.leftPostmodel = [[YYZTopicModel alloc]init];
    self.rightTableArray = [[NSMutableArray alloc]init];
    self.rightPostmodel = [[YYZTopicModel alloc]init];
    self.heightArray = [NSMutableArray array];
    
    [self setScroll];
    [self setMiddleLable];
    [self setBackTableView];
    [self funcPopViewinit];
    [self loadData];//初始化数据
    
    //[NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(checkContent) userInfo:nil repeats:NO];//判断有无数据，如果没有加载相应图片
}


- (void)setNotification{
    ///帖子列表请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TopicLoadSuccess)
                                                 name:@"TopicDataLoadSuccess" object:nil];
    ///帖子列表请求失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TopicLoadError)
                                                 name:@"TopicDataLoadFailure" object:nil];
    //监听键盘将要消失、出现，以此来动态的设置举报View的上下移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportViewKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportViewKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void) setScroll {
    UIScrollView *backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,getStatusBarHeight_Double, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backgroundScrollView = backgroundScrollView;
    backgroundScrollView.bounces = NO;
    backgroundScrollView.showsVerticalScrollIndicator = FALSE;
    backgroundScrollView.showsHorizontalScrollIndicator = FALSE;
    backgroundScrollView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F0F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
    backgroundScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT+125-getStatusBarHeight_Double-25);
    //设置kvo监听
    [backgroundScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:@"2"];
    [self.view addSubview:backgroundScrollView];
    
    UIScrollView *topicScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, SCREEN_HEIGHT-112)];
    self.topicScrollView = topicScrollView;
    topicScrollView.delegate = self;
    topicScrollView.backgroundColor = [UIColor whiteColor];
    topicScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-185);
    topicScrollView.pagingEnabled = YES;
    topicScrollView.bounces = NO;
    //设置kvo监听
    [topicScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:@"1"];
    [self.backgroundScrollView addSubview:topicScrollView];
    
}

- (void)jumpRootViewController{
    if (self.isFromSub == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        UIViewController *frontVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
        if ([frontVC isKindOfClass:[NewQAMainVC class]]) {
            NewQAMainVC * QAMainVC = (NewQAMainVC *)frontVC;
            QAMainVC.isNeedFresh = _isChanged;
            [self.navigationController popToViewController:QAMainVC animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark- KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]){
        if(context ==  @"1"){
            CGFloat pageWidth = self.topicScrollView.frame.size.width;// 根据当前的x坐标和页宽度计算出当前页数
            int currentPage = floor((self.topicScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            if(currentPage == 0){
                [self.leftButton setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]] forState:UIControlStateNormal];
                [self.rightButton setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#ABBBD7" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]] forState:UIControlStateNormal];
            }
            else if(currentPage == 1){
                [self.topicRightTableView reloadData];
                [self.leftButton setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#ABBBD7" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]] forState:UIControlStateNormal];
                [self.rightButton setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]] forState:UIControlStateNormal];
            }
            //改变提示线位置
            double currentLocation = self.topicScrollView.contentOffset.x/pageWidth;
            self.changeImageView.frame = CGRectMake(13+55*currentLocation,170,40,3);
        }
        if(context ==  @"2"){
            if(self.backgroundScrollView.contentOffset.y <= 1){
                    self.topicLeftTableView.scrollEnabled = NO;
                    self.topicRightTableView.scrollEnabled = NO;
            }
            if(self.backgroundScrollView.contentOffset.y >= 125-self.navHeight-self.stausHeight+4){
                    self.topicLeftTableView.scrollEnabled = YES;
                    self.topicRightTableView.scrollEnabled = YES;
            }
        }
        if(context == @"3"){
            //
        }
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)dealloc{
    [self.topicScrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.backgroundScrollView removeObserver:self forKeyPath:@"contentOffset"];
}
//检查当前在第几页，返回当前页数
- (int)checkPage{
    CGFloat pageWidth = self.topicScrollView.frame.size.width;// 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((self.topicScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    return currentPage;
}
- (void) setBackTableView{
    UITableView *topicLeftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-112) style:UITableViewStylePlain];
    self.topicLeftTableView = topicLeftTableView;
    topicLeftTableView.delegate = self;
    topicLeftTableView.dataSource = self;
    topicLeftTableView.scrollEnabled = NO;
    topicLeftTableView.separatorColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#ABBBD7" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
    [topicLeftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    topicLeftTableView.tableFooterView = [[UIView alloc]init];
    //[topicLeftTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:@"3"];
  
    UITableView *topicRightTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-112) style:UITableViewStylePlain];
    self.topicRightTableView = topicRightTableView;
    topicRightTableView.delegate = self;
    topicRightTableView.dataSource = self;
    topicRightTableView.scrollEnabled = NO;
    topicRightTableView.separatorColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#ABBBD7" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
    [topicRightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    topicRightTableView.tableFooterView = [[UIView alloc]init];
    //[topicRightTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:@"3"];
    
    [self.topicScrollView addSubview:topicLeftTableView];
    [self.topicScrollView addSubview:topicRightTableView];
    [self setUpRefresh];
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self checkPage] == 0)
        return self.leftTableArray.count;
    else
        return self.rightTableArray.count;
}
#pragma mark 设置cell自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostTableViewCellFrame *cellFrame = [[PostTableViewCellFrame alloc] init];
    cellFrame = self.heightArray[indexPath.row];
    return cellFrame.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.topicLeftTableView]){
        [self.topicLeftTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        //创建单元格（用复用池）,给每一个cell的identifier设置为唯一的
        NSString *identifier = [NSString stringWithFormat:@"post%ldcell",indexPath.row];
        PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil) {
            _item = [[PostItem alloc] initWithDic:self.leftTableArray[indexPath.row]];
            //这里
            cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.layer.cornerRadius = 0;
            cell.delegate = self;
            cell.item = _item;
            cell.commendBtn.tag = indexPath.row;
            cell.shareBtn.tag = indexPath.row;
            cell.starBtn.tag = indexPath.row;
            cell.tag = indexPath.row;
            if (cell.tag == 0) {
                cell.layer.cornerRadius = 10;
            }
        }
        cell.cellFrame = self.heightArray[indexPath.row];
        [cell layoutSubviews];
        [cell layoutIfNeeded];
        self.cnt2 = 1;
        return cell;
    }
    else if ([tableView isEqual:self.topicRightTableView]){
        [self.topicRightTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        NSString *identifier = [NSString stringWithFormat:@"post%ldcell",indexPath.row];
        PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil) {
            _item = [[PostItem alloc] initWithDic:self.rightTableArray[indexPath.row]];
            //这里
            cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate = self;
            cell.item = _item;
            cell.commendBtn.tag = indexPath.row;
            cell.shareBtn.tag = indexPath.row;
            cell.starBtn.tag = indexPath.row;
            cell.tag = indexPath.row;
            if (cell.tag == 0) {
                cell.layer.cornerRadius = 10;
            }
            cell.cellFrame = self.heightArray[indexPath.row];
        }
        [cell layoutSubviews];
        [cell layoutIfNeeded];
        self.cnt2 = 1;
        return cell;
    }
    return nil;
}

//设置顶部cell
- (void)setCell {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YYZTopicCell" owner:self options:nil]; //xib文件
    YYZTopicCell *cell = [nib objectAtIndex:0];
    cell.frame = CGRectMake(0, 0, SCREEN_WIDTH,125);
    self.cell = cell;
    for(int i=0;i<self.array.count;i++){
        NSDictionary *dic = self.array[i];
        if([dic[@"topic_name"]isEqualToString:self.topicIdString]){
            //self.topicID = i+1;
            cell.topic_id.text = self.array[i][@"topic_name"];
            cell.topic_number.text = [NSString stringWithFormat:@"%@个成员",self.array[i][@"follow_count"]];
            cell.topic_introduce.text = self.array[i][@"introduction"];
            [cell.topic_logo sd_setImageWithURL:[NSURL URLWithString:self.array[i][@"topic_logo"]]];
            [cell.topic_isFollow setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:173/255.0 green:187/255.0 blue:213/255.0 alpha:1.0]] forState:UIControlStateDisabled];
            if([self.array[i][@"is_follow"] longValue] == 1){
                cell.topic_isFollow.clipsToBounds = YES;
                cell.topic_isFollow.layer.cornerRadius = 14;
                [cell.topic_isFollow setTitle:@"已关注" forState:UIControlStateNormal];
                cell.topic_isFollow.backgroundColor = RGBColor(171, 189, 215, 1);
            }
             cell.topic_isFollow.tag = self.array[i][@"topic_id"];
            [cell.topic_isFollow addTarget:self action:@selector(changeFollow:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
    [self.backgroundScrollView addSubview:cell];
}

- (void) setMiddleLable {
    //现在是我自己写的，以后重构直接用HMSegmentedControl简单一点
    UILabel *middleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 50)];
    middleLable.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#1B1B1B" alpha:1]];
    middleLable.layer.cornerRadius = 15;
    middleLable.clipsToBounds = YES;
    UILabel *middleLeftLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 165, 15, 20)];
    middleLeftLable.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#1B1B1B" alpha:1]];
    UILabel *middleRightLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15, 165, 15, 20)];
    middleRightLable.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#1B1B1B" alpha:1]];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton = leftButton;
    self.rightButton = rightButton;
    [leftButton setTitle:@"最新" forState:UIControlStateNormal];
    [rightButton setTitle:@"热门" forState:UIControlStateNormal];
    [leftButton setFont:[UIFont fontWithName:@"PingFang-SC-Bold" size:18]];
    [rightButton setFont:[UIFont fontWithName:@"PingFang-SC-Bold" size:18]];
    [leftButton setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#ABBBD7" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(15, 140, 40, 25);
    rightButton.frame = CGRectMake(70, 140, 40, 25);
    //leftButton.highlighted = YES;//默认显示最新
    [leftButton addTarget:self action:@selector(leftBtnJump) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(rightBtnJump) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *changeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13,170,40,3)];
    self.changeImageView = changeImageView;
    changeImageView.image = [UIImage imageNamed:@"btnChange"];
    
    [self.backgroundScrollView addSubview:middleLable];
    [self.backgroundScrollView addSubview:middleLeftLable];
    [self.backgroundScrollView addSubview:middleRightLable];
    [self.backgroundScrollView addSubview:leftButton];
    [self.backgroundScrollView addSubview:rightButton];
    [self.backgroundScrollView addSubview:changeImageView];

}

#pragma mark- 帖子列表的网络请求
//下拉刷新
- (void)loadData{
    if(self.cnt1 <4){
        self.cnt1++;
        self.rightPage += 1;
        [self.rightPostmodel loadTopicWithLoop:self.topicID AndPage:self.rightPage AndSize:6 AndType:@"hot"];
    }
    if([self checkPage] == 0){
    self.leftPage += 1;
    [self.leftPostmodel loadTopicWithLoop:self.topicID AndPage:self.leftPage AndSize:6 AndType:@"latest"];
    }
    else{
    self.rightPage += 1;
    [self.rightPostmodel loadTopicWithLoop:self.topicID AndPage:self.rightPage AndSize:6 AndType:@"hot"];
    }
    
}

///上拉刷新
- (void)refreshData{
    if([self checkPage] == 0){
    [self.leftTableArray removeAllObjects];
    self.leftPage = 1;
    [self.leftPostmodel loadTopicWithLoop:self.topicID AndPage:self.leftPage AndSize:6 AndType:@"latest"];
    }
    else{
    [self.rightTableArray removeAllObjects];
    self.rightPage = 1;
    [self.rightPostmodel loadTopicWithLoop:self.topicID AndPage:self.rightPage AndSize:6 AndType:@"hot"];
    }
}

///成功请求数据
- (void)TopicLoadSuccess {
    if(self.cnt1 < 4){
        self.cnt1++;
        if (self.rightPage == 1) {
            //[self.rightTableArray removeAllObjects];
            self.rightTableArray = self.rightPostmodel.postArray;
        }else {
            [self.rightTableArray addObjectsFromArray:self.rightPostmodel.postArray];
        }
        //根据当前加载的问题页数判断是上拉刷新还是下拉刷新
        if (self.rightPage == 1) {
            [self.topicRightTableView.mj_header endRefreshing];
            [self.topicRightTableView reloadData];
        }else{
            [self.topicRightTableView.mj_footer endRefreshing];
            [self.topicRightTableView reloadData];
        }
    }
    if([self checkPage] == 0){
        if (self.leftPage == 1) {
            //[self.leftTableArray removeAllObjects];
            self.leftTableArray = self.leftPostmodel.postArray;
            for (NSDictionary *dic in self.leftTableArray) {
                self.item = [[PostItem alloc] initWithDic:dic];
                PostTableViewCellFrame *cellFrame = [[PostTableViewCellFrame alloc] init];
                cellFrame.item = self.item;
                [self.heightArray addObject:cellFrame];
            }
        }else {
            [self.leftTableArray addObjectsFromArray:self.leftPostmodel.postArray];
            for (NSDictionary *dic in self.leftTableArray) {
                self.item = [[PostItem alloc] initWithDic:dic];
                PostTableViewCellFrame *cellFrame = [[PostTableViewCellFrame alloc] init];
                cellFrame.item = self.item;
                [self.heightArray addObject:cellFrame];
            }
        }
        //根据当前加载的问题页数判断是上拉刷新还是下拉刷新
        if (self.leftPage == 1) {
            [self.topicLeftTableView.mj_header endRefreshing];
            [self.topicLeftTableView reloadData];
        }else{
            [self.topicLeftTableView.mj_footer endRefreshing];
            [self.topicLeftTableView reloadData];
        }
    }
    else{
        if (self.rightPage == 1) {
            //[self.rightTableArray removeAllObjects];
            self.rightTableArray = self.rightPostmodel.postArray;
        }else {
            [self.rightTableArray addObjectsFromArray:self.rightPostmodel.postArray];
        }

        //根据当前加载的问题页数判断是上拉刷新还是下拉刷新
        if (self.rightPage == 1) {
            [self.topicRightTableView.mj_header endRefreshing];
            [self.topicRightTableView reloadData];
        }else{
            [self.topicRightTableView.mj_footer endRefreshing];
            [self.topicRightTableView reloadData];
        }
    }
}

///请求失败
- (void)TopicLoadError {
    [self.topicLeftTableView.mj_header endRefreshing];
    [self.topicLeftTableView.mj_footer endRefreshing];
    
    [self.topicRightTableView.mj_header endRefreshing];
    [self.topicRightTableView.mj_footer endRefreshing];
    [NewQAHud showHudWith:@"网络异常" AddView:self.view];
}

- (void)checkContent {
//    NSInteger rows1 = [_topicLeftTableView numberOfRowsInSection:0];
//    NSInteger rows2 = [_topicRightTableView numberOfRowsInSection:0];
    if(self.cnt2 != 1){
        UIImageView *leftImageview = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-83, 250, 167,127)];
        UIImage *image = [UIImage imageNamed:@"没有动态"];
        UILabel *noneLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-83+40, 330, 167,127)];
        noneLable.text = @"还没有动态哦~";
        noneLable.font = [UIFont fontWithName:nil size:13];
        noneLable.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
        leftImageview.image = image;
        [self.backgroundScrollView addSubview:leftImageview];
        [self.backgroundScrollView addSubview:noneLable];
    }
}
///设置列表加载菊花
- (void)setUpRefresh {
    //上滑加载的设置
    _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.topicLeftTableView.mj_footer = _footer;
    _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.topicRightTableView.mj_footer = _footer;
    //下拉刷新的设置
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.topicLeftTableView.mj_header = _header;
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.topicRightTableView.mj_header = _header;

    [MGDRefreshTool setUPHeader:_header AndFooter:_footer];
}

# pragma mark 初始化功能弹出页面
- (void)funcPopViewinit {
    // 创建分享页面
    _shareView = [[ShareView alloc] init];
    _shareView.delegate = self;
    // 创建多功能--别人页面
    _popView = [[FuncView alloc] init];
    _popView.delegate = self;
    // 创建多功能--自己页面
    _selfPopView = [[SelfFuncView alloc] init];
    _selfPopView.delegate = self;
    // 创建举报页面
    _reportView = [[ReportView alloc]initWithPostID:[NSNumber numberWithInt:0]];
    _reportView.delegate = self;
    
}
///点击跳转到具体的帖子（与下方commentBtn的事件相同）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat pageWidth = self.topicScrollView.frame.size.width;
    int currentPage = floor((self.topicScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if(currentPage == 0){
        DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
        _item = [[PostItem alloc] initWithDic:self.leftTableArray[indexPath.row]];
        dynamicDetailVC.post_id = _item.post_id;
        dynamicDetailVC.hidesBottomBarWhenPushed = YES;
        ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
        [self.navigationController pushViewController:dynamicDetailVC animated:YES];
    }
    else{
        DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
        _item = [[PostItem alloc] initWithDic:self.rightTableArray[indexPath.row]];
        dynamicDetailVC.post_id = _item.post_id;
        dynamicDetailVC.hidesBottomBarWhenPushed = YES;
        ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
        [self.navigationController pushViewController:dynamicDetailVC animated:YES];
    }
}
#pragma mark- 配置相关弹出View和其蒙版的操作
///设置相关蒙版

- (void)setBackViewWithGesture {
    _backViewWithGesture = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backViewWithGesture.backgroundColor = [UIColor blackColor];
    _backViewWithGesture.alpha = 0.36;
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBackViewWithGesture)];
    [self.backViewWithGesture addGestureRecognizer:dismiss];
}

- (void)dismissBackViewWithGestureAnd:(UIView *)view {
    [view removeFromSuperview];
    [_backViewWithGesture removeFromSuperview];
}

- (void)dismissBackViewWithGesture {
    [_popView removeFromSuperview];
    [_shareView removeFromSuperview];
    [_reportView removeFromSuperview];
    self.isShowedReportView = NO;
    [_selfPopView removeFromSuperview];
    [_backViewWithGesture removeFromSuperview];
}
#pragma mark -多功能View--自己的代理方法
- (void)ClickedDeletePostBtn:(UIButton *)sender {
    [_selfPopView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    if([self checkPage] == 0){
        _itemDic = self.leftTableArray[sender.tag];
        DeletePostModel *model = [[DeletePostModel alloc] init];
        [model deletePostWithID:_itemDic[@"post_id"] AndModel:[NSNumber numberWithInt:0]];
        [model setBlock:^(id  _Nonnull info) {
            for (int i = 0;i < [self.leftTableArray count]; i++) {
                if ([self.leftTableArray[i][@"post_id"] isEqualToString:self->_itemDic[@"post_id"]]) {
                    [self.leftTableArray removeObjectAtIndex:i];
                    break;
                }
            }
            [PostArchiveTool savePostListWith:self.leftTableArray];
            [NewQAHud showHudWith:@"  已经删除该帖子 " AddView:self.view AndToDo:^{
                [self.topicLeftTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                [self.topicLeftTableView reloadData];
            }];
        }];
    }
    else{
        _itemDic = self.rightTableArray[sender.tag];
        DeletePostModel *model = [[DeletePostModel alloc] init];
        [model deletePostWithID:_itemDic[@"post_id"] AndModel:[NSNumber numberWithInt:0]];
        [model setBlock:^(id  _Nonnull info) {
            for (int i = 0;i < [self.rightTableArray count]; i++) {
                if ([self.rightTableArray[i][@"post_id"] isEqualToString:self->_itemDic[@"post_id"]]) {
                    [self.rightTableArray removeObjectAtIndex:i];
                    break;
                }
            }
            [PostArchiveTool savePostListWith:self.rightTableArray];
            [NewQAHud showHudWith:@"  已经删除该帖子 " AddView:self.view AndToDo:^{
                [self.topicRightTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                [self.topicRightTableView reloadData];
            }];
        }];
    }
}

#pragma mark - Cell中的相关事件
- (void)showBackViewWithGesture {
    [self.view.window addSubview:_backViewWithGesture];
}
///点赞的逻辑：根据点赞按钮的tag来获取post_id，并传入后端
- (void)ClickedStarBtn:(PostTableViewCell *)cell{
    cell.starBtn.isFirst = NO;
    if (cell.starBtn.selected == YES) {
        cell.starBtn.selected = NO;
        cell.starBtn.iconView.image = [UIImage imageNamed:@"未点赞"];
        NSString *count = cell.starBtn.countLabel.text;
        cell.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] - 1];
        cell.starBtn.countLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#ABBCD9" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
    }else {
        cell.starBtn.selected = YES;
        cell.starBtn.iconView.image = [UIImage imageNamed:@"点赞"];
        NSString *count = cell.starBtn.countLabel.text;
        cell.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] + 1];
        cell.starBtn.countLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#3D35E1" alpha:1] darkColor:[UIColor colorWithHexString:@"#2CDEFF" alpha:1]];
    }
    CGFloat pageWidth = self.topicScrollView.frame.size.width;
    int currentPage = floor((self.topicScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    StarPostModel *model = [[StarPostModel alloc] init];
    if(currentPage == 0){
        _itemDic = self.leftTableArray[cell.starBtn.tag];
        [model starPostWithPostID:[NSNumber numberWithString:_itemDic[@"post_id"]]];
    }
    else{
        _itemDic = self.rightTableArray[cell.starBtn.tag];
        [model starPostWithPostID:[NSNumber numberWithString:_itemDic[@"post_id"]]];
    }
}

///点击评论按钮跳转到具体的帖子详情:(可以通过帖子id跳转到具体的帖子页面，获取帖子id的方式如下方注释的代码)
- (void)ClickedCommentBtn:(PostTableViewCell *)cell{
    CGFloat pageWidth = self.topicScrollView.frame.size.width;
    int currentPage = floor((self.topicScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if(currentPage == 0){
        DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
    _item = [[PostItem alloc] initWithDic:self.leftTableArray[cell.commendBtn.tag]];
    dynamicDetailVC.post_id = _item.post_id;
    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
    }
    else{
        DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
    _item = [[PostItem alloc] initWithDic:self.rightTableArray[cell.commendBtn.tag]];
    dynamicDetailVC.post_id = _item.post_id;
    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
    }
}
///分享帖子
- (void)ClickedShareBtn:(PostTableViewCell *)cell {
    [self showBackViewWithGesture];
    [self.view.window addSubview:_shareView];
    [_shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.window.mas_top).mas_offset(SCREEN_HEIGHT * 460/667);
        make.left.right.bottom.mas_equalTo(self.view.window);
    }];
    _itemDic = self.leftTableArray[cell.shareBtn.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickedShareBtn" object:nil userInfo:nil];
    //此处还需要修改
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *shareURL = [NSString stringWithFormat:@"https://fe-prod.redrock.team/zscy-youwen-share/#/dynamic?id=%@",_itemDic[@"post_id"]];
    pasteboard.string = shareURL;
}

/**
 举报和屏蔽的多能按钮
 此处的逻辑：接收到cell里传来的多功能按钮的frame，在此frame上放置多功能View，同时加上蒙版
 */
- (void)ClickedFuncBtn:(PostTableViewCell *)cell{
    UIWindow* desWindow=self.view.window;
    CGRect frame = [cell.funcBtn convertRect:cell.funcBtn.bounds toView:desWindow];
    [self showBackViewWithGesture];
    if([self checkPage] == 0){
        NSIndexPath *indexPath = [_topicLeftTableView indexPathForCell:cell];
        _itemDic = self.leftTableArray[indexPath.row];
        if ([_itemDic[@"is_self"] intValue] == 1) {
            self.selfPopView.deleteBtn.tag = indexPath.row;
            _selfPopView.postID = _itemDic[@"post_id"];
            _selfPopView.layer.cornerRadius = 8;
            _selfPopView.frame = CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5* 1/3);
            [self.view.window addSubview:_selfPopView];
        } else {
            self.popView.starGroupBtn.tag = indexPath.row;
            self.popView.shieldBtn.tag = indexPath.row;
            self.popView.reportBtn.tag = indexPath.row;
            if ([_itemDic[@"is_follow_topic"] intValue] == 1) {
                NSLog(@"取消关注");
                [_popView.starGroupBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            }else {
                NSLog(@"关注圈子");
                [_popView.starGroupBtn setTitle:@"关注圈子" forState:UIControlStateNormal];
            }
            _popView.layer.cornerRadius = 8;
            _popView.frame = CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5);
            [self.view.window addSubview:_popView];
        }
    }
    else{
        NSIndexPath *indexPath = [_topicRightTableView indexPathForCell:cell];
            _itemDic = self.rightTableArray[indexPath.row];
        if ([_itemDic[@"is_self"] intValue] == 1) {
            self.selfPopView.deleteBtn.tag = indexPath.row;
            _selfPopView.postID = _itemDic[@"post_id"];
            _selfPopView.layer.cornerRadius = 8;
            _selfPopView.frame = CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5* 1/3);
            [self.view.window addSubview:_selfPopView];
        } else {
            self.popView.starGroupBtn.tag = indexPath.row;
            self.popView.shieldBtn.tag = indexPath.row;
            self.popView.reportBtn.tag = indexPath.row;
            if ([_itemDic[@"is_follow_topic"] intValue] == 1) {
                NSLog(@"取消关注");
                [_popView.starGroupBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            }else {
                NSLog(@"关注圈子");
                [_popView.starGroupBtn setTitle:@"关注圈子" forState:UIControlStateNormal];
            }
            _popView.layer.cornerRadius = 8;
            _popView.frame = CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5);
            [self.view.window addSubview:_popView];
        }
    }

}

- (void)leftBtnJump {
    CGFloat imageW = self.topicScrollView.frame.size.width;
    CGPoint position = CGPointMake(0*imageW, 0);
    [self.topicScrollView setContentOffset:position animated:YES];
}
- (void)rightBtnJump {
    CGFloat imageW = self.topicScrollView.frame.size.width;
    CGPoint position = CGPointMake(1*imageW, 0);
    [self.topicScrollView setContentOffset:position animated:YES];
}
- (void)changeFollow:(UIButton *) btn {
    NSString *stringIsFollow = [NSString stringWithFormat:@"%@",btn.tag];
    
    [HttpTool.shareTool
     request:NewQA_POST_followTopic_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:@{@"topic_id":stringIsFollow}
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        //改变button状态
        NSDictionary *dic = @{@"topic_ID":stringIsFollow};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MGD-FollowGroup" object:nil userInfo:dic];
        if([btn.titleLabel.text isEqualToString:@"已关注"]){
            [NewQAHud showHudWith:@"取消关注圈子成功" AddView:self.view];
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 14;
            [btn setTitle:@"+关注" forState:UIControlStateNormal];
            btn.backgroundColor = RGBColor(93, 94, 247, 1);
        } else{
            [NewQAHud showHudWith:@"关注圈子成功" AddView:self.view];
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 14;
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            btn.backgroundColor = RGBColor(171, 189, 215, 1);
        }
        self->_isChanged = YES;
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NewQAHud showHudWith:@"关注失败,请检查网络" AddView:self.view];
    }];
    
//    [[HttpClient defaultClient]requestWithPath:NewQA_POST_followTopic_API method:HttpRequestPost parameters:@{@"topic_id":stringIsFollow} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//            //改变button状态
//            NSDictionary *dic = @{@"topic_ID":stringIsFollow};
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"MGD-FollowGroup" object:nil userInfo:dic];
//            if([btn.titleLabel.text isEqualToString:@"已关注"]){
//                [NewQAHud showHudWith:@"取消关注圈子成功" AddView:self.view];
//                btn.clipsToBounds = YES;
//                btn.layer.cornerRadius = 14;
//                [btn setTitle:@"+关注" forState:UIControlStateNormal];
//                btn.backgroundColor = RGBColor(93, 94, 247, 1);
//            } else{
//                [NewQAHud showHudWith:@"关注圈子成功" AddView:self.view];
//                btn.clipsToBounds = YES;
//                btn.layer.cornerRadius = 14;
//                [btn setTitle:@"已关注" forState:UIControlStateNormal];
//                btn.backgroundColor = RGBColor(171, 189, 215, 1);
//            }
//            self->_isChanged = YES;
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            [NewQAHud showHudWith:@"关注失败,请检查网络" AddView:self.view];
//    }];
}

#pragma mark -多功能View的代理方法
///点击关注按钮
- (void)ClickedStarGroupBtn:(UIButton *)sender {
    _itemDic = self.leftTableArray[sender.tag];
    FollowGroupModel *model = [[FollowGroupModel alloc] init];
    [model FollowGroupWithName:_itemDic[@"topic"]];
    if ([sender.titleLabel.text isEqualToString:@"关注圈子"]) {
        [model setBlock:^(id  _Nonnull info) {
            if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                [self showStarSuccessful];
            }else  {
                [self funcViewFailure];
            }
        }];
    } else if ([sender.titleLabel.text isEqualToString:@"取消关注"]) {
        [model setBlock:^(id  _Nonnull info) {
            if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                [self showUnStarSuccessful];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNewQAMainViewController" object:nil userInfo:nil];
            }else  {
                [self funcViewFailure];
            }
        }];
    }
}

///点击屏蔽按钮
- (void)ClickedShieldBtn:(UIButton *)sender {
    ShieldModel *model = [[ShieldModel alloc] init];
    CGFloat pageWidth = self.topicScrollView.frame.size.width;// 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((self.topicScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if(currentPage == 0){
        _itemDic = self.leftTableArray[sender.tag];
        [model ShieldPersonWithUid:_itemDic[@"uid"]];
        [model setBlock:^(id  _Nonnull info) {
            if ([info[@"info"] isEqualToString:@"success"]) {
                [self showShieldSuccessful];
            }
        }];
    }
    else{
        _itemDic = self.rightTableArray[sender.tag];
        [model ShieldPersonWithUid:_itemDic[@"uid"]];
        [model setBlock:^(id  _Nonnull info) {
            if ([info[@"info"] isEqualToString:@"success"]) {
                [self showShieldSuccessful];
            }
        }];
    }
}
///点击举报按钮
- (void)ClickedReportBtn:(UIButton *)sender  {
    [_popView removeFromSuperview];
    self.isShowedReportView = YES;
    CGFloat pageWidth = self.topicScrollView.frame.size.width;// 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((self.topicScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if(currentPage == 0){
        _itemDic = self.leftTableArray[sender.tag];
        _reportView.postID = _itemDic[@"post_id"];
//        _reportView.frame = CGRectMake(MAIN_SCREEN_W * 0.1587, SCREEN_HEIGHT * 0.1, MAIN_SCREEN_W -     MAIN_SCREEN_W*2*0.1587,MAIN_SCREEN_W * 0.6827 * 329/256);
        [self.view.window addSubview:_reportView];
        [_reportView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
        }];
    }
    else{
        _itemDic = self.rightTableArray[sender.tag];
        _reportView.postID = _itemDic[@"post_id"];
//        _reportView.frame = CGRectMake(MAIN_SCREEN_W * 0.1587, SCREEN_HEIGHT * 0.1, MAIN_SCREEN_W -     MAIN_SCREEN_W*2*0.1587,MAIN_SCREEN_W * 0.6827 * 329/256);
        [self.view.window addSubview:_reportView];
        [_reportView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
        }];
    }
}

#pragma mark -举报页面的代理方法
///举报页面点击确定按钮
- (void)ClickedSureBtn {
    self.isShowedReportView = NO;
    [_reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    ReportModel *model = [[ReportModel alloc] init];
    [model ReportWithPostID:_reportView.postID WithModel:[NSNumber numberWithInt:0] AndContent:_reportView.textView.text];
    [model setBlock:^(id  _Nonnull info) {
        [self showReportSuccessful];
    }];
}

///举报页面点击取消按钮
- (void)ClickedCancelBtn {
    self.isShowedReportView = NO;
    [_reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}
#pragma mark- 配置相关操作成功后的弹窗
- (void)showStarSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  关注圈子成功  " AddView:self.view];
}

- (void)showUnStarSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  取消关注圈子成功  " AddView:self.view];
}

- (void)funcViewFailure {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  操作失败  " AddView:self.view];
}

- (void)showShieldSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  将不再推荐该用户的动态给你  " AddView:self.view];
}

- (void)showReportSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  举报成功  " AddView:self.view];
}

- (void)showReportFailure {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  网络繁忙，请稍后再试  " AddView:self.view];
}

- (void)shareSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  已复制链接，可以去分享给小伙伴了～  " AddView:self.view];
}

#pragma mark -分享View的代理方法
///点击取消
- (void)ClickedCancel {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

///点击分享QQ空间
- (void)ClickedQQZone {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}

///点击分享朋友圈
- (void)ClickedVXGroup {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}

///点击分享QQ
- (void)ClickedQQ {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}

///点击分享微信好友
- (void)ClickedVXFriend {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}

///点击分享复制链接
- (void)ClickedUrl {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}
// 判断刘海屏，返回YES表示是刘海屏
- (BOOL)isNotchScreen {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return NO;
    }
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger notchValue = size.width / size.height * 100;
    
    if (216 == notchValue || 46 == notchValue) {
        return YES;
    }
    return NO;
}
#pragma mark- 监听键盘移动的通知方法
///键盘将要出现时，若举报页面已经显示则上移
- (void)reportViewKeyboardWillShow:(NSNotification *)notification{
    //如果举报页面已经出现，就将举报View上移动
    if (self.isShowedReportView == YES) {
        //获取键盘高度
        NSDictionary *userInfo = notification.userInfo;
        CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyBoardHeight = endFrame.size.height;
        
        [_reportView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
            make.bottom.equalTo(self.view).offset( IS_IPHONEX ? -(keyBoardHeight+20) : -keyBoardHeight);
        }];
    }
}
///键盘将要消失，若举报页面已经显示则使其下移
- (void)reportViewKeyboardWillHide:(NSNotification *)notification{
    if (self.isShowedReportView == YES) {
        [_reportView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
        }];
    }
}

@end
