//
//  DLReminderSetTimeVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/10.
//  Copyright © 2020 Redrock. All rights reserved.
//
/*
 逻辑错误：
 1.
 */

#import "DLReminderSetTimeVC.h"
#import "DLReminderView.h"
#import "DLReminderView+Reset.h"
#import "DLWeeklSelectView.h"
#import "DLTimeSelectView.h"
#import "DLReminderModel.h"
#import "DLTimeSelectedButton.h"
#import "DLHistodyButton.h"

#define kRateX [UIScreen mainScreen].bounds.size.width/375   //以iPhoneX为基准
#define kRateY [UIScreen mainScreen].bounds.size.height/812  //以iPhoneX为基准
@interface DLReminderSetTimeVC ()<UITextFieldDelegate, WeekSelectDelegate, UIPickerViewDelegate, UIPickerViewDataSource, DLTimeSelectedButtonDelegate>
@property (nonatomic, strong) DLReminderView *reminderView;
@property (nonatomic, strong) DLWeeklSelectView *weekselectView;
@property (nonatomic, strong) DLTimeSelectView *timeSelectView;

@property (nonatomic, strong) NSMutableArray *pickerSlectedItems;//存储用户选择的时间，只有两个item，第一个是周几，第二个是那一个时间段
@property (nonatomic, copy) NSArray *weekArray;
@property (nonatomic, copy) NSArray *timeArrays;//pickerView选择数据
@property (nonatomic, strong) NSMutableArray *weekSelectedArray; //存储已选择的周
@property (nonatomic, strong) NSMutableArray *timeSelectedArray; //存储已选择的时间 内容为string
@property (nonatomic, strong) NSMutableArray *timeButtonTitleArray;  //存选择的时间按钮的标题 存的是NSString 不是button
@property (nonatomic, strong) NSString *selectedTimeString;//可能会变所以没用copy
@property (nonatomic, strong) NSMutableArray *timebuttonArray;
@end

@implementation DLReminderSetTimeVC

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.weekSelectedArray = [@[] mutableCopy];
    self.timeSelectedArray = [@[] mutableCopy];
    self.timebuttonArray = [@[] mutableCopy];
    self.pickerSlectedItems = [@[@"",@""] mutableCopy];
//    第一个是星期，第二个是周几，第三个是哪节课
    [self loadweekArray];
    [self loadTimeArrays];
    [self.view addSubview: self.reminderView];
    // Do any additional setup after loading the view.
}

#pragma mark - 点击事件
//点击下方的大勾勾按钮
- (void)didClickNextButton:(UIButton *)button{
//    那个idnum不知道是啥，随便写了个
    NSDictionary *dic = @{@"idNum": @123,
                          @"title": self.noticeString,//为你的行程添加标题时选择的标题
                          @"content": self.detailString//为你的行程添加内容时输入的文字
    };
    
    NSLog(@"notice = %@,detail = %@",self.noticeString,self.detailString);
    
    //DLReminderModel只在这里使用过
    DLReminderModel *model = [[DLReminderModel alloc] initWithRemindDict:dic];
    model.week = self.weekSelectedArray;
//    model.classNum、model.day、model.week还没有设置
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击周选择控件的紫色确定按钮后调用
- (void)didClickWeekSelectViewConfirmButton{
    [self.weekselectView removeFromSuperview];
    [self.view addSubview: self.timeSelectView];
    [self.timeSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(300*kRateY);
    }];
    [self.timeSelectView.timePiker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeSelectView.mas_left);
        make.bottom.equalTo(self.timeSelectView.mas_bottom);
        make.width.equalTo(self.timeSelectView.mas_width).mas_offset(-85);
        make.height.mas_equalTo(300*kRateY);
    }];
}
//点击选择周的加号后调用
- (void)didClickAddButton{
    [self.view addSubview: self.weekselectView];
    
}

