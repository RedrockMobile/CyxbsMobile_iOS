//
//  AuthenticViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "AuthenticViewController.h"
#import "IDDisplayView.h"
#import "IDCardAnimationView.h"
#import "SegmentedPageView.h"
#import "IDCardTableViewCell.h"
#import "IDDataManager.h"

//开启CCLog
#define CCLogEnable 1

@interface AuthenticViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    IDCardViewDelegate
>
{
    CGPoint idDisplayViewOrigin;
    CGFloat cellHeight;
}

/// 上方带虚线框的一个view
@property (nonatomic, strong)IDDisplayView *idDisplayView;

/// 分页view
@property (nonatomic, strong)SegmentedPageView *segmentView;

/// 认证身份页的tableView
@property (nonatomic, strong)UITableView *autTableView;

/// 个性身份页的tableView
@property (nonatomic, strong)UITableView *cusTableView;

//放着两个 tableview
@property (nonatomic, strong)NSArray<UITableView*> *tableViewArr;

/// 认证身份模型的数组
@property (nonatomic, strong)NSMutableArray<IDModel*> *autIDModelArr;

/// 个性身份模型的数组
@property (nonatomic, strong)NSMutableArray<IDModel*> *cusIDModelArr;

@property (nonatomic, strong)IDCardAnimationView *animationView;

@end

@implementation AuthenticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.segmentView.index
    /*
     卡片间隔：0.05333333333
     卡片高度：0.3333333334
     cell高度 = 卡片间隔 + 卡片高度 = 0.3866666667
     */
    cellHeight = 0.3866666667 * SCREEN_WIDTH;
    
    idDisplayViewOrigin = CGPointMake(0.04266666667*SCREEN_WIDTH, 0.1379310345*SCREEN_HEIGHT);
    // 使用父类控制器的API，自定义顶部的导航栏
    [self configTopBar];
    // 添加管理卡片拖拽动画的类
    [self addAnimationView];
    // 添加上方带虚线框的一个view
    [self addIdDisplayView];
    // 添加分页view
    [self addSegmentView];
    // 添加认证身份的tableView
    [self addAuthenticTableView];
    // 添加个性身份的tableView
    [self addPersonalizeTableView];
    
    self.tableViewArr = @[self.autTableView, self.cusTableView];
    
    // 从本地获取数据
    [self getIDDataFromLocal];
    // 从网络获取数据
    [self getIDDataFromNet];
}

- (void)getIDDataFromLocal {
    IDDataManager *mngr = [IDDataManager shareManager];
    IDModel *dispModel = [mngr getDispIDModelFromLocal];
    NSMutableArray *autModelArr = [mngr getAutIDModelArrFromLocal];
    NSMutableArray *cusModelArr = [mngr getCusIDModelArrFromLocal];
    [self reloadWithDisp:dispModel autModelArr:autModelArr cusModelArr:cusModelArr];
     CCLog(@"%@, %@", self.autIDModelArr, self.cusIDModelArr);
}

- (void)getIDDataFromNet {
    //++++++++++++++++++debug++++++++++++++++++++  Begain
//#ifdef DEBUG
//    return;
//#endif
    //++++++++++++++++++debug++++++++++++++++++++  End
    NSString *redid = [UserItem defaultItem].redid;
    // redid 不存在，那就 return
    if (redid==nil || [redid isEqualToString:@""]) {
        [NewQAHud showHudAtWindowWithStr:@"加载数据失败" enableInteract:YES];
        return;
    }
    
    IDDataManager *mngr = [IDDataManager shareManager];
    dispatch_queue_t que = dispatch_queue_create("用于身份页面获取身份", DISPATCH_QUEUE_CONCURRENT);
    
    // 用来化同步为异步
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    // 用来标记网络请求是否全部成功
    __block BOOL allSuccess = YES;
    __block IDModel *dispModel = [[IDDataManager shareManager] getDispIDModelFromLocal];
    __block NSMutableArray *autModelArr, *cusModelArr;
    dispatch_async(que, ^{
        [mngr loadDisplayIDWithRedid:redid success:^(IDModel * _Nonnull model) {
            dispModel = model;
            dispatch_semaphore_signal(sema);
        } failure:^{
            allSuccess = NO;
            dispatch_semaphore_signal(sema);
        }];
        // 如果超时，那么也算网络请求失败
        if (dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 20*NSEC_PER_SEC))) { allSuccess = NO; }
    });
    dispatch_async(que, ^{
        [mngr loadAuthenticIDWithRedid:redid success:^(NSMutableArray<IDModel *> * _Nonnull modelArr) {
            autModelArr = modelArr;
            dispatch_semaphore_signal(sema);
        } failure:^{
            allSuccess = NO;
            dispatch_semaphore_signal(sema);
        }];
        // 如果超时，那么也算网络请求失败
        if (dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 20*NSEC_PER_SEC))) { allSuccess = NO; }
    });
    dispatch_async(que, ^{
        [mngr loadCustomIDWithRedid:redid success:^(NSMutableArray<IDModel *> * _Nonnull modelArr) {
            cusModelArr = modelArr;
            dispatch_semaphore_signal(sema);
        } failure:^{
            allSuccess = NO;
            dispatch_semaphore_signal(sema);
        }];
        // 如果超时，那么也算网络请求失败
        if (dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 20*NSEC_PER_SEC))) { allSuccess = NO; }
    });
    
    dispatch_barrier_async(que, ^{
        dispatch_async_on_main_queue(^{
            if (allSuccess) {
                [NewQAHud showHudAtWindowWithStr:@"加载数据成功" enableInteract:YES];
            }else {
                [NewQAHud showHudAtWindowWithStr:@"加载数据失败" enableInteract:YES];
            }
            [self reloadWithDisp:dispModel autModelArr:autModelArr cusModelArr:cusModelArr];
        });
    });
    
}

