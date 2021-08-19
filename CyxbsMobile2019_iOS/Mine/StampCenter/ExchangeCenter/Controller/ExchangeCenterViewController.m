//
//  ExchangeCenterViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/8/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ExchangeCenterViewController.h"
#import <Masonry/Masonry.h>
#import "ZWTMacro.h"

#define iPhoneScreenWidth [UIScreen mainScreen].bounds.size.width
#define iPhoneScreenHeight [UIScreen mainScreen].bounds.size.height
#define picScrollViewWidth 360 * [UIScreen mainScreen].bounds.size.width / 390

@interface ExchangeCenterViewController () <UIScrollViewDelegate>




@end

@implementation ExchangeCenterViewController


- (instancetype)initWithID:(NSString *)ID{
    if (self = [super init]) {
        self.goodsID = ID;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorNamed:@"White&Black"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    [self getData];
    [self addTopView];
    [self addContentView];
    [self addBottomView];
   
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark - configure
///顶部
- (void)addTopView {
    TopView *topView = [[TopView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:topView];
    _topView = topView;
    topView.backgroundColor = [UIColor colorNamed:@"White&Black"];
    topView.frame= CGRectMake(0, 0, iPhoneScreenWidth, 88.0 / 812 * iPhoneScreenHeight);
    [topView.backBtn addTarget:self action:@selector(returnindex) forControlEvents:UIControlEventTouchUpInside];
}
///内容
- (void)addContentView {
//    ContentScrollView *contentView = [[ContentScrollView alloc]initWithFrame:CGRectMake(0, 88.0 / 812 * iPhoneScreenHeight, iPhoneScreenWidth, iPhoneScreenHeight - 88.0 / 812 * iPhoneScreenHeight - 68)];
    ContentScrollView *contentView = [[ContentScrollView alloc]initWithFrame:CGRectMake(0, 88.0 / 812 * iPhoneScreenHeight, iPhoneScreenWidth, iPhoneScreenHeight - 88.0 / 812 * iPhoneScreenHeight - 68) AndID:self.goodsID];
    
    [self.view addSubview:contentView];
    _contentView = contentView;
    contentView.picScrollView.delegate = self;
    contentView.backgroundColor = [UIColor colorNamed:@"White&Black"];
    
    
    //设置contentSize
    [contentView layoutIfNeeded];
    if (contentView.tipsContentLabel.frame.origin.y + contentView.tipsContentLabel.frame.size.height < iPhoneScreenHeight - 88 - 68) {
        contentView.contentSize = CGSizeMake(iPhoneScreenWidth, iPhoneScreenHeight - 88 - 68);
    }else{
        contentView.contentSize = CGSizeMake(iPhoneScreenWidth, contentView.tipsContentLabel.frame.origin.y + contentView.tipsContentLabel.frame.size.height + 10);
    }
    self.isDirect = 1;
///开始计时器
    [self startTimer];
}
///底部
- (void)addBottomView {
    BottomView *bottomView = [[BottomView alloc]initWithFrame:CGRectZero AndID:self.goodsID];
    bottomView.goodsID = self.goodsID;
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor colorNamed:@"White&Black"];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(iPhoneScreenWidth);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(68);
    }];
    [bottomView.exchangeBtn addTarget:self action:@selector(isExchange) forControlEvents:UIControlEventTouchUpInside];
    //设置数据
    bottomView.balanceLabel.text = [@"余额：" stringByAppendingString:@"9999999"];
}
///网络请求
- (void)getData {
    
    
    NSString *s = self.goodsID;
    [Goods getDataDictWithId:s Success:^(NSDictionary * _Nonnull dict) {
        self.goodsDict = dict;
        self.contentView.nameLabel.text = dict[@"title"];
        self.contentView.amountLabel.text = [@"库存量：" stringByAppendingString: [NSString stringWithFormat:@"%@",self.goodsDict[@"amount"]]];
        self.contentView.textLabel.text = self.goodsDict[@"description" ];
        self.contentView.lastdayLabel.text = [[@"有效期：" stringByAppendingString: [NSString stringWithFormat:@"%@",self.goodsDict[@"life"]]] stringByAppendingString:@"天"];
        if (self.goodsDict[@"type"] == 0) {
            self.topView.titleLabel.text = @"邮货详情";
            self.contentView.tipsContentLabel.text = @"1、每个实物商品每人限兑换一次，已经兑换的商品不能退货换货也不予折现。\n2、在法律允许的范围内，本活动的最终解释权归红岩网校工作站所有。";
        }else{
            self.topView.titleLabel.text = @"装扮详情";
            self.contentView.tipsContentLabel.text = @"1、虚拟商品版权归红岩网校工作站所有。\n2、在法律允许的范围内，本活动的最终解释权归红岩网校工作站所有。";
        }
        } failure:^{
            
        }];
    
}
#pragma mark - delegate
//MARK:UIScrollViewDelegate
///实现UIScrollView的滚动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self reloadPic];
    