//- (void)didClickSelectedButton:(UIButton *)button{
//
//}
//点时间选择器的加号后调用
- (void)didClickTimeSelectViewAddButton{
    NSString *str1 = self.pickerSlectedItems[0];
    NSString *str2 = self.pickerSlectedItems[1];
    if (![str1 isEqual: @""] && ![str2 isEqual: @""]) {
        [self.timeSelectView removeFromSuperview];
        self.selectedTimeString = [NSString stringWithFormat:@"%@ %@",self.pickerSlectedItems[0], self.pickerSlectedItems[1]];
        [self.timeSelectedArray removeObject: self.selectedTimeString];
        [self.timeSelectedArray addObject: self.selectedTimeString];
        [self loadSelectedButtons];
    }else if (![str1 isEqual: @""] || ![str2 isEqual: @""]){
        [self.timeSelectView removeFromSuperview];
        self.selectedTimeString = [NSString stringWithFormat:@"%@", [str1 isEqual: @""]?str2:str1];
        [self.timeSelectedArray removeObject: self.selectedTimeString];
        NSLog(@"timeSelectedArray1-------%@",self.timeSelectedArray);
        [self.timeSelectedArray addObject: self.selectedTimeString];
        NSLog(@"timeSelectedArray2-------%@",self.timeSelectedArray);
        [self loadSelectedButtons];
    }
    else{
        NSLog(@"未输入");
    }
}

#pragma mark - delegate
//点击“每单周”、“第一周”后调用
- (void)selectedWeekArrayAtIndex:(NSInteger)index{
    if (![self.weekSelectedArray containsObject: self.weekArray[index]]) {
        [self.weekSelectedArray addObject:self.weekArray[index]];
    }
//    self.pickerSlectedItems[0] = self.weekSelectedArray;
    NSLog(@"点击了第%ld个",(long)index);
}


- (void)deleteButtonWithTag:(NSInteger)tag{
    NSString *deletestr = self.timeButtonTitleArray[tag];
//需要使删除的日期在weekView上的button的选中状态设为normol
    [self.weekSelectedArray removeObject: deletestr];
    [self.timeSelectedArray removeObject: deletestr];
    [self loadSelectedButtons];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *array = self.timeArrays[component];
    return array.count;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *array = self.timeArrays[component];
    return array[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    self.pickerSlectedItems[component] = self.timeArrays[component][row];
    NSLog(@"%@ \n ---- %@",self.timeArrays[component][row],self.pickerSlectedItems);
}
//重写此方法自定义picker的外观
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    for(UIView *singleLine in pickerView.subviews)
//    {
//        if (singleLine.frame.size.height < 1)
//        {
//            singleLine.backgroundColor = [UIColor colorWithHexString:@"#E9EDF2"];
//        }
//    }
    UILabel* pickerLabel = (UILabel*)view;
        if (!pickerLabel){
            pickerLabel = [[UILabel alloc] init];
            pickerLabel.adjustsFontSizeToFitWidth = YES;
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            if (@available(iOS 11.0, *)) {
                pickerLabel.textColor = [UIColor colorNamed:@"titleLabelColor"];
            } else {
                 pickerLabel.textColor = [UIColor colorWithHexString:@"#15315B"];
                // Fallback on earlier versions
            }
            [pickerLabel setFont: [UIFont fontWithName:@".PingFang SC-Semibold" size: 16*kRateX]];
        }
        // Fill the label text here
        pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
        return pickerLabel;
}

