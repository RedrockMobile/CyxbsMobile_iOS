//
//  MineMessageVC.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/17.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "MineMessageVC.h"

// “更多”泡泡VC
#import "MineMessageMoreVC.h"

// "系统消息"子VC
#import "SystemMessageVC.h"

// "活动消息"子VC
#import "ActiveMessageVC.h"

// 这个VC的顶部视图
#import "MineMessageTopView.h"

// "设置"push的VC
#import "MessageSettingVC.h"

// 模型
#import "MineMessageModel.h"

#pragma mark - MineMessageVC ()

@interface MineMessageVC () <
    MineMessageTopViewDelegate,
    MineMessageMoreVCDelegate,
    UIPopoverPresentationControllerDelegate,
    SystemMessageVCDelegate,
    ActiveMessageVCDelegate
>

/// 顶部视图
@property (nonatomic, strong) MineMessageTopView *topView;

/// 消息通知
@property (nonatomic, strong) SystemMessageVC *systemMessageVC;

/// 活动通知
@property (nonatomic, strong) ActiveMessageVC *activeMessageVC;

/// 两个VC视图加载这上面，用于动画
@property (nonatomic, strong) UIView *contentView;

/// 总的一个模型，用来请求，和其他骚操作
@property (nonatomic, strong) MineMessageModel *mineMsgModel;

/// bk
@property (nonatomic, strong) UIImageView *bkImgView;

@end

#pragma mark - MineMessageVC

@implementation MineMessageVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =
    [UIColor dm_colorWithLightColor:[UIColor xFF_R:248 G:249 B:252 Alpha:1]
                          darkColor:[UIColor xFF_R:0 G:1 B:1 Alpha:1]];
    self.mineMsgModel = [[MineMessageModel alloc] init];
    
    [self.view addSubview:self.topView];
    [self addChildViewController:self.systemMessageVC];
    [self addChildViewController:self.activeMessageVC];
    
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.systemMessageVC.view];
    [self.contentView addSubview:self.activeMessageVC.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.bkImgView removeFromSuperview];
    
    [self.mineMsgModel
     requestSuccess:^{
        self.systemMessageVC.sysMsgModel = self.mineMsgModel.systemMsgModel;
        BOOL needSysBall = [self.systemMessageVC hadReadAfterReloadData];
        self.topView.systemHadMsg = needSysBall;
        
        self.activeMessageVC.sysModel = self.mineMsgModel.activeMsgModel;
        BOOL needActBall = [self.activeMessageVC hadReadAfterReloadData];
        self.topView.activeHadMsg = needActBall;
        
        if (self.contentView.left < self.view.width / 2) {
            if (!self.systemMessageVC.sysMsgModel || !self.systemMessageVC.sysMsgModel.msgAry.count) {
                [NewQAHud showHudWith:@"没有系统消息了" AddView:self.systemMessageVC.view];
            }
        } else {
            if (!self.activeMessageVC.sysModel || !self.systemMessageVC.sysMsgModel.msgAry.count) {
                [NewQAHud showHudWith:@"没有活动消息了" AddView:self.activeMessageVC.view];
            }
        }
    }
     failure:^(NSError * _Nonnull error) {
        [NewQAHud showHudWith:@"网络异常"
                      AddView:(self.contentView.left < self.view.width / 2 ?
                               self.systemMessageVC.view :
                               self.activeMessageVC.view)];
        
        [self.systemMessageVC.view addSubview:self.bkImgView];
        self.bkImgView.center = self.systemMessageVC.view.SuperCenter;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.contentView.left < -self.view.width / 2) {
        self.systemMessageVC.view.hidden = YES;
    }
}

#pragma mark - Getter

- (UIImageView *)bkImgView {
    if (_bkImgView == nil) {
        _bkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, 171, 111)];
        _bkImgView.image = [UIImage imageNamed:@"人在手机里"];
    }
    return _bkImgView;
}

#pragma mark - Method

- (void)popMineMessageVC {
    if (self.contentView.left < -self.view.width / 2) {
        self.systemMessageVC.view.hidden = YES;
    }
    [self.navigationController popViewControllerAnimated:YES]; 
}

- (void)contentViewScrollTo:(UIView *)view moreSpace:(CGFloat)moreSpace{
    [UIView
     animateWithDuration:0.4
     animations:^{
        self.contentView.left = -view.left + moreSpace;
    }
     completion:^(BOOL finished) {
        if (finished) {
            self.topView.lineIsScroll ?
             dispatch_after(0.6, dispatch_get_main_queue(), ^{
                [UIView
                 animateWithDuration:0.2
                 animations:^{
                    self.contentView.left = -view.left;
                }];
             }) :
             [UIView
              animateWithDuration:0.2
              animations:^{
                 self.contentView.left = -view.left;
             }];
        }
    }];
}

