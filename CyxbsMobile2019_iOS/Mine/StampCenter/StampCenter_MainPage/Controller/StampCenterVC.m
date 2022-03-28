//
//  StampCenterVC.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/14.
//

//View
#import "StampCenterVC.h"
#import "StampCenterTopView.h"
#import "DetailsMainViewController.h"
#import "ExchangeCenterViewController.h"
#import "MyCollectionViewCell.h"
#import "SecondHeaderView.h"
#import "MyTableViewCellWithProgress.h"
#import "SZHReleaseDynamic.h"
#import "QueryLoginViewController.h"
#import "EditMyInfoViewController.h"
#import "TableHeaderView.h"

//Model
#import "GoodsData.h"
#import "TaskData.h"


///邮票中心主界面
@interface StampCenterVC () <UITableViewDelegate,UICollectionViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UICollectionViewDataSource,TopViewDelegate>

///当前Header高度
@property (nonatomic,assign) CGFloat CorrectHeaderY;
///共用的TopView
@property (nonatomic,strong) StampCenterTopView *topView;
///明细按钮
@property (nonatomic,strong) UIButton *detailBtn;
///第一分区装扮数据
@property (nonatomic,copy) NSArray *goodsAry;
///第二分区邮货数据
@property (nonatomic,copy) NSArray *section2GoodsAry;
///任务数据
@property (nonatomic,copy) NSArray *taskAry;
///额外任务数据
@property (nonatomic,copy) NSArray *extraTaskAry;
///左右划的scroll
@property (nonatomic,strong) MainScrollView *mainScrollView;
///小型邮票数量View
@property (nonatomic,strong) UIView *stampCountView;
///邮票数量
@property (nonatomic,strong) NSNumber *number;
///小型邮票Lbl
@property (nonatomic,strong) UILabel *smallcountLbl;
///正确的小型邮票View的X坐标
@property (nonatomic,assign) CGFloat stampCountView_X;

@end

@implementation StampCenterVC

#pragma mark - setter
//商品数据
- (void)setGoodsAry:(NSArray *)goodsAry{
        NSMutableArray *mArray =[[NSMutableArray alloc]initWithCapacity:99];
        NSMutableArray *mArray2 = [[NSMutableArray alloc]initWithCapacity:99];
        for (int i = 0; i < goodsAry.count; i++) {
            GoodsData *data = goodsAry[i];
            if (data.type == 0) {
                //第二分区数据
                [mArray2 addObject:data];
            }
            //第一分区数据
            if(data.type == 1){
                [mArray addObject:data];
            }
        }
    if (mArray.count == 0) {
        self.mainScrollView.collectionHeaderView.detailLabel.text = @"敬请期待";
        self.mainScrollView.collectionHeaderView.detailLabel.x = 0.8*SCREEN_WIDTH;
    }
        _goodsAry = mArray;
    self.section2GoodsAry = mArray2;
    //刷新控件
    [self.mainScrollView.collection reloadData];
}

//任务数据
- (void)setTaskAry:(NSArray *)taskAry{
    NSMutableArray *mArray =[[NSMutableArray alloc]initWithCapacity:99];
    NSMutableArray *mArray2 = [[NSMutableArray alloc]initWithCapacity:99];
    for (int i = 0; i < taskAry.count; i++) {
        TaskData *data = taskAry[i];
        if ([data.type isEqualToString:@"base"]) {
            [mArray addObject:data];
        }
        if ([data.type isEqualToString:@"more"]) {
            [mArray2 addObject:data];
        }
    }
    [mArray removeObjectAtIndex:0];
    _taskAry = mArray;
    _extraTaskAry = mArray2;
    //刷新控件
    [self.mainScrollView.table reloadData];
}

//邮票数量
- (void)setNumber:(NSNumber *)number{
    _number = number;
    int j = [number intValue];
    if (j < 10) {
        self.stampCountView.width = 65;
        self.stampCountView_X = 0.78*SCREEN_WIDTH;
    }
    if (j >= 10 && j < 100) {
        self.stampCountView_X = 0.76*SCREEN_WIDTH;
    }
    if (j >= 100 && j <1000) {
        self.stampCountView_X = 0.74*SCREEN_WIDTH;
        self.stampCountView.width = 80;
    }
    if (j >= 1000 && j < 10000) {
        self.stampCountView_X = 0.72*SCREEN_WIDTH;
        self.smallcountLbl.width = 40;
        self.stampCountView.width = 90;
    }
    if (j >= 10000 && j < 100000) {
        self.stampCountView_X = 0.70*SCREEN_WIDTH;
        self.smallcountLbl.width = 50;
        self.stampCountView.width = 100;
    }
    self.smallcountLbl.text = [NSString stringWithFormat:@"%@",_number];
}