#pragma mark - 懒加载&加载
- (DLReminderView *)reminderView{
    if (!_reminderView) {
        _reminderView = [[DLReminderView alloc] init];
        _reminderView.frame = self.view.frame;
        [_reminderView resetConstrains];
        [_reminderView loadAddButton];
        _reminderView.titleLab.text = _noticeString;
        _reminderView.textFiled.delegate = self;
        _reminderView.textFiled.text = _detailString;
        [_reminderView.addButton addTarget:self action:@selector(didClickAddButton) forControlEvents:UIControlEventTouchUpInside];
        [_reminderView.nextBtn addTarget:self action:@selector(didClickNextButton:) forControlEvents:UIControlEventTouchUpInside];
        _reminderView.nextBtn.tag = 1;
        [_reminderView.backBtn addTarget: self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reminderView;
}
- (void)loadweekArray{
    NSMutableArray *arr = [ @[@"整学期", @"每单周", @"每双周"] mutableCopy];
    for (int i = 1; i <= 20; i++) {
        [arr addObject: [NSString stringWithFormat:@"第%d周",i]];
    }
    _weekArray = [arr copy];
}

- (DLWeeklSelectView *)weekselectView{
    if (!_weekselectView) {
        _weekselectView = [[DLWeeklSelectView alloc] init];
        _weekselectView.frame = CGRectMake(0, SCREEN_HEIGHT-360*kRateY, SCREEN_WIDTH, 360*kRateY);
        _weekselectView.weekArray = _weekArray;
        _weekselectView.delegate = self;
        [_weekselectView.confirmBtn addTarget:self action:@selector(didClickWeekSelectViewConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weekselectView;
}

- (void)loadTimeArrays{
    self.timeArrays = @[@[@"",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日  "],@[@"",@"一二节课",@"三四节课",@"五六节课",@"七八节课",@"九十节课",@"十一十二节课"]];
}
- (DLTimeSelectView *)timeSelectView{
    if (!_timeSelectView) {
        _timeSelectView = [[DLTimeSelectView alloc] init];
        _timeSelectView.frame = CGRectMake(0, SCREEN_HEIGHT-300*kRateY, SCREEN_WIDTH, 300*kRateY);
        [_timeSelectView.addButton addTarget:self action:@selector(didClickTimeSelectViewAddButton) forControlEvents:UIControlEventTouchUpInside];
        _timeSelectView.timePiker.dataSource = self;
        _timeSelectView.timePiker.delegate = self;
        [_timeSelectView initTimePickerView];
    }
    return _timeSelectView;
}

- (void)loadSelectedButtons{
    for (UIButton *btn in self.timebuttonArray) {
        [btn removeFromSuperview];
    }
    self.timebuttonArray = [@[] mutableCopy];
    self.timeButtonTitleArray = [@[] mutableCopy];
    [self.timeButtonTitleArray addObjectsFromArray: self.weekSelectedArray];
    [self.timeButtonTitleArray addObjectsFromArray: self.timeSelectedArray];
//    [array insertObject:@"无提醒" atIndex:0];
    NSLog(@"%@",self.timeButtonTitleArray);
    CGFloat hasOccupiedWidth = 20 * kRateX;
    NSInteger j = 0;
    NSInteger count = self.timeButtonTitleArray.count;
    for (NSInteger i = 0; i < count; i++) {
        CGSize size = [self.timeButtonTitleArray[i] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@".PingFang SC-Semibold" size:15*kRateX]}];
        if (hasOccupiedWidth + size.width + 40*kRateX > SCREEN_WIDTH - 76*kRateX && j < 4) {
            j++;
            hasOccupiedWidth = 20*kRateX;
        }
        if (j >= 4) {
            NSLog(@"装不下了！！！！！");
            NSRange r = {i,count-i};
            [self.timeButtonTitleArray subarrayWithRange: r];
            break;
        }
        DLTimeSelectedButton *button = [[DLTimeSelectedButton alloc] init];
        [button setTitle:self.timeButtonTitleArray[i] forState:UIControlStateNormal];
        button.tag = i;
//            [button addTarget:self action:@selector(didClickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reminderView.textFiled.mas_bottom).mas_offset(10*kRateY + j*50*kRateY);
            make.left.equalTo(self.view.mas_left).mas_offset(hasOccupiedWidth + 10*kRateX);
            make.width.mas_equalTo(size.width + 40*kRateX);
            make.height.mas_equalTo(40*kRateX);
        }];
        [button initImageConstrains];
        button.delegate = self;
        [self.timebuttonArray addObject:button];
        hasOccupiedWidth += size.width + 50*kRateX;
    }
}

@end
