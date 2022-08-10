//
//  DiscoverSAVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2022/8/8.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DiscoverSAVC.h"

#import "SportAttendanceModel.h"
#import "SportAttendanceViewController.h"

#import "DataContentView.h"
#import "popUpViewController.h"
#import "DateModle.h"

@interface DiscoverSAVC ()

/// 进入详情页/IDS绑定页的btn
@property (nonatomic, strong) UIButton *SABtn;

/// 进入信息说明的btn
@property (nonatomic, strong) UIButton *learnBtn;//learnmore

/// SportAttendance数据模型
@property (nonatomic, strong) SportAttendanceModel *sAModel;

@end

@implementation DiscoverSAVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dm_colorWithLightColor: [UIColor colorWithHexString:@"#F8F9FC" alpha:1] darkColor: [UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
    //只切上面的圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH, 1000) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
    //设置阴影
    self.view.layer.shadowOpacity = 0.33f;
    self.view.layer.shadowColor = [UIColor dm_colorWithLightColor: [UIColor colorWithHexString:@"#AEB6D3" alpha:0.16] darkColor: [UIColor colorWithHexString:@"#AEB6D3" alpha:0.16]].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0, -5);

    //监听IDS绑定是否成功,成功后刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(idsBindingSuccess) name:@"IdsBinding_Success" object:nil];
    
    //默认为未绑定的失败页
//    [self addFailureView];
    [self addSuccessView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getSportData];
}

#pragma mark - getter
- (SportAttendanceModel *)sAModel{
    if (!_sAModel) {
        self.sAModel = [[SportAttendanceModel alloc] init];
    }
    return _sAModel;
}

- (UIButton *)learnBtn{
    if (!_learnBtn) {
        _learnBtn = [[UIButton alloc] init];
        [_learnBtn setImage:[UIImage imageNamed:@"learnmore"] forState:UIControlStateNormal];
        [_learnBtn addTarget:self action:@selector(learnAbout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _learnBtn;
}

- (UIButton *)SABtn{
    if (!_SABtn) {
        _SABtn = [[UIButton alloc] init];
        _SABtn.backgroundColor = UIColor.clearColor;
        _SABtn.alpha = 0.1;
    }
    return _SABtn;
}

#pragma mark - 添加基础视图
- (void)addbaseView{
    [self addSeperateLine];
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 23, 75, 25)];
    nameLab.text = @"体育打卡";
    nameLab.font = [UIFont fontWithName:PingFangSCBold size: 18];
    nameLab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    [self.view addSubview:nameLab];
    
    [self.view addSubview:self.learnBtn];
    [_learnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLab.mas_right).offset(8);
        make.centerY.equalTo(nameLab);
        make.height.equalTo(@16);
        make.width.equalTo(@16);
    }];
    
    UILabel *describeLab = [[UILabel alloc] init];
    describeLab.text = @"实际以教务在线为准";
    describeLab.font = [UIFont fontWithName:PingFangSCLight size: 10];
    describeLab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:0.6] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.4]];
    [self.view addSubview:describeLab];
    [describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.centerY.equalTo(nameLab);
        make.height.equalTo(@14);
        make.width.equalTo(@90);
    }];
    
    [self.view addSubview:self.SABtn];
    [_SABtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.learnBtn.mas_bottom).offset(10);
        make.bottom.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
}

- (void)addSeperateLine {
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:0.1] darkColor:[UIColor colorWithHexString:@"#2D2D2D" alpha:0.5]];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
}
#pragma mark - 添加数据视图
//查询成功,点击进入详情页
- (void)addSuccessView{
    [self removeView];
    [self addbaseView];
    DataContentView *view1 = [[DataContentView alloc] init];
    NSString *str1 = [[NSString alloc] initWithFormat:@"%ld", ((self.sAModel.run_total - self.sAModel.run_done) > 0) ? (self.sAModel.run_total-self.sAModel.run_done) : 0 ];
    view1 = [DataContentView loadViewWithData:str1
                                        unit:@"次"
                                        detail:@"跑步剩余"];
    [self.view addSubview:view1];
  
    NSString *str2 = [[NSString alloc] initWithFormat:@"%ld", ((self.sAModel.other_total - self.sAModel.other_done) > 0) ? (self.sAModel.other_total-self.sAModel.other_done) : 0 ];
    DataContentView *view2 = [[DataContentView alloc] init];
    view2 = [DataContentView loadViewWithData:str2
                                        unit:@"次"
                                        detail:@"其他剩余"];
    view2.frame = CGRectMake(220, 50, 200, 200);
    [self.view addSubview:view2];
    
    NSString *str3 = [[NSString alloc] initWithFormat:@"%ld",self.sAModel.award];
    DataContentView *view3 = [[DataContentView alloc] init];
    view3 = [DataContentView loadViewWithData:str3
                                        unit:@"次"
                                        detail:@"奖励"];
    view3.frame = CGRectMake(220, 50, 200, 200);
    [self.view addSubview:view3];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SABtn).offset(30);
        make.centerX.equalTo(self.view);
    }];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2);
        make.centerX.equalTo(self.view).offset(-(SCREEN_WIDTH - 44 - 60)/2);
    }];
    
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2);
        make.centerX.equalTo(self.view).offset((SCREEN_WIDTH - 44 - 60)/2 - 17);
    }];
    

    //点击按钮进入详情页
    [_SABtn removeAllTargets];
    [_SABtn addTarget:self action:@selector(lookData) forControlEvents:UIControlEventTouchUpInside];
}

