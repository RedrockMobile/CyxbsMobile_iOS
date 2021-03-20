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
#import "UIControl+MGD.h"


@interface TopFollowView()
@property (nonatomic, strong) GroupBtn *groupBtn;
@end

@implementation TopFollowView

- (instancetype)initWithFrame:(CGRect)frame And:(NSMutableArray *)dataArray{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    [self loadViewWithArray:dataArray];
    return self;
}

- (void)loadViewWithArray:(NSMutableArray *)dataArray {
    ///根据后端传回来的数据源数组来判断放哪个控件
    if ([dataArray count] == 0) {
        GroupFollowBtn *followBtn = [[GroupFollowBtn alloc] init];
        followBtn.ignoreEvent = NO;
        followBtn.canTapEventInterval = 1.0;
        [followBtn addTarget:self action:@selector(FollowGroups) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:followBtn];
        _followBtn = followBtn;
        [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.04);
            make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.0453);
            make.height.mas_equalTo(SCREEN_WIDTH * 0.9147 * 73/343);
        }];
    }else {
        UILabel *myFollowLab = [[UILabel alloc] init];
        if (@available(iOS 11.0, *)) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"我关注的" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 18],NSForegroundColorAttributeName:[UIColor colorNamed:@"MainPageLabelColor"]}];
            myFollowLab.attributedText = string;
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:myFollowLab];
        _myFollowLab = myFollowLab;
        
        UIScrollView *groupsScrollView = [[UIScrollView alloc] init];
        groupsScrollView.backgroundColor = [UIColor clearColor];
        groupsScrollView.showsHorizontalScrollIndicator = NO;
        groupsScrollView.showsVerticalScrollIndicator = NO;
        groupsScrollView.userInteractionEnabled = YES;
        groupsScrollView.scrollEnabled = YES;
        groupsScrollView.alwaysBounceVertical =NO;
        ///可滑动范围由按钮数量决定
        [self addSubview:groupsScrollView];
        _groupsScrollView = groupsScrollView;
        
        ///通过for循环创建数组
        for (int i = 0;i < dataArray.count; i++) {
        ///创建第一个按钮，没有小蓝点
            GroupBtn *btn = [[GroupBtn alloc] init];
            GroupItem *item = dataArray[i];
            btn.item = item;
            btn.tag = i;
            [btn addTarget:self action:@selector(ClickedGroupBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(SCREEN_WIDTH * 0.044 + SCREEN_WIDTH * 0.25 * i, SCREEN_WIDTH * 0.1215 * 20.5/45.55, SCREEN_WIDTH * 0.1293, SCREEN_WIDTH * 0.1293 * 63.45/48.5);
            [_groupsScrollView addSubview:btn];
        }
        groupsScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 0.044 + SCREEN_WIDTH * 0.25 * dataArray.count, CGRectGetHeight(_groupBtn.frame));
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_myFollowLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_WIDTH * 0.0427 * 11/16);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.0427);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0255);
    }];
    
    [_groupsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myFollowLab.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.1619);
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

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
 
   NSLog(@"用户点击的视图 %@",view);
   return YES;
}
@end

