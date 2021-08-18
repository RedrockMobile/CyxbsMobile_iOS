//
//  StampCenterVC.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/14.
//
#import "StampCenterVC.h"
#import "PageOne.h"
#import "PageTwo.h"
#import "StampCenterTopView.h"
#import "StampCenterTopBar.h"
#import "ZWTMacro.h"
#import "DetailsMainViewController.h"
#import "ExchangeCenterViewController.h"
#import "UIView+XYView.h"

@interface StampCenterVC () <UITableViewDelegate,UICollectionViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UICollectionViewDataSource,TopViewDelegate>

@property (nonatomic,assign) CGFloat tableCorrectHeaderY;
@property (nonatomic,assign) CGFloat collectionCorrectHeaderY;
@property (nonatomic,strong) StampCenterTopView *topView;
@property (nonatomic,strong) UIButton *detailBtn;
@property (nonatomic,copy) NSArray *goodsAry;
@property (nonatomic,copy) NSArray *section2GoodsAry;
@property (nonatomic,copy) NSArray *taskAry;
@property (nonatomic,strong) MainScrollView *mainScrollView;
@property (nonatomic,strong) UIView *stampCountView;
@property (nonatomic,strong) NSNumber *number;
@property (nonatomic,strong) UILabel *smallcountLbl;

@end

@implementation StampCenterVC
#pragma mark - setter

//商品数据
- (void)setGoodsAry:(NSArray *)goodsAry{
        NSMutableArray *mArray =[[NSMutableArray alloc]initWithCapacity:99];
        NSMutableArray *mArray2 = [[NSMutableArray alloc]initWithCapacity:99];
        for (int i = 0; i < goodsAry.count; i++) {
            GoodsData *data = goodsAry[i];
            if (data.type == 1) {
                [mArray2 addObject:data];
            }
            if(data.type == 0){
                [mArray addObject:data];
            }
        }
        _goodsAry = mArray;
    self.section2GoodsAry = mArray2;
    //刷新控件
    [self.mainScrollView.collection reloadData];
}

//任务数据
- (void)setTaskAry:(NSArray *)taskAry{
    _taskAry = taskAry;
    //刷新控件
    [self.mainScrollView.table reloadData];
}

//邮票数量
- (void)setNumber:(NSNumber *)number{
    _number = number;
    self.smallcountLbl.text = [NSString stringWithFormat:@"%@",_number];
//    self.stampCountView.width = 60;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupBar];
    
    [self.view addSubview:self.mainScrollView];
    
    [self.view addSubview:self.topView];
    
    [self.view addSubview:self.stampCountView];
    
    [self.view bringSubviewToFront:self.topBarView];
    
    NSLog(@"%f",self.topView.y);
    //获取数据
    [TaskData TaskDataWithSuccess:^(NSArray * _Nonnull array) {
        self.taskAry = array;
        NSLog(@"%@",self.taskAry);
    } error:^{
        NSLog(@"!");
    }];
    //获取数据
    [GoodsData GoodsDataWithSuccess:^(NSArray * _Nonnull array) {
        self.goodsAry = array;
        NSLog(@"%@",self.goodsAry);
        NSLog(@"%@",self.section2GoodsAry);
    } error:^{
        NSLog(@"!");
    }];
}

#pragma mark - table数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskData *data = self.taskAry[indexPath.row];
        MyTableViewCellWithProgress *cell = [[MyTableViewCellWithProgress alloc]init];
    cell.data = data;
    return cell;
}

#pragma mark - table代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75; //高度
}

#pragma mark - collection数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2; //组数
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

