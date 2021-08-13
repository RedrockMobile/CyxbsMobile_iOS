//
//  DiscoverTodoSelectTimeView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoSelectTimeView.h"
#import <objc/runtime.h>

@interface DiscoverTodoSelectTimeView ()
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
- (void)addDatePicker {
    UIDatePicker* datePicker = [[UIDatePicker alloc] init];
    self.datePicker = datePicker;
    [self addSubview:datePicker];
    
    //本地化设置为中国，24小时制
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CHT"];
    
    [datePicker setDate:[NSDate dateWithTimeInterval:86000 sinceDate:NSDate.now]];
    [datePicker setMinimumDate:[NSDate now]];
    datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    datePicker.timeZone = NSTimeZone.localTimeZone;
    
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(0.216*SCREEN_WIDTH);
//        make.right.equalTo(self).offset(-0.1466666667*SCREEN_WIDTH);
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(0.039408867*SCREEN_HEIGHT);
        make.bottom.equalTo(self).offset(-0.1477832512*SCREEN_HEIGHT);
    }];
    /*
    这里面的代码，可以text自定义颜色，但是用了私有API，有一定风险，不用了
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
- (void)layoutTipView {
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.datePicker);
        make.right.equalTo(self.datePicker.mas_left);
    }];
}
- (void)touchDatePicker:(UIDatePicker*)datePicker {
    NSDateComponents* components = [[NSCalendar currentCalendar] components:252 fromDate:datePicker.date];
    components.timeZone = NSTimeZone.localTimeZone;
    CCLog(@"%@",components);
}

- (void)cancelBtnClicked {
    
}

- (void)sureBtnClicked {
    
}
@end
