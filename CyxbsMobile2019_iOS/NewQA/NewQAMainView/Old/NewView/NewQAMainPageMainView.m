//
//  NewQAMainPageMainView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQAMainPageMainView.h"

@interface NewQAMainPageMainView ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation NewQAMainPageMainView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setting];
    }
    return self;
}

#pragma mark - 初始化设置
- (void)setting{
    _titleHeight = SCREEN_WIDTH * 43/375;
    self.backgroundColor = [UIColor whiteColor];
    //底部线
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
}

#pragma mark - set
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                               NSForegroundColorAttributeName: _textColor};
}


#pragma mark - 定制VC
- (void)setupViewControllerWithFatherVC:(UIViewController *)fatherVC AndChildVC:(UIViewController *)childVC{
    UIViewController *vc = childVC;
    vc.view.frame = CGRectMake(0, _titleHeight, SCREEN_WIDTH, SCREEN_HEIGHT - _titleHeight);
    [fatherVC addChildViewController:vc];
    [self addSubview:vc.view];
}

@end
