//
//  DiscoverMineMessageVC.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/17.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DiscoverMineMessageVC.h"

#import "MineMessageVC.h"

#import "SystemMsgModel.h"

#pragma mark - MineMessageViewController ()

@interface DiscoverMineMessageVC ()

/// the messageBtn should the same frame with view
@property (nonatomic, strong) UIButton *messageBtn;

@end

#pragma mark - MineMessageViewController

@implementation DiscoverMineMessageVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat cap = 24.0 / 20.0;
    self.view.frame = CGRectMake(0, 0, 24 * cap, 24);
    
    [self.view addSubview:self.messageBtn];
    self.hadRead = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

#pragma mark - Method

- (void)reloadData {
    [HttpClient.defaultClient.httpSessionManager
     GET:MineMessage_GET_userHadRead_API
     parameters:nil
     headers:@{
        @"authorization" : [NSString stringWithFormat:@"Bearer %@", UserItemTool.defaultItem.token]
    }
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL hadread = [responseObject[@"data"][@"has"] boolValue];
        self.hadRead = hadread;
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

// MARK: SEL

- (void)discoverMinePushToMineMessage {
    MineMessageVC *vc = [[MineMessageVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController
     pushViewController:vc
     animated:YES];
}

#pragma mark - Getter

- (UIButton *)messageBtn {
    if (_messageBtn == nil) {
        _messageBtn = [[UIButton alloc] initWithFrame:self.view.SuperFrame];
        [_messageBtn
         setImage:[UIImage imageNamed:@"message_d"]
         forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(discoverMinePushToMineMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}

#pragma mark - Setter

- (void)setHadRead:(BOOL)hadRead {
    if (_hadRead == hadRead) {
        return;
    }
    if (hadRead) {
        [self.messageBtn setImage:[UIImage imageNamed:@"message_s"] forState:UIControlStateNormal];
    } else {
        [self.messageBtn setImage:[UIImage imageNamed:@"message_d"] forState:UIControlStateNormal];
    }
    _hadRead = hadRead;
}

@end
