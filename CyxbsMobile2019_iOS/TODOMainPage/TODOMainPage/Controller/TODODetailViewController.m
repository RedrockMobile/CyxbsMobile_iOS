//
//  TODODetailViewController.m
//  ZY
//
//  Created by 欧紫浩 on 2021/8/11.
//

//Controllers
#import "TODODetailViewController.h"
//Models
#import "TODOModel.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//枚举
typedef enum : NSUInteger {
    DiscoverTodoSelectRepeatTypeDay,
    DiscoverTodoSelectRepeatTypeWeek,
    DiscoverTodoSelectRepeatTypeMonth,
    DiscoverTodoSelectRepeatTypeYear
} TodoSelectRepeatType;

@interface TODODetailViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate>
///详情页的提醒时间字样
@property (nonatomic,strong) UILabel *detailremindtime;
///详情页的设置重复字样
@property (nonatomic,strong) UILabel *detailrepeattime;
///详情页的备注字样
@property (nonatomic,strong) UILabel *detailremark;
///顺传事件
@property (nonatomic,strong) UITextField *detailtxt;
///右边保存
@property (nonatomic,strong) UIBarButtonItem *savebutton;
///详情时间选择
@property (nonatomic,strong) UIButton *detailtimeselect;
///白板View
@property (nonatomic,strong) UIView *whiteview;
///遮罩View
@property (nonatomic,strong) UIView *maskView;
///时间选择
@property (nonatomic,strong) UIDatePicker *datepicker;
///设置提醒时间
@property (nonatomic,strong) UILabel *detailremindtimelbl;
///选择时间取消
@property (nonatomic,strong) UIButton *detailcancelbtn;
///选择时间确定
@property (nonatomic,strong) UIButton *detailsurebtn;
///备注栏
@property (nonatomic,strong) UITextView *textview;
///重复时间按钮
@property (nonatomic,strong) UIButton *detailrepeatbtn;
///选择重复时间
@property (nonatomic,strong) UIPickerView *repeatpicker;
///选中的时间
@property (nonatomic,strong) NSDate *detailselectedtime;
///当前的重复类型
@property(nonatomic, assign)TodoSelectRepeatType currentType;
/// 第二列选择的数据，重复类型为每年时，代表选择的月份，0代表1月；重复类型为每月时，代表选择的日，0代表1日；
/// 重复类型为每周时，代表选择的周几，0代表周日，1代表周一。
@property(nonatomic, assign)int com2Selected;
/// 第三列选择的数据，重复类型为每年时，代表选择的日，0代表1日。
@property(nonatomic, assign)int com3Selected;
/// 周数按钮
@property (nonatomic, copy)NSArray* week;
/// 月份最大值的数组
@property (nonatomic, copy)NSArray <NSNumber*>* days;

@end

@implementation TODODetailViewController
#pragma mark -lifecircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.view addSubview:self.textview];
    
    [self.view addSubview:self.detailremindtime];
    
    UIButton *rightbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [rightbutton setTitleColor:[UIColor colorNamed:@"41,35,210,1"] forState:UIControlStateNormal];
    [rightbutton setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:rightbutton];
    
    _savebutton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(detailsave)];
    self.navigationItem.rightBarButtonItem = _savebutton;
    [_savebutton setTintColor:[UIColor colorNamed:@"41,35,210,1"]];
    
    _detailremindtime = [[UILabel alloc]init];
    _detailremindtime.frame = CGRectMake(SCREEN_WIDTH*0.13333, SCREEN_HEIGHT*0.22660, 75, 25);
    _detailremindtime.text = @"提醒时间";
    _detailremindtime.textColor = [UIColor colorNamed:@"21,49,91,1"];
    _detailremindtime.font = [UIFont fontWithName:@"PingFangSC-Noraml" size:18];
    [self.view addSubview:_detailremindtime];
    
    _detailrepeattime = [[UILabel alloc]init];
    _detailrepeattime.frame = CGRectMake(SCREEN_WIDTH*0.13333,SCREEN_HEIGHT*0.33620, 37, 25);
    _detailrepeattime.text = @"重复";
    _detailrepeattime.textColor = [UIColor colorNamed:@"21,49,91,1"];
    _detailrepeattime.font = [UIFont fontWithName:@"PingFangSC-Noraml" size:18];
    [self.view addSubview:_detailrepeattime];
   
    _detailremark = [[UILabel alloc]init];
    _detailremark.frame = CGRectMake(SCREEN_WIDTH*0.13333, SCREEN_HEIGHT*0.44581, 37, 25);
    _detailremark.text = @"备注";
    _detailremark.textColor = [UIColor colorNamed:@"21,49,91,1"];
    _detailremark.font = [UIFont fontWithName:@"PingFangSC-Noraml" size:18];
    [self.view addSubview:_detailremark];
    
    _detailtxt = [[UITextField alloc]initWithFrame:CGRectMake(50, 117, 161, 31)];
    _detailtxt.text = self.model.modeltodo_thing;
    [self.detailtxt addTarget:self action:@selector(jianting) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_detailtxt];
    
     _detailtimeselect = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.13333, SCREEN_HEIGHT*0.26970, 150, 25)];
   // _detailtimeselect.titleLabel.text = self.detailtimecontent;
    [_detailtimeselect setTitle:@"设置提醒时间" forState:UIControlStateNormal];
     [_detailtimeselect setTitleColor:[UIColor colorNamed:@"21,49,91,1"] forState:UIControlStateNormal];
    
    //_detailtimeselect.backgroundColor = [UIColor colorNamed:@"237,244,253,1"];
     [_detailtimeselect addTarget:self action:@selector(detailselecttime) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:_detailtimeselect];
    
    [self.view addSubview:self.detailrepeatbtn];
}