- (void)reloadWithDisp:(IDModel*)dispModel autModelArr:(NSMutableArray<IDModel*>*)autModelArr cusModelArr:(NSMutableArray<IDModel*>*)cusModelArr {
    if (dispModel != nil) {
        NSMutableArray<IDModel*>*modelArr;
        if ([dispModel.idTypeStr isEqualToString:IDModelIDTypeAut]) {
            modelArr = autModelArr;
        }else {
            modelArr = cusModelArr;
        }
        
        BOOL isExist = NO;
        for (NSInteger i = 0; i < modelArr.count; ++i) {
            if ([modelArr[i].idStr isEqualToString:dispModel.idStr]) {
                dispModel = modelArr[i];
                [modelArr removeObject:dispModel];
                isExist = YES;
                CCLog(@"%@", dispModel);
                break;
            }
        }
        [self.animationView setAsDisplayWith:dispModel];
    }else {
        [self.animationView cleanData];
    }
    
    self.autIDModelArr = autModelArr;
    [self.autTableView reloadData];
    self.cusIDModelArr = cusModelArr;
    [self.cusTableView reloadData];
}

/// 使用父类控制器的API，自定义顶部的导航栏
- (void)configTopBar {
    self.VCTitleStr = @"身份设置";
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    self.splitLineHidden = YES;
}

/// 添加上方带虚线框的一个view
- (void)addIdDisplayView {
    IDDisplayView *view = [[IDDisplayView alloc] init];
    [self.animationView addSubview:view];
    self.idDisplayView = view;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(idDisplayViewOrigin.x);
        make.top.equalTo(self.view).offset(idDisplayViewOrigin.y);
    }];
}

/// 添加分页view
- (void)addSegmentView {
    SegmentedPageView *view = [[SegmentedPageView alloc] init];
    [self.animationView addSubview:view];
    self.segmentView = view;
    
    view.viewNameArr = @[@"认证身份", @"个性身份"];
    view.gap = 0.288*SCREEN_WIDTH;
    view.tipViewWidth = 0.1653333333*SCREEN_WIDTH;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.idDisplayView.mas_bottom).offset(0.03325123153*SCREEN_HEIGHT);
    }];
    [view reLoadUI];
}

/// 添加认证身份的tableView
- (void)addAuthenticTableView {
    self.autTableView = [self getStdTableViewWithIndex:0];
}

- (void)addPersonalizeTableView {
    self.cusTableView = [self getStdTableViewWithIndex:1];
}

- (UITableView*)getStdTableViewWithIndex:(NSInteger)pageIndex {
    UITableView *tableView = [[UITableView alloc] init];
    CGFloat cellHeight = self->cellHeight;
    [self.segmentView addSubview:tableView atIndex:pageIndex layout:^(UIView * _Nonnull pageView) {
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pageView).offset(0.04433497537*SCREEN_HEIGHT);
            make.left.equalTo(pageView).offset(0.04266666667*SCREEN_WIDTH);
            make.bottom.equalTo(pageView).offset(cellHeight);
            make.right.equalTo(pageView).offset(-0.04266666667*SCREEN_WIDTH);
        }];
    }];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.backgroundColor = [UIColor dm_colorWithLightColor:RGBColor(255, 255, 255, 1) darkColor:RGBColor(29, 29, 29, 1)];
    tableView.showsVerticalScrollIndicator = NO;
    // 增加一个 cellHeight 的底部 inset，
    // 原因是 tableView 的约束有偏移出一个 cellHeight 的长度
    tableView.contentInset = UIEdgeInsetsMake(0, 0, cellHeight, 0);
    tableView.rowHeight = cellHeight;
    return tableView;
}