//    [self.contentView.picScrollView setContentOffset:CGPointMake(picScrollViewWidth, 0) animated:NO];
    
    CGFloat offsetX = scrollView.contentOffset.x;
    int page = offsetX / scrollView.frame.size.width;
    self.contentView.pageControl.currentPage = page;
}
///开始拖拽scrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}
///停止拖拽scrollView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}
#pragma mark - 计时器
///自动播放到下一页
- (void)nextPage {
    if (self.contentView.pageControl.currentPage == 0) {
        self.isDirect = 1;
    }
    if (self.contentView.pageControl.currentPage == 2) {
        self.isDirect = -1;
    }
    NSInteger page = self.contentView.pageControl.currentPage + 1 * self.isDirect;
    
    [self.contentView.picScrollView setContentOffset:CGPointMake(page * self.contentView.picScrollView.frame.size.width, 0) animated:YES];
}
///
- (void)reloadPic {
    NSInteger leftIndex, rightIndex;
    NSInteger currentpage = self.contentView.pageControl.currentPage + 1;
    CGPoint offset = [self.contentView.picScrollView contentOffset];
    if (offset.x == 2 * picScrollViewWidth) {
        currentpage = (currentpage + 1) % 3;
        self.contentView.pageControl.currentPage = (self.contentView.pageControl.currentPage + 1) % 3;
    }else if (offset.x == 0){
        currentpage = (currentpage - 1) % 3;
        self.contentView.pageControl.currentPage = (self.contentView.pageControl.currentPage - 1) % 3;
    }
    leftIndex = (currentpage - 1) % 3;
    rightIndex = (currentpage + 1) % 3;
    self.contentView.centerimgView.backgroundColor =  self.contentView.color1[currentpage + 1];
    self.contentView.leftimgView.backgroundColor = self.contentView.color1[leftIndex+ 1];
    self.contentView.rightimgView.backgroundColor = self.contentView.color1[rightIndex + 1];
}
///开始计时器
- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}
///停止计时器
- (void)stopTimer {
    [self.timer invalidate];
}
#pragma mark - private
///是否兑换
- (void)isExchange {
    PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, 414, 900) AndID:_goodsID];
    [self.view addSubview:popupView];
    _popupView = popupView;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapBehind:)];
    UITapGestureRecognizer *whitegesture = [[UITapGestureRecognizer alloc]init];
//    [gesture setNumberOfTapsRequired:1];
//    gesture.cancelsTouchesInView = YES;
    [popupView.grayView addGestureRecognizer:gesture];
    [popupView.whiteView addGestureRecognizer:whitegesture];
}
///返回主页面
- (void)returnindex {
    [self.navigationController popViewControllerAnimated:YES];
}
///击其他区域关闭弹窗
- (void)handleTapBehind:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.popupView removeFromSuperview];
    }
}


@end
