//
//  DiscoverTodoSelectRepeatView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoSelectRepeatView.h"
/// 当前的重复提醒类型的枚举
typedef enum : NSUInteger {
    DiscoverTodoSelectRepeatTypeDay,
    DiscoverTodoSelectRepeatTypeWeek,
    DiscoverTodoSelectRepeatTypeMonth,
    DiscoverTodoSelectRepeatTypeYear
} DiscoverTodoSelectRepeatType;

@interface DiscoverTodoSelectRepeatView() <
    UIPickerViewDelegate,
    UIPickerViewDataSource
>

/// 数据选择器
@property(nonatomic, strong)UIPickerView* pickerView;

/// 当前的重复类型
@property(nonatomic, assign)DiscoverTodoSelectRepeatType currentType;

/// 第二列选择的数据，重复类型为每年时，代表选择的月份，0代表1月；重复类型为每月时，代表选择的日，0代表1日；
/// 重复类型为每周时，代表选择的周几，0代表周日，1代表周一。
@property(nonatomic, assign)int com2Selected;

/// 第三列选择的数据，重复类型为每年时，代表选择的日，0代表1日。
@property(nonatomic, assign)int com3Selected;

/// 周数按钮
@property (nonatomic, copy)NSArray* week;

/// 月份最大值的数组
@property (nonatomic, copy)NSArray <NSNumber*>* days;

/// 加号按钮
@property (nonatomic, strong)UIButton* addBtn;

@end

@implementation DiscoverTodoSelectRepeatView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addPickerView];
        self.week = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
//        NSArray* month = @[@""]
//        NSArray* rowCntFowYear = @[@12, @31];
        self.days = @[
            @31, @29, @31,
            @30, @31, @30,
            @31, @31, @30,
            @31, @30, @31
        ];
        [self layoutTipView];
        [self addAddBtn];
        
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//MARK: - 初始化UI：
- (void)addPickerView {
    UIPickerView* pickerView = [[UIPickerView alloc] init];
    self.pickerView = pickerView;
    [self addSubview:pickerView];
    
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(0.039408867*SCREEN_HEIGHT);
        make.bottom.equalTo(self).offset(-0.1477832512*SCREEN_HEIGHT);
    }];
}
- (void)layoutTipView {
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pickerView);
        make.right.equalTo(self.pickerView.mas_left);
    }];
}
- (void)addAddBtn {
    UIButton* btn = [[UIButton alloc] init];
    self.addBtn = btn;
    [self addSubview:btn];
    
    [btn setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pickerView.mas_right);
        make.centerY.equalTo(self.pickerView);
        make.width.height.mas_equalTo(0.048*SCREEN_WIDTH);
    }];
}

//MARK: - pickerView的代理方法：
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return @[@"每天", @"每周", @"每月", @"每年"][row];
            break;
        case 1:
            if (self.currentType==DiscoverTodoSelectRepeatTypeWeek) {
                return @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"][row];
            }
        default:
            break;
    }
    
    return [@(row+1) stringValue];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.currentType) {
        case DiscoverTodoSelectRepeatTypeDay:
            return 1;
            break;
        case DiscoverTodoSelectRepeatTypeWeek:
            return 2;
            break;
        case DiscoverTodoSelectRepeatTypeMonth:
            return 2;
            break;
        case DiscoverTodoSelectRepeatTypeYear:
            return 3;
            break;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component==0) {
        return 4;
    }
    switch (self.currentType) {
        case DiscoverTodoSelectRepeatTypeDay:
            return 4;
            break;
        case DiscoverTodoSelectRepeatTypeWeek:
            return 7;
            break;
        case DiscoverTodoSelectRepeatTypeMonth:
            return 31;
            break;
        case DiscoverTodoSelectRepeatTypeYear:
            if (component==1) {
                return 12;
            }else {
                return [self.days[self.com2Selected] intValue];
            }
            break;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.currentType = (int)row;
            //①
            [self resetDateSelected];
            break;
        case 1:
            self.com2Selected = (int)row;
        default:
            self.com3Selected = (int)row;
            break;
    }
    [self.pickerView reloadAllComponents];
    //②
    if (component==0) {
        NSInteger cnt = [self numberOfComponentsInPickerView:self.pickerView];
        for (int i=1; i<cnt; i++) {
            [pickerView selectRow:0 inComponent:i animated:YES];
        }
    }
    //上面的①+②的代码，可以确保一写bug不发生，bug的出现方式：
    //每月选择一个大于7的日期，然后模式换成每周，这时候显示的时间和实际的不符。
    //每月选择一个大于12的日期，然后模式换成每年，就会崩溃
}

//MARK: - 点击按钮后调用
- (void)cancelBtnClicked {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)sureBtnClicked {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)addBtnClicked {
        
}

//MARK: - 其他
//把已选择的日期重置
- (void)resetDateSelected {
    self.com3Selected =
    self.com2Selected = 0;
}
@end