#pragma mark - 滚动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 123) {
        if (_tableCorrectHeaderY != _collectionCorrectHeaderY) {
            if (scrollView.contentOffset.x < SCREEN_WIDTH*0.5) {
                [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self->_topView.y = self->_collectionCorrectHeaderY;
                    int i = self->_collectionCorrectHeaderY + 50;
                    self.detailBtn.transform = CGAffineTransformMakeScale(i/138, i/138);
                    self.topView.bannerImage.transform = CGAffineTransformMakeScale(i/138, i/138);
                    self.topView.bannerImage.alpha = i/138;
                    if (self->_mainScrollView.collection.contentOffset.y < 50) {
                            self->_stampCountView.x = SCREEN_WIDTH;
                    }
                    if (self->_mainScrollView.collection.contentOffset.y >= 50) {
                            self->_stampCountView.x = 0.746*SCREEN_WIDTH;
                    }
                } completion:nil];
            }
            if (scrollView.contentOffset.x >= SCREEN_WIDTH*0.5) {
                [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self->_topView.y = self->_tableCorrectHeaderY;
                    int i = self->_tableCorrectHeaderY + 50;
                    self.detailBtn.transform = CGAffineTransformMakeScale(i/138, i/138);
                    self.topView.bannerImage.transform = CGAffineTransformMakeScale(i/138, i/138);
                    self.topView.bannerImage.alpha = i/138;
                    if (self->_mainScrollView.table.contentOffset.y < -215+50) {
                            self->_stampCountView.x = SCREEN_WIDTH;
                    }
                    if (self->_mainScrollView.table.contentOffset.y >= -215+50) {
                            self->_stampCountView.x = 0.746*SCREEN_WIDTH;
                    }
                } completion:nil];
            }
        }
        CGFloat x = self.topView.stampStoreLbl.x+3 + (scrollView.contentOffset.x * ((self.topView.stampTaskLbl.x-self.topView.stampStoreLbl.x)/SCREEN_WIDTH));
        self.topView.switchbar.x = x;
        self.topView.swithPoint.x = x+63;
    }
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        NSLog(@"%f",_collectionCorrectHeaderY);
        if (scrollView.contentOffset.y <= 0) {
           _collectionCorrectHeaderY = Bar_H;
            _detailBtn.hidden = NO;
        }
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y <= 138) {
            _collectionCorrectHeaderY = -scrollView.contentOffset.y+Bar_H;
            _detailBtn.hidden = NO;
        }
        if (scrollView.contentOffset.y < 50) {
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self->_stampCountView.x = SCREEN_WIDTH;
            } completion:nil];
        }
        if (scrollView.contentOffset.y >=  50) {
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->_stampCountView.x = 0.746*SCREEN_WIDTH;
            } completion:nil];
        }
        if (scrollView.contentOffset.y >= 138) {
            _collectionCorrectHeaderY = -138+Bar_H;
            _stampCountView.x = 0.746*SCREEN_WIDTH;
            _detailBtn.hidden = YES;
        }
        _topView.y = _collectionCorrectHeaderY;
        
        float i = _collectionCorrectHeaderY + 50;
        
        self.detailBtn.transform = CGAffineTransformMakeScale(i/138, i/138);
        self.topView.bannerImage.transform = CGAffineTransformMakeScale(i/138, i/138);
        self.topView.bannerImage.alpha = i/138;
    }

    
    
    
    if ([scrollView isKindOfClass:[UITableView class]]){
        NSLog(@"%f",scrollView.contentOffset.y); // 215
        if (scrollView.contentOffset.y <= -215) {
            _tableCorrectHeaderY = Bar_H;
            _detailBtn.hidden = NO;
        }
        if (scrollView.contentOffset.y < -215+50) {
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self->_stampCountView.x = SCREEN_WIDTH;
            } completion:nil];
        }
        if (scrollView.contentOffset.y >= -215+50) {
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self->_stampCountView.x = 0.746*SCREEN_WIDTH;
            } completion:nil];
        }
        if (scrollView.contentOffset.y > -215 && scrollView.contentOffset.y <= -215+138) {
            _tableCorrectHeaderY = Bar_H-(215+scrollView.contentOffset.y);
            _detailBtn.hidden = NO;
        }
        if (scrollView.contentOffset.y > -77){
            _tableCorrectHeaderY = -138+Bar_H;
            _detailBtn.hidden = YES;
        }
        _topView.y = _tableCorrectHeaderY;
        float i = _tableCorrectHeaderY + 50;
        self.detailBtn.transform = CGAffineTransformMakeScale(i/138, i/138);
        self.topView.bannerImage.transform = CGAffineTransformMakeScale(i/138, i/138);
        self.topView.bannerImage.alpha = i/138;
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
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mainScrollView.contentOffset = CGPointMake(0, 0);
    } completion:nil];
}

//跳转至第二页
- (void)goPageTwo{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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

//跳转至商品详情
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
}

//小型邮票数量View
- (UIView *)stampCountView{
    if (!_stampCountView) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"authorization"];
        [manager GET:MAIN_PAGE_API parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            self.number = responseObject[@"data"][@"user_amount"];
        } failure:nil];
        _stampCountView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, STATUSBARHEIGHT+7, 75, 27)];
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
@end
