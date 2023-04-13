//
//  ElectricViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/4/12.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ElectricFeeModel.h"
#import "ElectricityView.h"
#import "ElectricViewController.h"
#import "PickerDormitoryModel.h"
#import "PickerDormitoryViewController.h"

@interface ElectricViewController () <
    ElectricityViewDelegate
    >

/// 电费View
@property (nonatomic, weak) ElectricityView *eleView;
/// 电费Model
@property (nonatomic, weak) ElectricFeeModel *elecModel;

@end

@implementation ElectricViewController

#pragma mark- life cicrle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F8F9FC" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
    //只切上面的圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH, 1000) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
    //设置阴影
    self.view.layer.shadowOpacity = 0.33f;
    self.view.layer.shadowColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#AEB6D3" alpha:0.16] darkColor:[UIColor colorWithHexString:@"#AEB6D3" alpha:0.16]].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0, -5);

    [self addEleView];
    [self requestData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeNotifications];
}

#pragma mark - Method
- (void)addEleView {
    ElectricityView *eleView = [[ElectricityView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 152)];
    self.eleView = eleView;
    eleView.delegate = self;
    [self.view addSubview:self.eleView];
}

- (void)requestData {
//    NSLog(@"%@",[UserItem defaultItem].room);
//    NSLog(@"%@",[UserItem defaultItem].building);
    ElectricFeeModel *elecModel = [[ElectricFeeModel alloc] init];
    self.elecModel = elecModel;
}

- (void)touchElectrictyView {
    PickerDormitoryViewController *vc = [[PickerDormitoryViewController alloc] init];

    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //填充全屏(原视图不会消失)
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)bindingRoomFailed {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:(MBProgressHUDModeText)];
    hud.labelText = @"绑定的宿舍号可能有问题哦，请重新绑定";
    [UserItem defaultItem].building = nil;
    [UserItem defaultItem].room = nil;
    [hud hide:YES afterDelay:1.2];
}

- (void)requestElectricFeeFailed {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [hud setMode:(MBProgressHUDModeText)];
//    hud.labelText = @"电费查询服务器开小差了哦，请稍后重试";
//    [hud hide:YES afterDelay:1];
//    return;
//    [NewQAHud showHudWith:@"电费查询服务器开小差了哦，请稍后重试" AddView:self.view];
}

- (void)updateElectricFeeUI {
    //先写入缓存
    [NSUserDefaults.standardUserDefaults setObject:self.elecModel.electricFeeItem.money forKey:@"ElectricFee_money"];
    [NSUserDefaults.standardUserDefaults setObject:self.elecModel.electricFeeItem.degree forKey:@"ElectricFee_degree"];
    [NSUserDefaults.standardUserDefaults setObject:self.elecModel.electricFeeItem.time forKey:@"ElectricFee_time"];
    [self.eleView refreshViewIfNeeded];
    [self.eleView.electricFeeMoney setText:self.elecModel.electricFeeItem.money];
//    [self.eleView.electricFeeMoney setTitle:self.elecModel.electricFeeItem.money forState:UIControlStateNormal];
    //self.eleView.electricFeeDegree.text = self.elecModel.electricFeeItem.degree;
    //这里读缓存以后日期的样式就改回去了，所以先屏蔽
}

#pragma mark - 通知中心
/// 添加通知中心
- (void)addNotifications {
    //绑定成功后重新请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"electricFeeRoomChange" object:nil];
    //绑定的宿舍号码有问题
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindingRoomFailed) name:@"electricFeeRoomFailed" object:nil];
    //服务器可能有问题，电费信息请求失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestElectricFeeFailed) name:@"electricFeeRequestFailed" object:nil];
    //获取成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateElectricFeeUI) name:@"electricFeeDataSucceed" object:nil];
}

//移除通知中心
- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"electricFeeRoomChange" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"electricFeeRoomFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"electricFeeRequestFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"electricFeeDataSucceed" object:nil];
}

@end