#pragma mark - private methonds
-(void)detailselectrepeattime{
    [self.datepicker removeFromSuperview];
    UIPickerView* repeatpicker = [[UIPickerView alloc] init];
    repeatpicker.frame = CGRectMake(SCREEN_WIDTH*0.2160, SCREEN_HEIGHT*0.47044*0.19069, 239, 190);
    self.repeatpicker = repeatpicker;
    //[self.repeatpicker addSubview:pickerView];
    repeatpicker.delegate = self;
    repeatpicker.dataSource = self;
  
    self.week = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    self.days = @[
        @31, @29, @31,
        @30, @31, @30,
        @31, @31, @30,
        @31, @30, @31
    ];
    
   // [self.shareView addSubview:self.selectrepeatview];
    [self.view addSubview:self.maskView];
    [self.maskView addSubview:self.whiteview];
    [self.whiteview addSubview:self.repeatpicker];
}

/// 详情页右上角的保存按钮
-(void)detailsave{
    _passValueBlock(self.detailtxt.text, [self.datepicker.date timeIntervalSince1970]);
    [self.navigationController popViewControllerAnimated:YES];
}

/// 监听textfield
-(void)jianting{
//    if(_detailtxt.text == _model.modeltodo_thing)
//        _savebutton.enabled=NO;
}

/// 详情页时间选择好后，按钮文本内容，变为所选时间
-(void)detailsavetime{
    NSDate *detaildate = self.datepicker.date;
    _detailselectedtime = detaildate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd HH:mm";
    [_detailtimeselect setTitle:[formatter stringFromDate:detaildate] forState:(UIControlStateNormal)];
    [self.maskView removeFromSuperview];
    [self.whiteview removeFromSuperview];
}

/// 详情页时间选择界面的取消，点击后removefromsuperview
-(void)detailcanceltime{
    [self.maskView removeFromSuperview];
    [self.whiteview removeFromSuperview];
}

/// datepicker样式设置
-(void)detailselecttime{
    UIDatePicker *datepicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.02, (SCREEN_HEIGHT-382)*0.19069, SCREEN_WIDTH,150)];
    //设置地区
    datepicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_GB"];
    //设置显示样式
    datepicker.datePickerMode = UIDatePickerModeDateAndTime;
    //设置当前显示时间
    [datepicker setDate:[NSDate date] animated:YES];
    self.datepicker = datepicker;
    //设置为wheel样式
    datepicker.preferredDatePickerStyle =UIDatePickerStyleWheels;
    [self.datepicker setCalendar:[NSCalendar currentCalendar]];
    datepicker.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.maskView];
    [self.maskView addSubview:self.whiteview];
    [self.whiteview addSubview:datepicker];
    [self.whiteview addSubview:self.detailcancelbtn];
    [self.whiteview addSubview:self.detailsurebtn];
}

