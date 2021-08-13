//
//  DiscoverTodoSelectTimeView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoSelectTimeView.h"


@interface DiscoverTodoSelectTimeView ()

/// 日期选择器
@property(nonatomic, strong)UIDatePicker* datePicker;
@end

@implementation DiscoverTodoSelectTimeView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addDatePicker];
        [self layoutTipView];
        
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
//MARK: - 初始化UI
/// 添加日期选择器
- (void)addDatePicker {
    UIDatePicker* datePicker = [[UIDatePicker alloc] init];
    self.datePicker = datePicker;
    [self addSubview:datePicker];
    
    //本地化设置为中国，24小时制，
    //更多Identifier，参考https://blog.csdn.net/xiaozhu54321/article/details/48196301
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CHT"];
    
    //最少十分钟后
    NSDate *date = [NSDate dateWithTimeInterval:600 sinceDate:NSDate.now];
    [datePicker setDate:date];
    [datePicker setMinimumDate:date];
    //设置成滑轮样式
    datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    //设置成本地时区（应该是亚洲/上海）
    datePicker.timeZone = NSTimeZone.localTimeZone;
    
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(0.039408867*SCREEN_HEIGHT);
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
    [datePicker addTarget:self action:@selector(touchDatePicker:) forControlEvents:(UIControlEventValueChanged)];
}
//为紫色的tipView布局
- (void)layoutTipView {
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.datePicker);
        make.right.equalTo(self.datePicker.mas_left);
    }];
}

//MARK: - 响应事件
//滚动datePicker时调用
- (void)touchDatePicker:(UIDatePicker*)datePicker {
    NSDateComponents* components = [[NSCalendar currentCalendar] components:252 fromDate:datePicker.date];
    components.timeZone = NSTimeZone.localTimeZone;
    CCLog(@"%@",components);
}
/// 下方的取消按钮点击后调用
- (void)cancelBtnClicked {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/// 下方的确定按钮点击后调用
- (void)sureBtnClicked {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
