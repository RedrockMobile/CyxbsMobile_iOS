//
//  IgnoreViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/12/18.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IgnoreViewController.h"
#import "IgnoreTableViewCell.h"
#import "IgnoreModel.h"
#import "IgnoreDataModel.h"


//#import <Social/Social.h>

@interface IgnoreViewController ()<UITableViewDelegate,UITableViewDataSource,MainPageModelDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)IgnoreModel *model;
@property(nonatomic,strong)NothingStateView *nothingView;
@end

@implementation IgnoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //父类是TopBarBasicViewController，调用父类的vcTitleStr的set方法，自动完成顶部的bar的设置
    self.VCTitleStr = @"屏蔽的人";
    self.model = [[IgnoreModel alloc] init];
    self.model.delegate = self;
    [self.model loadMoreData];
    [self addTableView];
}

- (void)addTableView{
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    if (@available(iOS 11.0, *)) {
        tableView.backgroundColor = [UIColor colorNamed:@"241_243_248&0_0_0"];
    } else {
        tableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:248/255.0 alpha:1];
    }
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.topBarView.mas_bottom);
    }];
    
    tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self.model refreshingAction:@selector(loadMoreData)];
    [tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IgnoreTableViewCell *cell = [[IgnoreTableViewCell alloc] init];
    [cell setDataWithDataModel:[[IgnoreDataModel alloc]initWithDict:self.model.dataArr[indexPath.row]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.2347 * SCREEN_WIDTH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",[UserItem defaultItem].redid);
}

//MARK:-model的代理方法：
- (void)mainPageModelLoadDataFinishWithState:(MainPageModelDataState)state {
    switch (state) {
        case StateNoMoreDate:
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            break;
        case StateEndRefresh:
            [self.tableView.mj_footer endRefreshing];
            break;
        case StateFailure:
            [self.tableView.mj_footer endRefreshing];
            [NewQAHud showHudWith:@"加载失败" AddView:self.view];
            break;
        default:
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        if (self.model.dataArr.count==0) {
            self.nothingView.alpha = 1;
        }else {
            self.nothingView.alpha = 0;
        }
    });
}

- (NothingStateView *)nothingView {
    if (_nothingView==nil) {
        _nothingView = [[NothingStateView alloc] initWithTitleStr:@"暂时还没有屏蔽的人噢～"];
        [self.view addSubview:_nothingView];
    }
    return _nothingView;
}
@end

//
////// 分享按钮的实现方法
////- (void)shareBtClick
////{
////    NSString *textToShare = @"要分享的文本内容";
////    UIImage *imageToShare = [UIImage imageNamed:@"编辑资料问号"];
////    NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];
////
////    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
////    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
////
////    [self presentViewController:activityVC animated:YES completion:nil];
////}
//
//// 分享按钮的实现方法
//- (void)shareBtnClick
//{
//    // Share Extension 分享入口，需要分享到哪个平台就用哪个平台的id
//    NSString *socialType = @"com.apple.Health.HealthShareExtension";
//    /* 1、 系统只提供了下面几种分享平台：
//     SLServiceTypeTwitter;
//     SLServiceTypeFacebook;
//     SLServiceTypeSinaWeibo;
//     SLServiceTypeTencentWeibo;
//     SLServiceTypeLinkedIn;
//     2、iOS8之后系统推出的Share Extension,可以通过App的Share Extension提供了分享入口进行分享如微信的：com.tencent.xin.sharetimeline
//     实际可以根据id来分享到更多平台，如微信:
//     NSString *socialType = @"com.tencent.xin.sharetimeline";
//     SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:socialType];
//     //
//     3、 下面是小编整理的部分平台id 2017-9-15
//      com.taobao.taobao4iphone.ShareExtension  //  淘宝
//      com.apple.share.Flickr.post}",   //  Flickr
//      com.apple.share.SinaWeibo.post  //   新浪微博
//     com.laiwang.DingTalk.ShareExtension  //   钉钉
//     com.apple.mobileslideshow.StreamShareService  //  iCloud
//     com.alipay.iphoneclient.ExtensionSchemeShare  //   支付宝
//     com.apple.share.Facebook.post  //   Facebook
//     com.apple.share.Twitter.post  //   Twitter
//     com.apple.Health.HealthShareExtension}",    // 应该是健康管理
//     com.tencent.xin.sharetimeline  //   微信（好友、朋友圈、收藏）
//     com.apple.share.TencentWeibo.post  //   腾讯微博
//     com.tencent.mqq.ShareExtension  //   QQ
//     */
//
//    // 创建 分享的控制器
//    SLComposeViewController *composeVC  = [SLComposeViewController composeViewControllerForServiceType:socialType];
//    if (!composeVC) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.labelText = @"您尚未安装软件";
//        [hud show:YES];
//        [hud hide:YES afterDelay:1];
//        return;
//    }
////    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
////        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////        hud.labelText = @"软件未配置登录信息";
////        [hud show:YES];
////        [hud hide:YES afterDelay:1];
////        return;
////    }
//    //添加分享的文字、图片、链接
//    [composeVC setInitialText:@"哈罗大家好，这是分享测试的内容哦，如已看请忽略！如有任何疑问可联系1008611查你话费吧！"];
//    [composeVC addImage:[UIImage imageNamed:@"动态(1)@2x.png"]];
//    [composeVC addURL:[NSURL URLWithString:@"http://blog.csdn.net/Boyqicheng"]];
//
//    //弹出分享控制器
//    [self presentViewController:composeVC animated:YES completion:nil];
//
//    //监听用户点击了取消还是发送
//    composeVC.completionHandler = ^(SLComposeViewControllerResult result){
//        if (result == SLComposeViewControllerResultCancelled) {
//            NSLog(@"点击了取消");
//        } else {
//            NSLog(@"点击了发送");
//        }
//
//    };
//}

