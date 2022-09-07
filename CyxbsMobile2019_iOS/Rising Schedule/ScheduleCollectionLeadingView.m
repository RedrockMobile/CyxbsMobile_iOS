//
//  ScheduleCollectionLeadingView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/6.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCollectionLeadingView.h"

NSString *ScheduleCollectionLeadingViewReuseIdentifier = @"ScheduleCollectionLeadingView";

@interface ScheduleCollectionLeadingViewSigleView : UIView

/// 时间
@property (nonatomic, strong) UILabel *timeLab;

@end

@implementation ScheduleCollectionLeadingViewSigleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.timeLab];
    }
    return self;
}

- (void)sizeToFit {
    self.timeLab.width = self.width;
    self.timeLab.center = self.SuperCenter;
}

#pragma mark - Getter

- (UILabel *)timeLab {
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, -1, 5, 17)];
        _timeLab.backgroundColor = UIColor.clearColor;
        _timeLab.font = [UIFont fontWithName:PingFangSC size:12];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.textColor =
        [UIColor dm_colorWithLightColor:UIColorHex(#112C54)
                              darkColor:UIColorHex(#F0F0F2)];
    }
    return _timeLab;
}

@end







#pragma mark - ScheduleCollectionLeadingView ()

@interface ScheduleCollectionLeadingView ()

/// 布局
@property (nonatomic, strong) UICollectionViewLayoutAttributes *attributes;

/// 视图
@property (nonatomic, strong) NSArray <ScheduleCollectionLeadingViewSigleView *> *views;

@end

#pragma mark - ScheduleCollectionLeadingView

@implementation ScheduleCollectionLeadingView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        
        NSMutableArray <ScheduleCollectionLeadingViewSigleView *> *array = NSMutableArray.array;
        for (NSInteger i = 1; i <= 12; i++) {
            ScheduleCollectionLeadingViewSigleView *view = [[ScheduleCollectionLeadingViewSigleView alloc] init];
            view.timeLab.text = @(i).stringValue;
            
            [array addObject:view];
            [self addSubview:view];
        }
        self.views = array.copy;
    }
    return self;
}

- (void)sizeToFit {
    CGFloat height = _attributes.frame.size.height / 12 - self.lineSpacing;
    
    self.views[0].frame = CGRectMake(0, 0, _attributes.frame.size.width, height);
    [self.views[0] sizeToFit];
    
    for (NSInteger i = 1; i < 12; i++) {
        self.views[i].frame = CGRectMake(0, self.views[i - 1].bottom + self.lineSpacing, _attributes.frame.size.width, height);
        [self.views[i] sizeToFit];
    }
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.attributes = layoutAttributes;
}

@end