#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated{
    
    //初始化一些数据，避免token失效导致请求不到数据导致数组越界x的闪退
    //初始化商品数据
    if (!self.goodsAry) {
        NSMutableArray *mArray = [[NSMutableArray alloc]initWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            GoodsData *data = [[GoodsData alloc]init];
            data.url = @"NULL";
            data.title = @" NULL";
            data.type = 0;
            [mArray addObject:data];
        }
        self.goodsAry = mArray;
    }
    
    //初始化任务数据
    if (!self.taskAry) {
        NSMutableArray *mArray2 = [[NSMutableArray alloc]initWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            TaskData *data = [[TaskData alloc]init];
            data.title = @"NULL";
            data.type = @"base";
            data.Description = @"NULL";
            data.max_progress = 1;
            data.current_progress = 1;
            data.gain_stamp = 999;
            [mArray2 addObject:data];
        }
        self.taskAry = mArray2;
    }
   
    [self checkAlertLbl];
    
}

#pragma mark - viewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];
    //加载数据
    [self setupData];
    
    //加载TopBar
    [self setupBar];
    
    //加载横向Scroll
    [self.view addSubview:self.mainScrollView];
    
    //加载TopView
    [self.view addSubview:self.topView];
    
    //加载邮票数量View
    [self.topBarView addSubview:self.stampCountView];
    
    //topBar优先级最高
    [self.view bringSubviewToFront:self.topBarView];
    
    //设置小点
    [self setupPoint];

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
}

#pragma mark - table数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

//row数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.taskAry.count;
            break;
        case 1:
            return self.extraTaskAry.count;
            break;
        default:
            return self.section2GoodsAry.count*0.5;
            break;
    }
}

//Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    if (indexPath.section == 0) {
        MyTableViewCellWithProgress *cell = [[MyTableViewCellWithProgress alloc]init];
        TaskData *data = self.taskAry[indexPath.row];
        cell.row = indexPath.row;
        cell.data = data;
        return cell;
    }if (indexPath.section == 1){
        MyTableViewCellWithProgress *cell = [[MyTableViewCellWithProgress alloc]init];
        TaskData *data = self.extraTaskAry[indexPath.row];
        cell.row = indexPath.row;
        cell.data = data;
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}

#pragma mark - table代理
//高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
        view.backgroundColor = [UIColor colorNamed:@"#F2F3F8"];
        TableHeaderView *headerView = [[TableHeaderView alloc]initWithFrame:CGRectMake(0, 217, SCREEN_WIDTH, 78)];
        [view addSubview:headerView];
        return view;
    }
    if (section == 1) {
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60.0)];
        footerView.backgroundColor = [UIColor colorNamed:@"table"];
        UILabel *la = [[UILabel alloc]init];
        la.frame = CGRectMake(20, 20, SCREEN_WIDTH- 40 , 28);
        la.textColor = [UIColor colorNamed:@"#15315B"];
        la.text = @"更多任务";
        la.font = [UIFont fontWithName:PingFangSCBold size:20];
        [footerView addSubview:la];
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 290;
    }
    if (section == 1) {
        return 50;
    }
    return 0.001;
}
#pragma mark - collection数据源
//组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

//每组的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.goodsAry.count;
    }else{
        return self.section2GoodsAry.count;
    }
}

