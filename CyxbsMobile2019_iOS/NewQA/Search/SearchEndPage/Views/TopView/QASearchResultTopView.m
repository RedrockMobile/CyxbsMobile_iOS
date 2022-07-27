//
//  QASearchResultTopView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/12/11.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "QASearchResultTopView.h"
@interface QASearchResultTopView()
///分割条
@property (nonatomic, strong) UIView *topSeparation;

/// 搜索结果是否有邮问知识库
@property (nonatomic, assign) BOOL isHaveQAKnowledge;
@end

@implementation QASearchResultTopView
- (instancetype)initWithFrame:(CGRect)frame AndTextAry:(nonnull NSArray *)textAry IsHaveQAKnowledge:(BOOL)isHaveQAKnowledge{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
//        self.segementBtnTextAry = @[@"用户", @"内容"];
        self.isHaveQAKnowledge = isHaveQAKnowledge;
        self.segementBtnTextAry = textAry;
        [self setUI];
    }
    return self;
}

#pragma mark -private methonds
- (void)setUI{
    //顶部搜索bar
    [self addSubview:self.searchBarView];
    [self.searchBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self.mas_top).offset(NVGBARHEIGHT + STATUSBARHEIGHT);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 0.0462));
    }];
    [self layoutIfNeeded];
    self.searchBarView.searchFieldBackgroundView.layer.cornerRadius = self.searchBarView.searchFieldBackgroundView.height * 0.5;
    
    //邮问知识库
    if (self.isHaveQAKnowledge) {
        [self addSubview:self.knowledgeView];
        [self.knowledgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchBarView.mas_bottom).offset(MAIN_SCREEN_H * 0.0449);
            make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.0426);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.8506, [self.knowledgeView ViewHeight]));
        }];
//        self.knowledgeView.frame = CGRectMake(MAIN_SCREEN_W * 0.0426, self.searchBarView.maxY + MAIN_SCREEN_H * 0.0449, MAIN_SCREEN_W * 0.8506, [self.knowledgeView ViewHeight]);
        
        //底部的分割线
        [self addSubview:self.topSeparation];
        [self.topSeparation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.knowledgeView.mas_bottom);
            make.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        }];
//        self.topSeparation.frame = CGRectMake(0, self.knowledgeView.maxY, SCREEN_WIDTH, 1);
        
        //segementBarView
        [self addSubview:self.segementBarView];
        [self.segementBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topSeparation.mas_bottom);
            make.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, self.segementBarView.viewHeight));
        }];
//        self.segementBarView.frame = CGRectMake(0, self.topSeparation.maxY + 17, SCREEN_WIDTH, _segementBarView.viewHeight);
    }else{
        [self addSubview:self.segementBarView];
        [self.segementBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchBarView.mas_bottom).offset(17);
            make.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, self.segementBarView.viewHeight));
        }];
//        self.segementBarView.frame = CGRectMake(0, self.searchBarView.maxY + 17, SCREEN_WIDTH, _segementBarView.viewHeight);
    }
   
}

- (void)updateHotSearchViewFrame{
    [self.knowledgeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBarView.mas_bottom).offset(MAIN_SCREEN_H * 0.0449);
        make.left.equalTo(self.mas_left).offset(MAIN_SCREEN_W * 0.0426);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.8506, [self.knowledgeView ViewHeight]));
    }];
//
//    self.knowledgeView.height = [self.knowledgeView ViewHeight];
//    self.topSeparation.frame =  self.topSeparation.frame = CGRectMake(0, self.knowledgeView.maxY, SCREEN_WIDTH, 1);
//    self.segementBarView.frame = CGRectMake(0, self.topSeparation.maxY + 17, SCREEN_WIDTH, _segementBarView.viewHeight);
}

#pragma mark- getter
- (SearchTopView *)searchBarView{
    if (!_searchBarView) {
        _searchBarView = [[SearchTopView alloc] init];
        _searchBarView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        _searchBarView.searchFieldBackgroundView.image = nil;
        _searchBarView.searchFieldBackgroundView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E8F0FC" alpha:1] darkColor:[UIColor colorWithHexString:@"#484848" alpha:1]];;
    }
    return _searchBarView;
}

- (SZHHotSearchView *)knowledgeView{
    if (!_knowledgeView) {
        _knowledgeView = [[SZHHotSearchView alloc] initWithString:@"邮问知识库"];
        _knowledgeView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
    }
    return _knowledgeView;
}

- (UIView *)topSeparation{
    if (_topSeparation == nil) {
        _topSeparation = [[UIView alloc] initWithFrame:CGRectZero];
        _topSeparation.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E2E8EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#252525" alpha:1]];
    }
    return _topSeparation;
}

- (SegmentBarView *)segementBarView{
    if (!_segementBarView) {
        _segementBarView = [[SegmentBarView alloc] initWithFrame:CGRectZero AndTextAry:self.segementBtnTextAry];
        
    }
    return _segementBarView;
}

- (CGFloat)maxOffsetHeight{
    _maxOffsetHeight = self.isHaveQAKnowledge ? (NVGBARHEIGHT+STATUSBARHEIGHT)  + MAIN_SCREEN_H * 0.0449 + [self.knowledgeView ViewHeight] + 17 : NVGBARHEIGHT+STATUSBARHEIGHT;
    return _maxOffsetHeight;
}

- (CGFloat)viewHeight{
    _viewHeight = self.maxOffsetHeight + 17 + self.searchBarView.height;
    return _viewHeight;
}

@end
