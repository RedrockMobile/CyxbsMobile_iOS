//
//  TopFollowView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "TopFollowView.h"
#import "GroupFollowBtn.h"
#import "GroupBtn.h"
#import "GroupModel.h"
//#import "UIControl+MGD.h"


@interface TopFollowView()
@property (nonatomic, strong) GroupBtn *groupBtn;
@end

@implementation TopFollowView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



- (void)loadViewWithArray:(NSMutableArray *)dataArray {
    ///根据后端传回来的数据源数组来判断放哪个控件
//    if ([dataArray count] == 0) {
//        [self loadTopFollowViewWithoutGroup:dataArray];
//    }else {
//        [self loadTopFollowViewWithGroup:dataArray];
//    }
    [self loadTopFollowViewWithGroup:dataArray];
}

- (void)loadTopFollowViewWithGroup:(NSMutableArray *)dataArray {
    [self startAnimationWith:dataArray];
}

- (void)startAnimationWith:(NSMutableArray *)dataArray {
    if ([dataArray count] == 0) {
        UIScrollView *groupsScrollView = [[UIScrollView alloc] init];
        groupsScrollView.backgroundColor = [UIColor clearColor];
        groupsScrollView.showsHorizontalScrollIndicator = NO;
        groupsScrollView.showsVerticalScrollIndicator = NO;
        groupsScrollView.userInteractionEnabled = YES;
        groupsScrollView.scrollEnabled = YES;
        groupsScrollView.alwaysBounceVertical =NO;
        ///可滑动范围由按钮数量决定
        [self addSubview:groupsScrollView];
        self.groupsScrollView = groupsScrollView;
        
        [self.groupsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(HScaleRate_SE * 14);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(0);
        }];
    }else {
        UIScrollView *groupsScrollView = [[UIScrollView alloc] init];
        groupsScrollView.backgroundColor = [UIColor clearColor];
        groupsScrollView.showsHorizontalScrollIndicator = NO;
        groupsScrollView.showsVerticalScrollIndicator = NO;
        groupsScrollView.userInteractionEnabled = YES;
        groupsScrollView.scrollEnabled = YES;
        groupsScrollView.alwaysBounceVertical =NO;
        ///可滑动范围由按钮数量决定
        [self addSubview:groupsScrollView];
        self.groupsScrollView = groupsScrollView;
        
        [self.groupsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(HScaleRate_SE * 14);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(SCREEN_WIDTH * 108/375);
        }];
        
    //    [self seUIFrame];
        ///通过for循环创建数组
        CGFloat sum = 0;
        CGFloat prevWidth = 0;
        CGFloat totalWidth = 0;
        for (int i = 0;i < dataArray.count; i++) {
        ///创建第一个按钮，没有小蓝点
            GroupBtn *btn = [[GroupBtn alloc] init];
            GroupItem *item = dataArray[i];
            btn.item = item;
            btn.tag = i;
            totalWidth += (btn.btnWeight + SCREEN_WIDTH * 0.08);
            if (btn.tag == 0) {
                sum = 0;
            } else {
                sum += (prevWidth + SCREEN_WIDTH * 0.08);
            }
            prevWidth = btn.btnWeight;
            [btn addTarget:self action:@selector(ClickedGroupBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(SCREEN_WIDTH * 0.044 + sum, SCREEN_WIDTH * 0.1215 * 20.5/45.55, btn.btnWeight, SCREEN_WIDTH * 0.1293 * 63.45/48.5);
            [self.groupsScrollView addSubview:btn];
        }
        self.groupsScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 0.044 + totalWidth, CGRectGetHeight(self->_groupBtn.frame));
    }
}



#pragma mark - TopFollowDelegate
- (void)FollowGroups {
    if ([self.delegate respondsToSelector:@selector(FollowGroups)]) {
        [self.delegate FollowGroups];
    }
}

- (void)ClickedGroupBtn:(GroupBtn *)sender {
    if ([self.delegate respondsToSelector:@selector(ClickedGroupBtn:)]) {
        [self.delegate ClickedGroupBtn:sender];
    }
}

- (void)reloadTopFollowViewWithArray:(NSMutableArray *)array {
    if ([self.delegate respondsToSelector:@selector(reloadTopFollowViewWithArray:)]) {
        [self.delegate reloadTopFollowViewWithArray:array];
    }
}

- (void)removeTopFollowView {
    if ([self.delegate respondsToSelector:@selector(removeTopFollowView)]) {
        [self.delegate removeTopFollowView];
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
 
   NSLog(@"用户点击的视图 %@",view);
   return YES;
}
@end