//Cell
-(UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    MyCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        GoodsData *data = self.goodsAry[indexPath.item];
        cell.data = data;
        [cell.exchangeBtn addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
        [cell.showBtn addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        GoodsData *data =self.section2GoodsAry[(indexPath.item)];
        cell.data = data;
        [cell.exchangeBtn addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
        [cell.showBtn addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

#pragma mark - collection代理
//Cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(0.445*SCREEN_WIDTH, 0.632*SCREEN_WIDTH);
}

//HeaderView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        SecondHeaderView *collectionheader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        collectionheader.backgroundColor = [UIColor colorNamed:@"#FBFCFF"];
        if (indexPath.section == 0) {
            collectionheader.height = 0;
        }
        else{
            collectionheader.height = 54;
        }
        return collectionheader;
    }
    return nil;
}

//内边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(215+65, 0.042*SCREEN_WIDTH, 10, 0.042*SCREEN_WIDTH);
    }
    else{
        return UIEdgeInsetsMake(54, 0.042*SCREEN_WIDTH, 0.09*SCREEN_WIDTH, 0.042*SCREEN_WIDTH);
    }
}

//后面有时间详细说明滚动逻辑（核心）
#pragma mark - 滚动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//====================================================横向
    if (scrollView.tag == 123) {
        //滑到任务界面时，小圆点消失，并将日期写入NSUserdefualt
        if (scrollView.contentOffset.x == SCREEN_WIDTH) {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *str = [formatter stringFromDate:date];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:str forKey:@"NowDate"];
            self.topView.point.hidden = YES;
        }

        //滑动条
        CGFloat x = self.topView.stampStoreLbl.x+3 + (scrollView.contentOffset.x * ((self.topView.stampTaskLbl.x-self.topView.stampStoreLbl.x)/SCREEN_WIDTH));
        self.topView.switchbar.x = x;
        self.topView.swithPoint.x = x+63;
    }

    //====================================================CollectionView
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        CGFloat f = Bar_H - self.CorrectHeaderY;
        //当未滑动时
        if (scrollView.contentOffset.y <= 0) {
           _CorrectHeaderY = Bar_H;
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self->_stampCountView.x = SCREEN_WIDTH;
            } completion:nil];
                self.topView.bannerImage.transform = CGAffineTransformMakeScale(1, 1);
                self.detailBtn.transform = CGAffineTransformMakeScale(1, 1);
                self.topView.bannerImage.alpha = 1;
                self.topView.bannerImage.y = 28;
        }
        //当正在滑动时 （不出现邮票）
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 75) {
            _CorrectHeaderY = -scrollView.contentOffset.y+Bar_H;
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self->_stampCountView.x = SCREEN_WIDTH;
            } completion:nil];
            self.topView.bannerImage.transform = CGAffineTransformMakeScale((280 - f)/280, (280 - f)/280);
            self.detailBtn.transform = CGAffineTransformMakeScale((280 - f)/280, (280 - f)/280);
            self.topView.bannerImage.alpha = (125 - f)/125;
        }
        //当正在滑动时 （出现邮票）
        if (scrollView.contentOffset.y >= 75 && scrollView.contentOffset.y < 138) {
            _CorrectHeaderY = -scrollView.contentOffset.y+Bar_H;
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self->_stampCountView.x = self.stampCountView_X;
            } completion:nil];
            self.topView.bannerImage.transform = CGAffineTransformMakeScale((280 - f)/280, (280 - f)/280);
            self.detailBtn.transform = CGAffineTransformMakeScale((280 - f)/280, (280 - f)/280);
            self.topView.bannerImage.alpha = (125 - f)/125;
        }
        //到顶了
        if (scrollView.contentOffset.y >= 138) {
            self.topView.bannerImage.transform = CGAffineTransformMakeScale(0.1,0.1);
            self.detailBtn.transform = CGAffineTransformMakeScale(0.1,0.1);
        }
        _topView.y = _CorrectHeaderY;
    }
    
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat f = Bar_H - self.CorrectHeaderY;
        //当未滑动时
        if (scrollView.contentOffset.y <= 0) {
           _CorrectHeaderY = Bar_H;
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self->_stampCountView.x = SCREEN_WIDTH;
            } completion:nil];
                self.topView.bannerImage.transform = CGAffineTransformMakeScale(1, 1);
                self.detailBtn.transform = CGAffineTransformMakeScale(1, 1);
                self.topView.bannerImage.alpha = 1;
                self.topView.bannerImage.y = 28;
        }
        //当正在滑动时 （不出现邮票）
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 75) {
            _CorrectHeaderY = -scrollView.contentOffset.y+Bar_H;
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self->_stampCountView.x = SCREEN_WIDTH;
            } completion:nil];
            self.topView.bannerImage.transform = CGAffineTransformMakeScale((280 - f)/280, (280 - f)/280);
            self.detailBtn.transform = CGAffineTransformMakeScale((280 - f)/280, (280 - f)/280);
            self.topView.bannerImage.alpha = (125 - f)/125;
        }
        //当正在滑动时 （出现邮票）
        if (scrollView.contentOffset.y >= 75 && scrollView.contentOffset.y < 138) {
            _CorrectHeaderY = -scrollView.contentOffset.y+Bar_H;
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self->_stampCountView.x = self.stampCountView_X;
            } completion:nil];
            self.topView.bannerImage.transform = CGAffineTransformMakeScale((280 - f)/280, (280 - f)/280);
            self.detailBtn.transform = CGAffineTransformMakeScale((280 - f)/280, (280 - f)/280);
            self.topView.bannerImage.alpha = (125 - f)/125;
        }
        //到顶了
        if (scrollView.contentOffset.y >= 138) {
            self.topView.bannerImage.transform = CGAffineTransformMakeScale(0.1,0.1);
            self.detailBtn.transform = CGAffineTransformMakeScale(0.1,0.1);
        }
        _topView.y = _CorrectHeaderY;
    }

}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        self.mainScrollView.table.contentOffset = self.mainScrollView.collection.contentOffset;
    }
    if ([scrollView isKindOfClass:[UITableView class]]) {
        self.mainScrollView.collection.contentOffset = self.mainScrollView.table.contentOffset;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        self.mainScrollView.table.contentOffset = self.mainScrollView.collection.contentOffset;
    }
    if ([scrollView isKindOfClass:[UITableView class]]) {
        self.mainScrollView.collection.contentOffset = self.mainScrollView.table.contentOffset;
    }
}


