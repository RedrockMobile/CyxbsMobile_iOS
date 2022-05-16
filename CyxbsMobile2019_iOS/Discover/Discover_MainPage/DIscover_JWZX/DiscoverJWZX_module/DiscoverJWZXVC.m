//
//  DiscoverJWZXVC.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DiscoverJWZXVC.h"

#import "JWZXNewsViewController.h"
#import "NewDetailViewController.h"

#import "SSRTextCycleView.h"

#import "JWZXNewsModel.h"

#pragma mark - DiscoverJWZXVC ()

/// 暴露在外面的教务新闻VC
@interface DiscoverJWZXVC () <
    TextCycleViewDelegate
>

/// 教务在线数据模型（旧用）
//@property (nonatomic, strong) JWZXNewsModel *newsModel;



/// 一个sectionNew
@property (nonatomic, strong) JWZXSectionNews *sectionNewsModel;

/// 进入主页的btn
@property (nonatomic, strong) UIButton *jwNewsBtn;

/// 直接进入详情页的btn
@property (nonatomic, strong) SSRTextCycleView *textCycleView;

/// 临时宽度
@property (nonatomic) CGFloat width;

@end

#pragma mark - DiscoverJWZXVC

@implementation DiscoverJWZXVC

#pragma mark - Life cycle

- (instancetype)initWithWidth:(CGFloat)width {
    self = [super init];
    if (self) {
        self.width = width;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, self.width, 20);
    
    [self.view addSubview:self.jwNewsBtn];
    [self.view addSubview:self.textCycleView];
    
    [self request];
}

#pragma mark - Method

- (void)request {
    [JWZXSectionNews
     requestWithPage:1
     success:^(JWZXSectionNews * _Nullable sectionNews) {
        self.sectionNewsModel = sectionNews;
        NSMutableArray <NSString *> * mtAry = NSMutableArray.array;
        for (JWZXNew *new in sectionNews.newsAry) {
            [mtAry addObject:new.title];
        }
        self.textCycleView.textAry = mtAry.copy;
    }
     failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)pushToJWZXNewsController {
    JWZXNewsViewController *vc =
    [[JWZXNewsViewController alloc] initWithRootJWZXSectionModel:self.sectionNewsModel];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter

- (UIButton *)jwNewsBtn {
    if (_jwNewsBtn == nil) {
        _jwNewsBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, 68, self.view.height)];
        [_jwNewsBtn setTitle:@"教务在线" forState:UIControlStateNormal];
        [_jwNewsBtn setBackgroundImage:[UIImage imageNamed:@"教务在线背景"] forState:normal];
        
        [_jwNewsBtn setTitleColor:
         [UIColor dm_colorWithLightColor:UIColor.whiteColor
                               darkColor:UIColor.blackColor]
                         forState:UIControlStateNormal];
        
        _jwNewsBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size: 11];
        _jwNewsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_jwNewsBtn addTarget:self action:@selector(pushToJWZXNewsController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jwNewsBtn;
}

- (SSRTextCycleView *)textCycleView {
    if (_textCycleView == nil) {
        CGFloat left = self.jwNewsBtn.right + 14;
        _textCycleView = [[SSRTextCycleView alloc] initWithFrame:CGRectMake(left, 0, self.view.width - left - 16, self.view.height)];
        _textCycleView.backgroundColor = UIColor.clearColor;
        _textCycleView.autoTimeInterval = 3;
        _textCycleView.textCycleView_delegate = self;
        
        NSString *oneNew = [NSUserDefaults.standardUserDefaults stringForKey:JWZX_oneNews_String];
        self.textCycleView.textAry = oneNew ? @[oneNew] : @[@"教务新闻正在请求中..."];
    }
    return _textCycleView;
}

#pragma mark - <TextCycleViewDelegate>

- (void)textCycleView:(SSRTextCycleView *)view didSelectedAtIndex:(NSInteger)index {
    JWZXNew *aNew = self.sectionNewsModel
        .newsAry[index % self.sectionNewsModel.newsAry.count];
    
    NewDetailViewController *vc =
    [[NewDetailViewController alloc]
     initWithNewsID:aNew.NewsID
     date:aNew.date
     title:aNew.title];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController
     pushViewController:vc
     animated:YES];
}

- (SSRTextCycleCell *)textCycleView:(SSRTextCycleView *)view cellForIndex:(NSInteger)index {
    SSRTextCycleCell *cell = [self.textCycleView dequeueReusableCellWithIdentifier:SSRTextCycleCellReuseIdentifier];
    
    if (cell == nil) {
        cell = [[SSRTextCycleCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SSRTextCycleCellReuseIdentifier];
        
        cell.ssrTextLab.textColor =
        [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1]
                              darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        
        cell.ssrTextLab.backgroundColor = UIColor.clearColor;
        cell.ssrTextLab.font = [UIFont fontWithName:PingFangSC size:15];
        cell.backgroundColor = UIColor.clearColor;
        cell.contentView.backgroundColor = UIColor.clearColor;
        cell.frame = view.SuperFrame;
        cell.contentView.frame = cell.SuperFrame;
        [cell drawTextLab];
    }
    return cell;
}

@end
