//
//  DiscoverTodoSelectRepeatView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoSelectRepeatView.h"



@interface DiscoverTodoSelectRepeatView() <
    UIPickerViewDelegate,
    UIPickerViewDataSource,
    DLTimeSelectedButtonDelegate
>

/// 数据选择器
@property(nonatomic, strong)UIPickerView* pickerView;

/// 周数按钮
@property (nonatomic, copy)NSArray* week;

/// 月份最大值的数组
@property (nonatomic, copy)NSArray <NSNumber*>* days;

/// 加号按钮
@property (nonatomic, strong)UIButton* addBtn;

@property (nonatomic, strong)UIScrollView* scrollView;

@property (nonatomic, strong)UIView* scrContenView;




/// selectedCntOfcom[0]：当前的重复类型
/// selectedCntOfcom[1]：
/// 第二列选择的数据，重复类型为每年时，代表选择的月份，0代表1月；重复类型为每月时，代表选择的日，0代表1日；
/// 重复类型为每周时，代表选择的周几，0代表周日，1代表周一。
/// selectedCntOfcom[2]：
/// 第三列选择的数据，重复类型为每年时，代表选择的日，0代表1日。
@property (nonatomic, assign)NSInteger* selectedCntOfcom;

@property (nonatomic, assign)NSInteger increseCnt;
@end

@implementation DiscoverTodoSelectRepeatView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.btnArr = [NSMutableArray arrayWithCapacity:4];
        self.dateArr = [NSMutableArray arrayWithCapacity:4];
        self.repeatMode = TodoDataModelRepeatModeNO;
        self.week = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
        self.days = @[
            @31, @29, @31,
            @30, @31, @30,
            @31, @31, @30,
            @31, @30, @31
        ];
        self.selectedCntOfcom = calloc(3, sizeof(NSInteger));
        self.alpha = 0;
        [self addPickerView];
        [self layoutTipView];
        [self addAddBtn];
        [self addScrollView];
        
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
- (void)addScrollView {
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.backgroundColor = [UIColor lightGrayColor];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(0.01724137931*SCREEN_HEIGHT);
        make.height.mas_equalTo(0.04433497537*SCREEN_HEIGHT);
    }];
    
    
    UIView* scrContenView = [[UIView alloc] init];
    self.scrContenView = scrContenView;
    [scrollView addSubview:scrContenView];
    
    
    [scrContenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
    }];
}
//MARK: - pickerView的代理方法：
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return @[@"每天", @"每周", @"每月", @"每年"][row];
            break;
        case 1:
            if (self.selectedCntOfcom[0]==1) {
                return self.week[row];
            }
        default:
            return [@(row+1) stringValue];
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.selectedCntOfcom[0] > 1) {
        return self.selectedCntOfcom[0];
    }else {
        return self.selectedCntOfcom[0] + 1;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component==0) {
        return 4;
    }
    switch (self.selectedCntOfcom[0]) {
        case 0:
            return 4;
            break;
        case 1:
            return 7;
            break;
        case 2:
            return 31;
            break;
        case 3:
            if (component==1) {
                return 12;
            }else {
                return [self.days[self.selectedCntOfcom[1]] intValue];
            }
            break;
        default:
            return 0;
            break;
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component==0&&self.btnArr.count!=0&&row!=self.selectedCntOfcom[component]) {
        [pickerView selectRow:self.selectedCntOfcom[component] inComponent:0 animated:YES];
        return;
    }
    self.selectedCntOfcom[component] = row;
    [self resetData];
}
- (void)resetData {
    NSInteger componentCnt = [self numberOfComponentsInPickerView:self.pickerView];
    NSInteger rowCnt;
    for (int i=0; i<componentCnt; i++) {
        rowCnt = [self pickerView:self.pickerView numberOfRowsInComponent:i];
        if (self.selectedCntOfcom[i] >= rowCnt) {
            self.selectedCntOfcom[i] = rowCnt-1;
        }
    }
    
    [self.pickerView reloadAllComponents];
    
    for (int i=0; i<componentCnt; i++) {
        [self.pickerView selectRow:self.selectedCntOfcom[i] inComponent:i animated:YES];
    }
}
//MARK: - 点击按钮后调用
- (void)cancelBtnClicked {
    [UIView animateWithDuration:0.3 animations:^{
        self.addBtn.alpha =
        self.tipView.alpha =
        self.pickerView.alpha =
        self.sureBtn.alpha =
        self.cancelBtn.alpha =
        self.separatorLine.alpha = 0;
    }];
    for (NSInteger i=0; i<_increseCnt; i++) {
        [[self.btnArr popLastObject] removeFromSuperview];
        [self.dateArr removeLastObject];
    }
    [self reLayoutAllBtn];
    [self.delegate selectRepeatViewCancelBtnClicked];
}
- (void)sureBtnClicked {
    [UIView animateWithDuration:0.3 animations:^{
        self.addBtn.alpha =
        self.tipView.alpha =
        self.pickerView.alpha =
        self.sureBtn.alpha =
        self.cancelBtn.alpha =
        self.separatorLine.alpha = 0;
    }];
    [self.delegate selectRepeatViewSureBtnClicked:self];
}

//从[1, 2, ... 7]转化为[2, 3, ... 1]
static inline int ChinaWeekToForeignWeek(int week) {
    return week%7+1;
}
//从[2, 3, ... 1]转化为[1, 2, ... 7]
static inline int ForeignWeekToChinaWeek(int week) {
    return (week+5)%7+1;
}

