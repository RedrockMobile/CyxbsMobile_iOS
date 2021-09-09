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
    if ([dataArray count] == 0) {
        [self loadTopFollowViewWithoutGroup:dataArray];
    }else {
        [self setMyFollowLab];
        [self loadTopFollowViewWithGroup:dataArray];
    }
}

- (void)setMyFollowLab {
    UILabel *myFollowLab = [[UILabel alloc] init];
    if (@available(iOS 11.0, *)) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"我关注的" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 18],NSForegroundColorAttributeName:[UIColor colorNamed:@"MainPageLabelColor"]}];
        myFollowLab.attributedText = string;
    } else {
        // Fallback on earlier versions
    }
    [self addSubview:myFollowLab];
    _myFollowLab = myFollowLab;
    [_myFollowLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_WIDTH * 0.0427 * 11/16);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.0427);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.1947 * 17/73);
    }];
}
- (void)loadTopFollowViewWithGroup:(NSMutableArray *)dataArray {
    [self removeAllSubviews];
    [self setMyFollowLab];
    [self startAnimationWith:dataArray];
}

- (void)loadTopFollowViewWithoutGroup:(NSMutableArray *)dataArray {
    [self removeAllSubviews];
    GroupFollowBtn *followBtn = [[GroupFollowBtn alloc] init];
//    followBtn.mgd_ignoreEvent = NO;
//    followBtn.mgd_acceptEventInterval = 1.0;
    [followBtn addTarget:self action:@selector(FollowGroups) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:followBtn];
    _followBtn = followBtn;
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.04);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0453);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.9147 * 73/343);
    }];
}

- (void)startAnimationWith:(NSMutableArray *)dataArray {
    [UIView animateWithDuration:2 animations:^{
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
            make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_WIDTH * 0.0427 * 11/16 + SCREEN_WIDTH * 0.1947 * 17/73);
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
    //    [self startAnimationWith:dataArray];
    } completion:^(BOOL finished) {

    }];
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