//查询失败,点击进入绑定页
- (void)addFailureView{
    [self removeView];
    [self addbaseView];
    UILabel *Lab = [[UILabel alloc] init];
    Lab.font = [UIFont fontWithName:PingFangSCMedium size:14];
    Lab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:0.6] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.4]];
    
    NSString *keyword = @"教务在线";
    NSString *result = @"查询失败，请先绑定 教务在线 后再试";
     
    // 设置标签文字
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:result];
     
    // 获取标红的位置和长度
    NSRange range = [result rangeOfString:keyword];
     
    // 设置标签文字的属性
    [attrituteString setAttributes:@{
        NSForegroundColorAttributeName:
            [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#4A44E4" alpha:1] darkColor:[UIColor colorWithHexString:@"#465FFF" alpha:1]],
        NSFontAttributeName:
            [UIFont fontWithName:PingFangSCMedium size:14],
        NSUnderlineStyleAttributeName:
            [NSNumber numberWithInteger:NSUnderlineStyleSingle]
    }
        range:range];
    
    // 显示在Label上
    Lab.attributedText = attrituteString;
    
    [self.view addSubview:Lab];
    [Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(20);
    }];
    
    //点击按钮进入绑定页
    [_SABtn removeAllTargets];
    [_SABtn addTarget:self action:@selector(IDSBing) forControlEvents:UIControlEventTouchUpInside];
}

//当前数据错误，无操作
- (void)addWrongView{
    [self removeView];
    [self addbaseView];
    UILabel *Lab = [[UILabel alloc] init];
    Lab.text = @"当前数据错误，正在努力修复中";
    Lab.font = [UIFont fontWithName:PingFangSCMedium size:14];
    Lab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:0.6] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.4]];
    [self.view addSubview:Lab];
    [Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(20);
    }];
    
    //点击按钮无反应
    [_SABtn removeAllTargets];
}


//移除视图
- (void)removeView{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - Method
//查看更多
- (void)learnAbout{
    popUpViewController *vc = [[popUpViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

//进入IDS绑定页面
- (void)IDSBing{
    UIViewController *vc = [self.router controllerForRouterPath:@"IDSController"];
    vc.view.backgroundColor = UIColor.whiteColor;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

//查看详细数据
- (void)lookData{
    UIViewController *vc = [self.router controllerForRouterPath:@"SportController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//绑定成功刷新数据
- (void)idsBindingSuccess{
    
    
}

- (void)getSportData{
    [self.sAModel requestSuccess:^{
        if (self.sAModel.status == 10000) {
            //得到数据后加载成功页
            [self addSuccessView];
        }else{
            //获取数据错误
            [self addWrongView];
        }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"体育打卡加载失败");
    }];
}

#pragma mark - RisingRouterHandler

+ (NSArray<NSString *> *)routerPath {
    return @[
        @"DiscoverSAVC"
    ];
}

+ (void)responseRequest:(RisingRouterRequest *)request completion:(RisingRouterResponseBlock)completion {
    
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
    switch (request.requestType) {
        case RouterRequestPush: {
            
            UINavigationController *nav = (request.requestController ? request.requestController : RisingRouterRequest.useTopController).navigationController;
            
            if (nav) {
                DiscoverSAVC *vc = [[self alloc] init];
                response.responseController = vc;
                
                [nav pushViewController:vc animated:YES];
            } else {
                
                response.errorCode = RouterWithoutNavagation;
            }
            
        } break;
            
        case RouterRequestParameters: {
            // TODO: 传回参数
        } break;
            
        case RouterRequestController: {
            
            DiscoverSAVC *vc = [[self alloc] init];
            
            response.responseController = vc;
        } break;
    }
    
    if (completion) {
        completion(response);
    }
}


@end
