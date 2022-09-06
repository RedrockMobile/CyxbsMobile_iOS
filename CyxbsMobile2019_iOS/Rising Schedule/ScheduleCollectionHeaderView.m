//
//  ScheduleCollectionHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/6.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCollectionHeaderView.h"

NSString * ScheduleCollectionHeaderViewReuseIdentifier = @"ScheduleCollectionHeaderView";

// !!!: Inner Class Begin

#pragma mark - ScheduleCollectionHeaderViewSigleView

@interface ScheduleCollectionHeaderViewSigleView : UIView

/// 标题
@property (nonatomic, strong) UILabel *titleLab;

/// 日期
@property (nonatomic, strong) UILabel *contentLab;

/// 是否只展示标题
@property (nonatomic) BOOL onlyShowTitle;

/// 是否高亮
@property (nonatomic) BOOL isCurrent;

/// 设置标题和日期
/// 必须先掉用sizeToFit保证能显示
/// 如果不设置日期
/// @param title 标题
/// @param content 日期
- (void)setTitle:(NSString *)title content:(NSString * _Nullable)content;

@end

#pragma mark - ScheduleCollectionHeaderViewSigleView

@implementation ScheduleCollectionHeaderViewSigleView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        [self addSubview:self.titleLab];
        [self addSubview:self.contentLab];
    }
    return self;
}

#pragma mark - Method

- (void)sizeToFit {
    self.titleLab.width = self.width;
    if (self.onlyShowTitle) {
        self.titleLab.centerY = self.height / 2;
    } else {
        self.titleLab.top = 6;
    }
    
    self.contentLab.width = self.titleLab.width;
    self.contentLab.bottom = self.SuperBottom - 3;
}

- (void)setTitle:(NSString *)title content:(NSString *)content {
    self.titleLab.text = title;
    self.onlyShowTitle = (!content || [content isEqualToString:@""]);
    self.contentLab.text = content;
    self.contentLab.alpha = self.onlyShowTitle ? 0 : 1;
}

#pragma mark - Getter

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, -2, -1, 20)];
        _titleLab.backgroundColor = UIColor.clearColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont fontWithName:PingFangSC size:12];
        _titleLab.textColor =
        [UIColor dm_colorWithLightColor:UIColorHex(#15315B)
                              darkColor:UIColorHex(#F0F0F2)];
    }
    return _titleLab;
}

- (UILabel *)contentLab {
    if (_contentLab == nil) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.left, -1, -1, 20)];
        _contentLab.backgroundColor = UIColor.clearColor;
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = [UIFont fontWithName:PingFangSC size:11];
        _contentLab.textColor =
        [UIColor dm_colorWithLightColor:UIColorHex(#606E8A)
                              darkColor:UIColorHex(#868686)];
    }
    return _contentLab;
}

@end

// !!!: Inner Class End



#pragma mark - ScheduleCollectionHeaderView ()

@interface ScheduleCollectionHeaderView ()

/// 视图
@property (nonatomic, strong) NSArray <ScheduleCollectionHeaderViewSigleView *> *views;

/// 下标
@property (nonatomic, strong) UICollectionViewLayoutAttributes *attributes;

@end

@implementation ScheduleCollectionHeaderView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.redColor;
        self.layer.zPosition = 1;
        
        NSMutableArray <ScheduleCollectionHeaderViewSigleView *> *array = NSMutableArray.array;
        for (NSInteger i = 0; i <= 7; i++) {
            ScheduleCollectionHeaderViewSigleView *view = [[ScheduleCollectionHeaderViewSigleView alloc] init];
            [array addObject:view];
            [self addSubview:view];
        }
        self.views = array.copy;
    }
    return self;
}

- (void)sizeToFit {
    self.views[0].frame = CGRectMake(0, 0, self.widthForLeadingView, _attributes.frame.size.height);
    [self.views[0] sizeToFit];
    
    CGFloat width = (self.width - self.widthForLeadingView) / 7 - self.columnSpacing;
    
    for (NSInteger i = 1; i <= 7; i++) {
        self.views[i].frame = CGRectMake(self.views[i - 1].right + self.columnSpacing, 0, width, _attributes.frame.size.height);
        [self.views[i] sizeToFit];
    }
}

#pragma mark - Method

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    _attributes = layoutAttributes;
    
    [self.views[0] setTitle:@"学期" content:nil];
    
    for (NSInteger i = 1; i <= 7; i++) {
        
        NSString *title = [NSString stringWithFormat:@"周%@",
                           (i == 7 ? @"日"
                           : [NSString translation:(@(i).stringValue)])];
        [self.views[i] setTitle:title content:nil];
    }
}

#pragma mark - Setter

- (void)setDelegate:(id<ScheduleCollectionHeaderViewDataSource>)delegate {
    _delegate = delegate;
    
    if (delegate) {
        BOOL needSource = [delegate scheduleCollectionHeaderView:self needSourceInSection: _attributes.indexPath.section];
        if (needSource) {
            [self.views[0] setTitle:[delegate scheduleCollectionHeaderView:self leadingTitleInSection:_attributes.indexPath.section] content:nil];
            for (NSInteger i = 1; i <= 7; i++) {
                [self.views[i] setTitle:self.views[i].titleLab.text content:[delegate scheduleCollectionHeaderView:self contentDateAtIndexPath:[NSIndexPath indexPathForItem:i inSection:_attributes.indexPath.section]]];
            }
        }
    }
}

@end
