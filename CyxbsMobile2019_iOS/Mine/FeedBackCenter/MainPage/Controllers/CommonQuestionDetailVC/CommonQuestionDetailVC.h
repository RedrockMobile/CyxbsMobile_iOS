//
//  CommonQuestionDetailVC.h
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "TopBarBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class WKWebView;
@interface CommonQuestionDetailVC : TopBarBasicViewController

@property (nonatomic,strong) NSArray *CommonQuestionAry;

@property (nonatomic,strong) WKWebView *webView;

@property (nonatomic,assign) NSInteger row;
- (void)setupBar;
- (void)setupData;
- (instancetype)initWithIndexPathRow:(NSInteger)row;
@end

NS_ASSUME_NONNULL_END