#pragma mark - delegate
//MARK:pickerview数据源方法
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (@available(iOS 11.0, *)){
        pickerView.subviews[1].backgroundColor = nil;
    }
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

//MARK:-pickerview代理方法
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
    [self.repeatpicker reloadAllComponents];
    //②
    if (component==0) {
        NSInteger cnt = [self numberOfComponentsInPickerView:self.repeatpicker];
        for (int i=1; i<cnt; i++) {
            [pickerView selectRow:0 inComponent:i animated:YES];
        }
    }
    //上面的①+②的代码，可以确保一写bug不发生，bug的出现方式：
    //每月选择一个大于7的日期，然后模式换成每周，这时候显示的时间和实际的不符。
    //每月选择一个大于12的日期，然后模式换成每年，就会崩溃
}

#pragma mark - getter方法
/// 确认时间选择按钮懒加载
-(UIButton *)detailsurebtn{
    if(!_detailsurebtn){
        _detailsurebtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.55466, (SCREEN_HEIGHT-SCREEN_HEIGHT*0.47044)*0.81395, 120, 40)];
        _detailsurebtn.backgroundColor = [UIColor colorNamed:@"41,35,210,1"];
        [_detailsurebtn setTitle:@"确定" forState:UIControlStateNormal];
        [_detailsurebtn.layer setMasksToBounds:YES];
        [_detailsurebtn.layer setCornerRadius:16.0];
        [_detailsurebtn addTarget:self action:@selector(detailsavetime) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailsurebtn;
}

///设置重复按钮
-(UIButton *)detailrepeatbtn{
    if(!_detailrepeatbtn){
        _detailrepeatbtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.13333, SCREEN_HEIGHT*0.37931, 150, 25)];
        [_detailrepeatbtn setTitle:@"设置重复提醒" forState:UIControlStateNormal];
        [_detailrepeatbtn setTitleColor:[UIColor colorNamed:@"21,49,91,1"] forState:UIControlStateNormal];
        [_detailrepeatbtn addTarget:self action:@selector(detailselectrepeattime) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailrepeatbtn;
}

///重复时间的picker
-(UIPickerView *)repeatpicker{
    if(!_repeatpicker){
        _repeatpicker = [[UIPickerView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.24266, SCREEN_HEIGHT*0.47044*0.38604, 140, 194)];
    }
    return _repeatpicker;
}

/// 取消时间选择
-(UIButton *)detailcancelbtn{
    if(!_detailcancelbtn){
        _detailcancelbtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.128, (SCREEN_HEIGHT-SCREEN_HEIGHT*0.47044)*0.81395, 120, 40)];
        [_detailcancelbtn setTitleColor:[UIColor colorNamed:@"21,49,91,1"] forState:UIControlStateNormal];
        _detailcancelbtn.backgroundColor = [UIColor colorNamed:@"237,244,253,1"];
        [_detailcancelbtn setTitle:@"取消" forState:UIControlStateNormal];
        [_detailcancelbtn.layer setMasksToBounds:YES];
        [_detailcancelbtn.layer setCornerRadius:16.0];
        [_detailcancelbtn addTarget:self action:@selector(detailcanceltime) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailcancelbtn;
}

///输入备注的textview
-(UITextView *)textview{
    if(!_textview){
        _textview = [[UITextView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.13333, SCREEN_HEIGHT*0.48891, SCREEN_WIDTH*3/4, 100)];
        _textview.backgroundColor = [UIColor whiteColor];
        }
    return _textview;
}

/// 遮罩View
-(UIView *)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor colorNamed:@"128,128,128,72.8"];
    }
    return _maskView;
}

/// 白板，主要承载pickerview和datepicker
-(UIView *)whiteview{
    if(!_whiteview){
        _whiteview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.47044, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_HEIGHT*0.47044)];
        _whiteview.backgroundColor = [UIColor whiteColor];
    }
    return _whiteview;
}

-(UIView *)detailremindtime{
    if(!_detailremindtime){
        _detailremindtime = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 120, 21)];
        _detailremindtime.text = @"设置提醒时间";
        _detailremindtime.textColor = [UIColor colorNamed:@"21,49,91,1"];
    }
    return _detailremindtime;
}

#pragma mark - Events
///点击旁边view收回键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}
#pragma mark - Others
- (void)resetDateSelected {
    self.com3Selected =
    self.com2Selected = 0;
}
@end
