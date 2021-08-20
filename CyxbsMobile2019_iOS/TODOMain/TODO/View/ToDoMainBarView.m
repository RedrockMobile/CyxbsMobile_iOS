//
//  ToDoMainBarView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/21.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ToDoMainBarView.h"
@interface ToDoMainBarView()
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// “邮子清单”的文本标题
@property (nonatomic, strong) UILabel *titleLbl;
/// 添加事务的button
@property (nonatomic, strong) UIButton *addMatterBtn;
@end

@implementation ToDoMainBarView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark- getter
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        
    }
    return _backBtn;
}

@end
