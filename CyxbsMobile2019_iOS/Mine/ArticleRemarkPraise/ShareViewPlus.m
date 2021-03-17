//
//  ShareViewPlus.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ShareViewPlus.h"
#import "ShareView.h"

@interface ShareViewPlus()<ShareViewDelegate>
@property(nonatomic,strong)ShareView *shareView;
@end
@implementation ShareViewPlus
- (instancetype)init{
    self = [super init];
    if (self) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SCREEN_HEIGHT);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        UITapGestureRecognizer *TGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickedCancel)];
        [self addGestureRecognizer:TGR];
        [self addShareView];
    }
    return self;
}

- (void)addShareView {
    ShareView *view = [[ShareView alloc] init];
    [self addSubview:view];
    self.shareView = view;
    view.delegate = self;
    //加一个空手势，避免点击shareview后弹窗消失
    UITapGestureRecognizer *bankGR = [[UITapGestureRecognizer alloc] init];
    [view addGestureRecognizer:bankGR];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.6897);
        make.left.right.bottom.mas_equalTo(self);
    }];
}
- (void)ClickedQQZone{
    [self.delegate ClickedQQZone];
}
- (void)ClickedVXGroup{
    [self.delegate ClickedVXGroup];
}
- (void)ClickedQQ{
    [self.delegate ClickedQQ];
}
- (void)ClickedVXFriend{
    [self.delegate ClickedVXFriend];
}
- (void)ClickedUrl{
    [self.delegate ClickedUrl];
}
- (void)disMiss{
    [self removeFromSuperview];
}
- (void)ClickedCancel{
    [self removeFromSuperview];
}


@end

