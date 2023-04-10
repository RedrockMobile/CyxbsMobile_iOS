//
//  DiscoverTodoSelectTimeView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoSelectTimeView.h"
#import "YearBtnsView.h"

@interface DiscoverTodoSelectTimeView ()<
    YearBtnsViewDelegate
>

/// 日期选择器
@property(nonatomic, strong)UIDatePicker* datePicker;
@property(nonatomic, strong)YearBtnsView* yearBtnsView;
@end

@implementation DiscoverTodoSelectTimeView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addDatePicker];
        [self addYearBtnsView];
        [self layoutTipView];
        
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
//MARK: - 初始化UI
- (void)addYearBtnsView {
    YearBtnsView* view = [[YearBtnsView alloc] init];
    self.yearBtnsView = view;
    [self addSubview:view];
    
    view.delegate = self;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0.0197044335*SCREEN_HEIGHT);
        make.left.equalTo(self).offset(0.04266666667*SCREEN_WIDTH);
        make.right.equalTo(self).offset(-0.04266666667*SCREEN_WIDTH);
        make.height.mas_equalTo(0.04926108374*SCREEN_HEIGHT);
    }];
}
/// 添加日期选择器
- (void)addDatePicker {
    UIDatePicker* datePicker = [[UIDatePicker alloc] init];
    self.datePicker = datePicker;
    [self addSubview:datePicker];
    
    //本地化设置为中国，24小时制，
    //更多Identifier，参考https://blog.csdn.net/xiaozhu54321/article/details/48196301
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CHT"];
    
    //最少十分钟后
    NSDate *date = [NSDate dateWithTimeInterval:60 sinceDate:[NSDate date]];
    [datePicker setDate:date];
    [datePicker setMinimumDate:date];
    
    //13.4之后设置成滑轮样式
    if (@available(iOS 13.4, *)) {
        datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    //设置成本地时区（应该是亚洲/上海）
    datePicker.timeZone = NSTimeZone.localTimeZone;
    
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(0.059408867*SCREEN_HEIGHT);
        make.bottom.equalTo(self).offset(-0.1477832512*SCREEN_HEIGHT);
    }];
    /*
        这里面的代码，可以text自定义颜色，但是用了私有API，有一定风险，不用了,
        可参考：https://blog.csdn.net/Lu_Ca/article/details/50204009
     
        [datePicker setValue:UIColor.redColor forKey:@"textColor"];
        SEL selector = NSSelectorFromString(@"setHighlightsToday:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
        BOOL no = NO;
        [invocation setSelector:selector];
        [invocation setArgument:&no atIndex:2];
        [invocation invokeWithTarget:datePicker];
     */
//    [datePicker addTarget:self action:@selector(touchDatePicker:) forControlEvents:(UIControlEventValueChanged)];
}
//为紫色的tipView布局
- (void)layoutTipView {
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.datePicker);
        make.right.equalTo(self.datePicker.mas_left);
    }];
}

/// 下方的取消按钮点击后调用
- (void)cancelBtnClicked {
    [self hideView];
    [self.delegate selectTimeViewCancelBtnClicked];
}

/// 下方的确定按钮点击后调用
- (void)sureBtnClicked {
    [self hideView];
    NSDateComponents* components = [[NSCalendar currentCalendar] components:252 fromDate:self.datePicker.date];
    components.timeZone = NSTimeZone.localTimeZone;
    [self.delegate selectTimeViewSureBtnClicked:components];
}

- (void)yearBtnsView:(YearBtnsView *)view didSelectedYear:(NSInteger)year {
    NSDate *minDate, *maxDate;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year+1;
    maxDate = [NSDate dateWithTimeInterval:-1 sinceDate:[[NSCalendar currentCalendar] dateFromComponents:components]];
    if ([[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]]==year) {
        minDate = [NSDate dateWithTimeInterval:60 sinceDate:[NSDate date]];
    }else {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.year = year;
        minDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    }
    
    [self.datePicker setMinimumDate:minDate];
    [self.datePicker setMaximumDate:maxDate];
}


/// 外界调用，调用后显示出来
- (void)showView {
    CCLog(@"%d, %.2f", self.isViewHided, self.alpha);
    if (self.isViewHided==YES) {
        self.isViewHided = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        }];
    }
}

/// 调用后效果如同点击取消按钮，但是不会调用代理方法
- (void)hideView {
    if (self.isViewHided==NO) {
        self.isViewHided = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        }];
    }
}

@end
