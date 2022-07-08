//
//  NewQAMainTableView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/9/12.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQAMainTableView.h"


@interface NewQAMainTableView ()


@end

@implementation NewQAMainTableView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dataSource = self;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 结束刷新
                [self.mj_header endRefreshing];
            });
        }];
        self.mj_header.backgroundColor = [UIColor yellowColor];
        
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 结束刷新
                [self.mj_footer endRefreshing];
            });
        }];
        self.mj_footer.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)dealloc
{
    
}


- (void)didMoveToWindow
{
    [super didMoveToWindow];
}



- (void)setContentOffset:(CGPoint)contentOffset
{

    if (self.window)
    {
        [super setContentOffset:contentOffset];
    }
}



#pragma mark - Event Response

#pragma mark - Private Method

#pragma mark - Setters And Getters

@end
