//
//  RisingCycleSingleLabelView.m
//  ByteDanceCampus_Klotski
//
//  Created by SSR on 2022/8/1.
//

#import "RisingCycleSingleLabelView.h"

#pragma mark - RisingCycleSingleLabelView ()

@interface RisingCycleSingleLabelView ()

/// 第二个Label
@property (nonatomic, strong) __kindof UILabel *secontLab;

/// timer
@property (nonatomic, strong) NSTimer *timer;

@end

#pragma mark - RisingCycleSingleLabelView

@implementation RisingCycleSingleLabelView

- (instancetype)init {
    self = [super init];
    if (self) {
        _scrollDirection = UIAccessibilityScrollDirectionLeft;
        _timeForSigleCycle = 2;
        _timeForSpeedScheduled = 0.025;
        _contentForPertime = 0.5;
        self.clipsToBounds = YES;
    }
    return self;
}

- (instancetype)initWithLabel:(UILabel *)label contentWidth:(CGFloat)width {
    self = [super init];
    if (self) {
        _scrollDirection = UIAccessibilityScrollDirectionLeft;
        _timeForSigleCycle = 2;
        _timeForSpeedScheduled = 0.025;
        _contentForPertime = 0.5;
        self.label = label;
        super.width = width;
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - Method

- (void)begin {
    [self timer];
}

- (void)cancel {
    if (_timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)scroll {
    switch (self.scrollDirection) {
        case UIAccessibilityScrollDirectionRight: {
            _label.x += self.contentForPertime;
            self.secontLab.x += self.contentForPertime;
            if (_label.x >= self.width) {
                [self exchange];
            }
        } break;
        case UIAccessibilityScrollDirectionUp: {
            _label.y -= self.contentForPertime;
            self.secontLab.y -= self.contentForPertime;
            if (_label.bottom <= 0) {
                [self exchange];
            }
        } break;
        case UIAccessibilityScrollDirectionDown: {
            _label.y += self.contentForPertime;
            self.secontLab.y += self.contentForPertime;
            if (self.secontLab.bottom >= self.height) {
                [self exchange];
            }
        } break;
        case UIAccessibilityScrollDirectionLeft:
        case UIAccessibilityScrollDirectionNext:
        case UIAccessibilityScrollDirectionPrevious: {
            _label.x -= self.contentForPertime;
            self.secontLab.x -= self.contentForPertime;
            if (_label.right <= 0) {
                [self exchange];
            }
        } break;
    }
}

- (void)exchange {
    UILabel *tLab = _label;
    _label = self.secontLab;
    self.secontLab = tLab;
    [self resetLayout];
    [self cancel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeForSigleCycle * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self timer];
    });
}

- (void)resetLayout {
    switch (_scrollDirection) {
        case UIAccessibilityScrollDirectionRight: {
            self.secontLab.origin = CGPointMake(-_label.width, 0);
        } break;
        case UIAccessibilityScrollDirectionUp: {
            self.secontLab.origin = CGPointMake(0, _label.bottom);
        } break;
        case UIAccessibilityScrollDirectionDown: {
            self.secontLab.origin = CGPointMake(0, -_label.height);
        } break;
        case UIAccessibilityScrollDirectionLeft:
        case UIAccessibilityScrollDirectionNext:
        case UIAccessibilityScrollDirectionPrevious: {
            self.secontLab.origin = CGPointMake(_label.right, 0);
        } break;
    }
}

#pragma mark - Setter

- (void)setLabel:(UILabel *)label {
    [_label removeFromSuperview];
    [self.secontLab removeFromSuperview];
    NSParameterAssert(label);
    
    _label = label;
    super.frame = _label.frame;
    _label.origin = CGPointMake(0, 0);
    self.secontLab = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:label]];

    
    _label.origin = CGPointMake(0, 0);
    
    [self resetLayout];
    
    [self addSubview:_label];
    [self addSubview:self.secontLab];
}

- (void)setScrollDirection:(UIAccessibilityScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    [self resetLayout];
}

- (void)setFrame:(CGRect)frame {
    NSAssert(NO, @"请使用lable去确定真正的frame");
    super.frame = frame;
}

#pragma mark - Getter

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeForSpeedScheduled target:[YYWeakProxy proxyWithTarget:self] selector:@selector(scroll) userInfo:nil repeats:YES];
    }
    return _timer;
}

@end