#pragma mark - getter
//顶部View
- (StampCenterTopView *)topView{
    if (!_topView) {
        _topView = [[StampCenterTopView alloc]init];
        _topView.delegate = self;
        _number = _topView.number;
        [_topView addSubview:self.detailBtn];
    }
    return _topView;
}

//跳转至邮票详情按钮
- (UIButton *)detailBtn{
    if (!_detailBtn) {
        _detailBtn = [[UIButton alloc]initWithFrame:self.topView.bannerImage.frame];
        [_detailBtn addTarget:self action:@selector(goDetail) forControlEvents:UIControlEventTouchUpInside];
        _detailBtn.backgroundColor = [UIColor clearColor];
    }
    return _detailBtn;
}

//主界面
- (MainScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[MainScrollView alloc]initWithFrame:CGRectMake(0, Bar_H, SCREEN_WIDTH, SCREEN_HEIGHT-Bar_H)];
        _mainScrollView.collection.delegate = self;
        _mainScrollView.collection.dataSource = self;
        _mainScrollView.table.delegate = self;
        _mainScrollView.table.dataSource = self;
        _mainScrollView.delegate = self;
    }
    return _mainScrollView;
}

#pragma mark - 私有方法
//返回
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

//跳转至第一页
- (void)goPageOne{
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mainScrollView.contentOffset = CGPointMake(0, 0);
    } completion:nil];
}

//跳转至第二页
- (void)goPageTwo{
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    } completion:nil];
     
  
}

//跳转至邮票详情
- (void)goDetail{
    NSLog(@"跳转至邮票详情");
    DetailsMainViewController *dvc = [[DetailsMainViewController alloc]init];
    dvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dvc animated:YES];
    
}

//跳转至商品详情111
- (void)jump:(UIButton *)sender{
    NSLog(@"跳转至商品详情，id = %ld",(long)sender.tag);
    ExchangeCenterViewController *evc = [[ExchangeCenterViewController alloc]initWithID:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    evc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:evc animated:YES];
}

//设置Bar
- (void)setupBar{
    self.view.backgroundColor = [UIColor colorNamed:@"#F2F3F8"];
    self.VCTitleStr = @"邮票中心";
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.splitLineColor = [UIColor colorNamed:@"42_78_132_0.1"];
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    self.splitLineHidden = YES;
    self.CorrectHeaderY = Bar_H;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkAlert) name:@"networkerror" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToNewQA) name:@"jumpToNewQA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToReleaseDynamic) name:@"jumpToReleaseDynamic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage) name:@"refreshPage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAlertLbl) name:@"checkAlertLbl" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToZhiyuan) name:@"jumpToZhiyuan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToProfile) name:@"jumpToProfile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkInSucceeded) name:@"checkInSucceeded" object:nil];
}