- (void)addBtnClicked {
    NSString* titleStr;
    switch (self.selectedCntOfcom[0]) {
        case 0:
            if (self.btnArr.count) {
                return;
            }
            self.repeatMode = TodoDataModelRepeatModeDay;
            titleStr = @"每天";
            break;
        case 1: {
            NSString* dateStr = [NSString stringWithFormat:@"%d", ForeignWeekToChinaWeek((int)self.selectedCntOfcom[1]+1)];
            if ([self.dateArr containsObject:dateStr]) {
                return;
            }
            [self.dateArr addObject: dateStr];
            self.repeatMode = TodoDataModelRepeatModeWeek;
            titleStr = self.week[self.selectedCntOfcom[1]];
            break;
        }
        case 2: {
            NSString* dateStr = [NSString stringWithFormat:@"%ld",self.selectedCntOfcom[1]+1];
            if ([self.dateArr containsObject:dateStr]) {
                return;
            }
            [self.dateArr addObject:dateStr];
            self.repeatMode = TodoDataModelRepeatModeMonth;
            titleStr = [NSString stringWithFormat:@"每月%ld日",self.selectedCntOfcom[1]+1];
            break;
        }
        case 3: {
            NSDictionary* dateDict = @{
                TodoDataModelKeyMonth:[NSString stringWithFormat:@"%ld",self.selectedCntOfcom[1]+1],
                TodoDataModelKeyDay:[NSString stringWithFormat:@"%ld",self.selectedCntOfcom[2]+1]
            };
            if ([self.dateArr containsObject:dateDict]) {
                return;
            }
            [self.dateArr addObject:dateDict];
            self.repeatMode = TodoDataModelRepeatModeYear;
            titleStr = [NSString stringWithFormat:@"每年%ld月%ld日",self.selectedCntOfcom[1]+1, self.selectedCntOfcom[2]+1];
            break;
        }
    }
    
    DLTimeSelectedButton* btn = [[DLTimeSelectedButton alloc] init];
    [self.btnArr addObject:btn];
    [self.scrContenView addSubview:btn];
    
    [btn setTitle:titleStr forState:UIControlStateNormal];
    btn.delegate = self;
    
    //有待性能优化
    [self reLayoutAllBtn];
    
    //调整scrollView的显示位置
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat x = self.scrollView.contentSize.width-SCREEN_WIDTH;
        if (x>60) {
            [UIView animateWithDuration:0.6 animations:^{
                self.scrollView.contentOffset = CGPointMake(x+4, 0);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.scrollView.contentOffset = CGPointMake(x, 0);
                }];
            }];
        }
    });
    self.increseCnt++;
}

- (void)reLayoutAllBtn {
    MASViewAttribute* last = self.scrContenView.mas_left;
    for (UIButton* btn in self.btnArr) {
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.04433497537*SCREEN_HEIGHT);
            make.top.bottom.equalTo(self.scrContenView);
            make.left.equalTo(last).offset(0.03733333333*SCREEN_WIDTH);
        }];
        last = btn.mas_right;
    }
    if (self.btnArr.count==0) {
        return;
    }
    [[self.btnArr lastObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrContenView).offset(-0.03733333333*SCREEN_WIDTH);
    }];
}

- (void)deleteButtonWithBtn:(DLTimeSelectedButton*)btn {
    //有待性能优化
    [btn removeFromSuperview];
    //避免在每天重复的情况下，出问题
    if (self.dateArr.count) {
        [self.dateArr removeObjectAtIndex:[self.btnArr indexOfObject:btn]];
    }
    [self.btnArr removeObject:btn];
    [self reLayoutAllBtn];
    self.increseCnt--;
}

- (void)dealloc {
    free(self.selectedCntOfcom);
    self.selectedCntOfcom = nil;
}

/// 外界调用，调用后显示出来
- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        for (UIView* subView in self.subviews) {
            subView.alpha = 1;
        }
    }];
    self.increseCnt = 0;
}

/// 外界调用，调用把除了scrContenView、scrollView意外的所有view隐藏起来
@end

/*
 return;
 NSUInteger index = [self.btnArr indexOfObject:btn];
 if (index==0) {
     [btn mas_remakeConstraints:^(MASConstraintMaker *make) {}];
     [btn removeFromSuperview];
     
     if (self.btnArr.count!=1) {
         UIButton* rightBtn = self.btnArr[1];
         [rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.scrContenView).offset(0.03733333333*SCREEN_WIDTH);
         }];
     }
 }else if (index==self.btnArr.count-1) {
     [btn mas_remakeConstraints:^(MASConstraintMaker *make) {}];
     [btn removeFromSuperview];
     
     UIButton* leftBtn = self.btnArr[self.btnArr.count-2];
     [leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(self.scrContenView).offset(-0.03733333333*SCREEN_WIDTH);
     }];
 }else {
     [btn mas_remakeConstraints:^(MASConstraintMaker *make) {}];
     [btn removeFromSuperview];
     
     UIButton* leftBtn = self.btnArr[index-1];
     UIButton* rightBtn = self.btnArr[index+1];
     [leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(rightBtn.mas_left).offset(-0.03733333333*SCREEN_WIDTH);
     }];
     [rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(rightBtn.mas_right).offset(0.03733333333*SCREEN_WIDTH);
     }];
 }
 [self.btnArr removeObject:btn];
 */