- (void)addAnimationView {
    IDCardAnimationView *view = [[IDCardAnimationView alloc] initWithTargetPoint:idDisplayViewOrigin cellHeight:cellHeight];
    self.animationView = view;
    [self.view addSubview:view];
    view.delegate = self;
    // 此时 self.autTableView 还是 nil
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view.autTableView = self.autTableView;
        view.cusTableView = self.cusTableView;
    });
}
//MARK: - IDCardAnimationView 的代理方法
- (NSInteger)currentSegmentViewIndex:(IDCardAnimationView*)view {
    return self.segmentView.index;
}

- (UITableView*)currentTableView:(IDCardAnimationView*)view {
    if (self.segmentView.index==0) {
        return self.autTableView;
    }else {
        return self.cusTableView;
    }
}

- (IDModel*)getModelforIndexPath:(NSIndexPath*)indexPath pageIndex:(NSInteger)index :(IDCardAnimationView*)view {
    if (index==0) {
        return self.autIDModelArr[indexPath.row];
    }else {
        return self.cusIDModelArr[indexPath.row];
    }
}

- (void)insertCellWithModel:(IDModel*)model atIndexPath:(NSIndexPath*)idxPath :(IDCardAnimationView*)view {
    if ([model.idTypeStr isEqualToString:IDModelIDTypeAut]) {
        [self.autIDModelArr insertObject:model atIndex:idxPath.row];
        [self.autTableView reloadData];
    }else {
        [self.cusIDModelArr insertObject:model atIndex:idxPath.row];
        [self.cusTableView reloadData];
    }
}

- (void)setIDCardAsDisplayedWithModel:(IDModel*)model :(IDCardAnimationView*)view {
    if ([model.idTypeStr isEqualToString:IDModelIDTypeAut]) {
        [self.autIDModelArr removeObject:model];
        [self.autTableView reloadData];
    }else {
        [self.cusIDModelArr removeObject:model];
        [self.cusTableView reloadData];
    }
    [[IDDataManager shareManager] displayIDWithModel:model success:^{
        [NewQAHud showHudAtWindowWithStr:@"设置成功～" enableInteract:YES];
    } failure:^{
        [NewQAHud showHudAtWindowWithStr:@"网络错误，设置失败～" enableInteract:YES];
    }];
}


// MARK: - tableView 的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==_autTableView) {
        return _autIDModelArr.count;
    }else {
        return _cusIDModelArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIDStr = @"AuthenticViewController.authenticTableView";
    IDCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDStr];
    if (cell==nil) {
        cell = [[IDCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDStr];
    }
    if (tableView==_autTableView) {
        cell.model = self.autIDModelArr[indexPath.row];
    }else {
        cell.model = self.cusIDModelArr[indexPath.row];
    }
    return cell;
}

@end


/*
 方案的选择：
 clipsToBounds与超出一截的选择，render时clipToBounds设置为NO，render完毕后再恢复
 超出一截带来的bug
 
 //卡片回弹时，设置contentoffset为卡片拉出时的值带来的问题
 */

/*
 bug及解决：
 在cellForRow:方法内部数组越界
 由于这种bug的在一定时机下才会复现，复现比较困难，不好确认。
 初步判定为网络请求时用作为数据源的数组存储新数据。而在主线程恰好在刷新table
 导致调用 numberOfRow时的数据源数组 和 cellForRow的数据源数组 不是同一个，
 且cellForRow中的那个的长度更小。
 
 解决：使用其他变量存储新数据，更新数据源数组后立刻调用reloadData方法。
 ps：采用上述解决方案后，多次尝试都没有复现。
 
 
 在tableview的cell个数为3个时，拖拽最后一个cell执行U2U，会发现拖拽完毕后contentOffset.y
 突然有变成0，从视觉上看发生了闪烁。
 原因：在idCardAttachAnimationDidEnd内先执行减小contentInset，再执行tableview的reloadData，
 导致执行减小contentInset时contentOffset.y变成0，reloadData后contentOffset.y自然就是0了。
 
 解决：先执行tableview的reloadData，再执行减小contentInset
 */