//小型邮票数量View
- (UIView *)stampCountView{
    if (!_stampCountView) {
        HttpClient *client = [HttpClient defaultClient];
        [client.httpSessionManager GET:Stamp_Store_Main_Page parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            self.number = responseObject[@"data"][@"user_amount"];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"==========================出错了");
            }];
        _stampCountView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH,7, 75, 27)];
        _stampCountView.backgroundColor = [UIColor colorNamed:@"#2B333F66"];
        _stampCountView.layer.cornerRadius = 14;
        UIImageView *barstamp = [[UIImageView alloc]initWithFrame:CGRectMake(11.7, 2.3, 21.1, 21.1)];
        barstamp.image = [UIImage imageNamed:@"barstamp"];
        _smallcountLbl = [[UILabel alloc]initWithFrame:CGRectMake(37.5, 2.3, 30.5, 22)];
        _smallcountLbl.font = [UIFont fontWithName:@"DIN-Medium" size:18.7];
        _smallcountLbl.textColor = [UIColor whiteColor];
        _smallcountLbl.text = @"正在加载";
        [_stampCountView addSubview:barstamp];
        [_stampCountView addSubview:_smallcountLbl];
    }
    return _stampCountView;
}

//设置小圆点的状态
- (void)setupPoint{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *str = [formatter stringFromDate:date];
    if ([str isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"NowDate"]]) {
        self.topView.point.hidden = YES;
    }
    else{
        self.topView.point.hidden = NO;
    }
    
    //请勿移动此代码的位置，不然会引起UI错乱，连锁玄学问题
    //=============================================<<<
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUSBARHEIGHT)];
    v.backgroundColor = [UIColor colorNamed:@"#F2F3F8"];
    [self.view addSubview:v];
    //=============================================>>>
}


//获取数据
- (void)setupData{
    [TaskData TaskDataWithSuccess:^(NSArray * _Nonnull array) {
        self.taskAry = array;
    } error:^{
        [NewQAHud showHudWith:@"网络异常" AddView:self.view];
    }];
    
    [GoodsData GoodsDataWithSuccess:^(NSArray * _Nonnull array) {
        self.goodsAry = array;
    } error:^{
        [NewQAHud showHudWith:@"网络异常" AddView:self.view];
    }];
}

- (void)netWorkAlert{
    [NewQAHud showHudWith:@"网络异常" AddView:self.view];
}

- (void)jumpToNewQA{
    NSLog(@"正在跳转至邮问主页");
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:NO];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottomClassScheduleTabBarView" object:nil userInfo:nil];
  
}

- (void)jumpToReleaseDynamic{
    SZHReleaseDynamic *SVC = [[SZHReleaseDynamic alloc]init];
    
    [self.navigationController pushViewController:SVC animated:YES];
}

- (void)refreshPage{
    [TaskData TaskDataWithSuccess:^(NSArray * _Nonnull array) {
        self.taskAry = array;
    } error:^{
        [NewQAHud showHudWith:@"网络异常" AddView:self.view];
    }];
    
    HttpClient *client = [HttpClient defaultClient];
    [client.httpSessionManager GET:Stamp_Store_Main_Page parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.number = responseObject[@"data"][@"user_amount"];
        self.topView.number = responseObject[@"data"][@"user_amount"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"==========================出错了");
        }];
}

- (void)jumpToZhiyuan{
    QueryLoginViewController *QVC = [[QueryLoginViewController alloc]init];
    [self.navigationController pushViewController:QVC animated:YES];
}

- (void)jumpToProfile{
    EditMyInfoViewController *EVC = [[EditMyInfoViewController alloc]init];
    [self.navigationController presentViewController:EVC animated:YES completion:nil];
}

- (void)checkAlertLbl{
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:COMMON_QUESTION method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            BOOL un_got_good = responseObject[@"un_got_good"];
        if (un_got_good == YES) {
            self.topView.alertLbl.hidden = NO;
        }else{
            self.topView.alertLbl.hidden = YES;
        }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"==========================出错了");
        }];

}

- (void)checkInSucceeded{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"签到成功";
    [hud hide:YES afterDelay:1];
}

@end