// MARK: SEL

- (void)showMore:(UIButton *)sender {
    // 只要没报错，不崩溃，建议不要更改如下代码（需要进一步验证）
    if (!self.systemMessageVC.isEditing) {
        MineMessageMoreVC *moreVC = [[MineMessageMoreVC alloc] init];
        moreVC.delegate = self;
        
        UIPopoverPresentationController *popVC = moreVC.popoverPresentationController;
        // > 弹出控制器的箭头指向的view
        popVC.sourceView = sender;
        // > 弹出视图的箭头的“尖”的坐标 - 在sender的底部边缘居中）
        popVC.sourceRect = sender.bounds;
        [self presentViewController:moreVC animated:YES completion:nil];
    }
}

#pragma mark - <MineMessageTopViewDelegate>

- (void)mineMessageTopView:(MineMessageTopView *)view
            willScrollFrom:(UIButton *)firstBtn
                     toBtn:(UIButton *)secendbtn {
    [self
     contentViewScrollTo:(firstBtn.left < secendbtn.left ?
                          self.activeMessageVC.view :
                          self.systemMessageVC.view)
     moreSpace:(firstBtn.left < secendbtn.left ? -7 : 7)];
    if (firstBtn.left < secendbtn.left) {
        [self.systemMessageVC viewWillDisappear:YES];
        [self.activeMessageVC viewDidAppear:YES];
    } else {
        [self.activeMessageVC viewWillDisappear:YES];
        [self.systemMessageVC viewDidAppear:YES];
    }
}

#pragma mark - <MineMessageMoreVCDelegate>

- (void)mineMessageMoreVC:(MineMessageMoreVC *)vc selectedTitle:(NSString *)title {
    if ([title isEqualToString:@"一键已读"]) {
        // 分VC
        if (!vc.popoverPresentationController.sourceView.tag) {
            // 系统通知
            [self.systemMessageVC readAllMessage];
        } else {
            // 活动通知
            [self.activeMessageVC readAllMessage];
        }
    } else if ([title isEqualToString:@"删除已读"]) {
        // 只有sysVC有
        [self.systemMessageVC deleteAllReadMessage];
    } else {
        // 单击了设置，小红点无了，但需要我们去标记UserDefualt
        [USER_DEFAULT setBool:YES forKey:MineMessage_hadSettle_BOOL];
        
        self.topView.moreHadSet = [USER_DEFAULT boolForKey:MineMessage_hadSettle_BOOL];
        [self.navigationController pushViewController:[[MessageSettingVC alloc] init] animated:YES];
    }
}

#pragma mark - <SystemMessageVCDelegate>

- (void)systemMessageVC_hadReadAllMsg:(SystemMessageVC *)vc {
    self.topView.systemHadMsg = NO;
}

#pragma mark - <ActiveMessageVCDelegate>

- (void)activeMessageVC_hadReadAllMsg:(ActiveMessageVC *)vc {
    self.topView.activeHadMsg = NO;
}

#pragma mark - Getter

- (MineMessageTopView *)topView {
    if (_topView == nil) {
        _topView = [[MineMessageTopView alloc] initWithSafeViewHeight:94];
        [_topView addBackButtonTarget:self action:@selector(popMineMessageVC)];
        [_topView addMoreBtnTarget:self action:@selector(showMore:)];
        _topView.delegate = self;
        
        _topView.systemHadMsg = NO;
        _topView.activeHadMsg = NO;
        _topView.moreHadSet = [USER_DEFAULT boolForKey:MineMessage_hadSettle_BOOL];
    }
    return _topView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, 2 * SCREEN_WIDTH, self.view.height - self.topView.bottom)];
        _contentView.backgroundColor = UIColor.clearColor;
        [_contentView addSubview:self.systemMessageVC.view];
        [_contentView addSubview:self.activeMessageVC.view];
    }
    return _contentView;
}

- (SystemMessageVC *)systemMessageVC {
    if (_systemMessageVC == nil) {
        _systemMessageVC =
        [[SystemMessageVC alloc]
         initWithSystemMessage:self.mineMsgModel.systemMsgModel
         frame:CGRectMake(0, 0, self.view.width, self.contentView.height)];
        
        _systemMessageVC.delegate = self;
    }
    return _systemMessageVC;
}

- (ActiveMessageVC *)activeMessageVC {
    if (_activeMessageVC == nil) {
        _activeMessageVC =
        [[ActiveMessageVC alloc] initWithActiveMessage:self.mineMsgModel.activeMsgModel frame:CGRectMake(self.systemMessageVC.view.right, 0, self.view.width, self.contentView.height)];
        
        _activeMessageVC.delegate = self;
    }
    return _activeMessageVC;
}

@end
