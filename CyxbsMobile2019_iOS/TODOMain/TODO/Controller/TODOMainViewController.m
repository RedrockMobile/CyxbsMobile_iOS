//
//  TODOMainViewController.m
//  ZY
//
//  Created by 欧紫浩 on 2021/8/11.
//

//Models
#import "TODOModel.h"
//Controllers
#import "TODOMainViewController.h"
#import "TODODetailViewController.h"
//Views
#import "ToDoEmptyCell.h"
#import "TodoTableViewCell.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//枚举
typedef enum : NSUInteger {
    DiscoverTodoSelectRepeatTypeDay,
    DiscoverTodoSelectRepeatTypeWeek,
    DiscoverTodoSelectRepeatTypeMonth,
    DiscoverTodoSelectRepeatTypeYear
} TodoSelectRepeatType;

@interface TODOMainViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource, TodoTableViewCellDelegate>
///tableview
@property (nonatomic,strong) UITableView *tableview;
///待办字样
@property (nonatomic,strong) UILabel *tobedonelbl;
///已完成字样
@property (nonatomic,strong) UILabel *finishlbl;
///添加按钮（加号按钮）
@property (nonatomic,strong) UIButton *addbtn;
///遮罩
@property (nonatomic,strong) UIView *maskView;
///自定义弹窗view
@property (nonatomic,strong) UIView *shareView;
///选择时间View
@property (nonatomic,strong) UIView *timeView;
///选择重复时间View
@property (nonatomic,strong) UIView *selectrepeatview;
///文本框
@property (nonatomic,strong) UITextField *txt;
///右上角添加button
@property (nonatomic,strong) UIBarButtonItem *addButton;
///设置提醒时间
@property (nonatomic,strong) UIButton *remindtime;
///设置重复提醒
@property (nonatomic,strong) UIButton *repeatremind;
///时间选择器
@property (nonatomic,strong) UIDatePicker *datepicker;
///选择重复
@property (nonatomic,strong) UIPickerView *pickerView;
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
///datestr
@property (nonatomic,copy) NSString *dateStr;
///保存时间
@property (nonatomic,strong) UIButton *sharesave;
///取消时间
@property (nonatomic,strong) UIButton *sharecancel;
///取消重复时间
@property (nonatomic,strong) UIButton *cancelrepeat;
///保存重复时间
@property (nonatomic,strong) UIButton *saverepeat;
///数据数组
@property (nonatomic,strong) NSMutableArray <NSMutableArray <TODOModel *>*>*dataSource;
/// 选择的时间
@property(nonatomic, strong) NSDate *selectedDate;
@property(nonatomic, strong) UIButton *foldButton;
/// 隐藏已完成
@property(nonatomic, assign) BOOL hideDone;
@end

@implementation TODOMainViewController

#pragma mark - LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.view addSubview:self.tableview];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
        backBtn.title = @"返回";
    [backBtn setTintColor:[UIColor colorNamed:@"21_49_91&240_240_242"]];
        self.navigationItem.backBarButtonItem = backBtn;
    
    _addButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(add)];
    [_addButton setTintColor:[UIColor colorNamed:@"21_49_91&240_240_242"]];
    self.navigationItem.rightBarButtonItem = _addButton;
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
}

-(void)viewWillDisappear:(BOOL)animated{
    _txt.text = @"";
    [self.datepicker removeFromSuperview];
    [self.pickerView removeFromSuperview];
}

#pragma mark - private metonds


//主页右上角的添加字样
- (void)dismiss:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

-(void)add{
    [self.view addSubview:_maskView];
    [self.maskView addSubview:self.shareView];
    [self.remindtime setTitle:@"设置提醒时间" forState:(UIControlStateNormal)];
    _txt.text = nil;
    self.selectedDate = nil;
    [self textFieldDidChanged:self->_txt];
}

//弹出窗口上的保存按钮,将内容传到tableview上
-(void)save{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"左滑可删除待办！" preferredStyle:UIAlertControllerStyleAlert];
    alert.view.backgroundColor = [UIColor colorNamed:@"42_78_132&223_223_227"];
    alert.view.frame = CGRectMake(SCREEN_WIDTH*0.11733, 30,288,36);
     [self presentViewController:alert animated:YES completion:nil];
    //控制提示框显示的时间为0.75秒
     [self performSelector:@selector(dismiss:) withObject:alert afterDelay:0.4];
    NSLog(@"hahahh");
    
    
    NSString * str = _txt.text;
    TODOModel *model = [TODOModel new];
    model.modeltodo_thing = str;
    
    if (self.selectedDate) {
        model.timestamp = [self.selectedDate timeIntervalSince1970];
    }
    [self.dataSource.firstObject addObject:model];
    [self.maskView removeFromSuperview];
    [self.shareView removeFromSuperview];
    [self.tableview reloadData];
    NSLog(@"数据刷新了");
}

//弹出窗口左上角的取消按钮，显示主页面
-(void)pop{
    [self.maskView removeFromSuperview];
    [self.shareView removeFromSuperview];
    [self.timeView removeFromSuperview];
    [self.selectrepeatview removeFromSuperview];
    [self.datepicker removeFromSuperview];
    [self.pickerView removeFromSuperview];
    NSLog(@"llll");
    _selectedDate = nil;
}

//点击取消选择时间的点击事件（dateview消失）
-(void)poptime{
    [self.timeView removeFromSuperview];
    _selectedDate = nil;
}

//保存时间按钮的点击事件（将所选时间的内容赋值给按钮的文本）
-(void)savetime {
    NSDate *date = self.datepicker.date;
    _selectedDate = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd HH:mm";
    [self.timeView removeFromSuperview];
    //把button字样换成设置的时间
    [_remindtime setTitle:[formatter stringFromDate:date] forState:(UIControlStateNormal)];
}

//保存重复时间按钮的点击事件
-(void)saverepeats{
    
}

//取消重复时间按钮的点击事件
-(void)cancelrepeats{
    [self.selectrepeatview removeFromSuperview];
    [self.pickerView removeFromSuperview];
}

//选择时间（弹出datepicker，并设置其样式）
-(void)timeselect{
    NSLog(@"时间选择");
    UIDatePicker *datepicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH,(SCREEN_HEIGHT-SCREEN_HEIGHT*0.26108)*0.45)];
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
    
    [self.shareView addSubview:self.timeView];
    [self.timeView addSubview:datepicker];
    [self.timeView addSubview:self.sharesave];
    [self.timeView addSubview:self.sharecancel];
    [self.selectrepeatview removeFromSuperview];
    [self.selectrepeatview removeFromSuperview];
}

//选择重复时间段
-(void)repeatselect{
    UIPickerView* pickerView = [[UIPickerView alloc] init];
    self.pickerView = pickerView;
    [self.selectrepeatview addSubview:pickerView];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.shareView addSubview:self.selectrepeatview];
    self.week = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    self.days = @[
        @31, @29, @31,
        @30, @31, @30,
        @31, @31, @30,
        @31, @30, @31
    ];
    
    [self.shareView addSubview:self.selectrepeatview];
    [self.selectrepeatview addSubview:self.cancelrepeat];
    [self.selectrepeatview addSubview:self.saverepeat];
    [self.selectrepeatview addSubview:self.addbtn];
    [self.datepicker removeFromSuperview];
    [self.timeView removeFromSuperview];
}

- (void)foldAction {
    self.hideDone = !self.hideDone;
    [self.tableview reloadData];
}

#pragma mark - TodoTableViewCellDelegate
- (void)todoCellDidClickedDoneButton:(TodoTableViewCell *)todoCell {
    if (!todoCell.model) {
        return;
    }
            NSIndexPath *indexPath = [self.tableview indexPathForCell:todoCell];
            if (indexPath.row != NSNotFound){
                NSMutableArray <TODOModel *>*firstDataSource = self.dataSource.firstObject;
                [firstDataSource removeObjectAtIndex:indexPath.row];
                NSMutableArray <TODOModel *>*lastDataSource = self.dataSource.lastObject;
               // [lastDataSource addObject:todoCell.model];
                [lastDataSource insertObject:todoCell.model atIndex:0];
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
                //此处应当注意，一定要判断，数据源数组非空的情况下，再进行这个动画操作，再tableview侧滑删除cell的时候也是如此，因为此处有空cell一定删除完数据源数组的内容，系统就会默认table已空，但实际上还有一承载imageview的空cell，所以一定要加上这个逻辑判断
                if(firstDataSource.count!=0){
                    [self.tableview beginUpdates];
                    [self.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    [self.tableview insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationRight];
                    [self.tableview endUpdates];
                }
                [self.tableview reloadData];
            }
}

#pragma mark- delegate
//MARK:tableview数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray <TODOModel *>*dataList = self.dataSource[section];
    if (dataList.count == 0) {
        return 1;
    }
    if (section == 1) {
        if (self.hideDone) {
            return 0;
        }
    }
    return dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray <TODOModel *>*dataList = self.dataSource[indexPath.section];
    if (dataList.count == 0) {
        //如果没内容，换样式
        ToDoEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoEmptyCell" forIndexPath:indexPath];
        cell.type = indexPath.section;
        return cell;
    }
    TODOModel * model = dataList[indexPath.row];
    TodoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodoTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    [cell configTODOModel:model];
    cell.delegate = self;
    return cell;
}

//MARK: - pickerview数据源方法
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

//MARK:-tableview代理方法
- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray <TODOModel *>*dataList = self.dataSource[indexPath.section];
    if (dataList.count == 0) {
        return nil;
    }
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [dataList removeObjectAtIndex:indexPath.row];
        completionHandler (YES);
        if(dataList.count!=0){
            [tableView beginUpdates];
            [tableView  deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
        [self.tableview reloadData];
    }];
    deleteRowAction.image = [UIImage imageNamed:@"垃圾桶图"];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 90;
    }else{
        return 90;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray <TODOModel *>*dataList = self.dataSource[indexPath.section];
    if (dataList.count == 0) {
        return 220;
    }
    
    TODOModel *model = dataList[indexPath.row];
    
    if (model.timestamp > 0) {
        return 110;
    } else {
        return 64;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSMutableArray <TODOModel *>*dataList = self.dataSource[indexPath.section];
    if (dataList.count == 0) {
        return;
    }
    TODOModel *model = dataList[indexPath.row];
    if(model.isDone){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"掌友，无法对已完成事项进行修改哦！" preferredStyle:UIAlertControllerStyleAlert];
        alert.view.backgroundColor = [UIColor colorNamed:@"42_78_132&223_223_227"];
        alert.view.frame = CGRectMake(SCREEN_WIDTH*0.11733, 30,288,36);
         [self presentViewController:alert animated:YES completion:nil];
        //控制提示框显示的时间为0.75秒
         [self performSelector:@selector(dismiss:) withObject:alert afterDelay:0.5];
        NSLog(@"hahahh");
    }else{
    TODODetailViewController *vc = [[TODODetailViewController alloc]init];
    //vc.detailtimecontent = model.modeltodo_time;
    vc.model = model;
    vc.detailtimecontent = model.timestamp;
    vc.passValueBlock = ^(NSString * passedthing, NSInteger  passedtime) {
        model.modeltodo_thing = passedthing;
        model.timestamp = passedtime;
        [self.tableview reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    }
}

///headerview
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView* firstview = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, 60.0)];
        _tobedonelbl = [[UILabel alloc]init];
        _tobedonelbl.frame = CGRectMake(15,50,50,34);
        _tobedonelbl.font = [UIFont fontWithName:@"PingFangSC-normal" size:40];
        _tobedonelbl.textColor = [UIColor colorNamed:@"128_128_128_72.8&0_15_37"];
        _tobedonelbl.text = @"待办";
      
        [firstview addSubview:_tobedonelbl];
        return firstview;
    }else if(section==1){
        UIView * secondview = [[UIView alloc] initWithFrame:CGRectMake(0,60, SCREEN_WIDTH,60.0)];
        _finishlbl = [[UILabel alloc ]init ];
        _finishlbl.frame = CGRectMake(15,20,100,34);
        _finishlbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        _finishlbl.text = @"已完成";
        _finishlbl.textColor = [UIColor lightGrayColor];
        [secondview addSubview:_finishlbl];
        
        self.foldButton.imageView.transform = self.hideDone ? CGAffineTransformIdentity :  CGAffineTransformMakeRotation(M_PI);
        
        [secondview addSubview:self.foldButton];
        
        return secondview;
    }
    return nil;
}

//MARK:UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
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

#pragma mark - getter
-(NSMutableArray<NSMutableArray<TODOModel *> *> *)dataSource{
    if (_dataSource == nil) {
        _dataSource = NSMutableArray.array;
        NSMutableArray <TODOModel *>*oneList = NSMutableArray.array;
        NSMutableArray <TODOModel *>*twoList = NSMutableArray.array;
        [_dataSource addObject:oneList];
        [_dataSource addObject:twoList];
    }
    return _dataSource;
}

-(UITableView *)tableview{
    if (_tableview == nil){
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
       // _tableview.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableview registerClass:TodoTableViewCell.class forCellReuseIdentifier:@"TodoTableViewCell"];
        [_tableview registerClass:ToDoEmptyCell.class forCellReuseIdentifier:@"ToDoEmptyCell"];
        _tableview.backgroundColor = [UIColor whiteColor];
    }
    return _tableview;
}

/// 遮罩view
-(UIView *)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor colorNamed:@"128_128_128_72.8&0_15_37"];
    }
    return _maskView;
}

///自定义view
-(UIView *)shareView{
    if (!_shareView){
        _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.26108, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_HEIGHT*0.26108)];
        
        _shareView.backgroundColor = [UIColor colorNamed:@"255_255-255&0_0_1"];
      //  _shareView.backgroundColor = [UIColor redColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: _shareView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(30,30)];
            //创建 layer
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _shareView.bounds;
            //赋值
            maskLayer.path = maskPath.CGPath;
        _shareView.layer.mask = maskLayer;
        [self.maskView addSubview:_shareView];
        
        UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.04, 30, 50, 10)];
        [btn1 setTitle:@"取消" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorNamed:@"21_49_91&240_240_242"]forState:UIControlStateNormal];
        [self.shareView addSubview:btn1];
        [btn1 addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        
        
        [UIButton buttonWithType:(UIButtonTypeCustom)];
        UIButton * btn2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn2.frame = CGRectMake(SCREEN_WIDTH*0.83, 21, 50, 21);
        btn2.tag = 10001;
        btn2.enabled = false;
        [btn2 setTitle:@"保存" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorNamed:@"41_35_210&44_222_255"]forState:UIControlStateNormal];
        [btn2 setTitleColor:UIColor.grayColor forState:UIControlStateDisabled];
        [btn2 addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:btn2];
        
        //设置时间按钮
        _remindtime = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.128, 143, 130, 21)];
        _remindtime.tag = 0;
        [_remindtime setTitle:@"设置提醒时间" forState:UIControlStateNormal];
        _remindtime.titleLabel.textAlignment = NSTextAlignmentRight;
        [_remindtime setTitleColor:[UIColor colorNamed:@"42_78_132&223_223_227"]forState:UIControlStateNormal];
        [_shareView addSubview:_remindtime];
        [_remindtime addTarget:self action:@selector(timeselect) forControlEvents:UIControlEventTouchUpInside];
        
        //设置重复提醒按钮
        _repeatremind = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.128, 180, 130, 21)];
        [_repeatremind setTitle:@"设置重复提醒" forState:UIControlStateNormal];
        _repeatremind.titleLabel.textAlignment = NSTextAlignmentRight;
        [_repeatremind setTitleColor:[UIColor colorNamed:@"42_78_132&223_223_227"]forState:UIControlStateNormal];
        [_shareView addSubview:_repeatremind];
        [_repeatremind addTarget:self action:@selector(repeatselect) forControlEvents:UIControlEventTouchUpInside];
        
        //输入文本框
        _txt = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.048, 75, 339, 44)];
        [_txt addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:(UIControlEventEditingChanged)];
        _txt.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        _txt.backgroundColor = [UIColor colorNamed:@"232_241_252&31_31_31"];
        _txt.placeholder = @"添加待办事项";
        _txt.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        //设置显示模式为永远显示(默认不显示)
        _txt.leftViewMode = UITextFieldViewModeAlways;
       // _txt.borderStyle = UITextBorderStyleRoundedRect;
        _txt.layer.cornerRadius = 20.0 ;
        _txt.delegate = self;
        [_shareView addSubview:_txt];
    }
    return _shareView;
}

/// 监听txt 有内容 才亮
-(void)textFieldDidChanged:(UITextField *)textField {
    UIButton *savaButton = [self.shareView viewWithTag:10001];
    savaButton.enabled = textField.text.length > 0;
}

///承载时间选择器的view
-(UIView *)timeView{
    if(!_timeView){
        _timeView = [[UIView alloc]initWithFrame:CGRectMake(0,215,SCREEN_HEIGHT*0.51757,SCREEN_HEIGHT-SCREEN_HEIGHT*0.51757)];
        _timeView.backgroundColor = [UIColor whiteColor];
        NSLog(@"timeView已经展示");
    }
    return _timeView;
}

///承载选择重复时间的view
-(UIView *)selectrepeatview{
    if(!_selectrepeatview){
        _selectrepeatview = [[UIView alloc]initWithFrame:CGRectMake(0, 215, SCREEN_WIDTH, 384)];
        _selectrepeatview.backgroundColor = [UIColor whiteColor];
        NSLog(@"选择重复时间界面已显示");
    }
    return _selectrepeatview;
}

/// 选择时间右下角的保存
-(UIButton *)sharesave{
    if(!_sharesave){
        _sharesave = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.55466, 220, 120, 40)];
        _sharesave.backgroundColor = [UIColor colorNamed:@"41_35_210&44_222_255"];
        [_sharesave setTitle:@"保存" forState:UIControlStateNormal];
        [_sharesave.layer setMasksToBounds:YES];
        [_sharesave.layer setCornerRadius:16.0];
        [_sharesave addTarget:self action:@selector(savetime) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sharesave;
}

///选择重复的确认按钮
-(UIButton *)saverepeat{
    if(!_saverepeat){
        _saverepeat = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.55466,  220, 120, 40)];
        _saverepeat.backgroundColor = [UIColor colorNamed:@"41_35_210&44_222_255"];
        [_saverepeat setTitle:@"保存" forState:UIControlStateNormal];
        [_saverepeat.layer setMasksToBounds:YES];
        [_saverepeat.layer setCornerRadius:16.0];
        [_saverepeat addTarget:self action:@selector(saverepeats) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saverepeat;
}

///取消选择重复时间的按钮
-(UIButton *)cancelrepeat{
    if(!_cancelrepeat){
        _cancelrepeat = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.128, 220, 120, 40)];
        _cancelrepeat.backgroundColor = [UIColor colorNamed:@"232_241_252&31_31_31"];
        [_cancelrepeat setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelrepeat.layer setMasksToBounds:YES];
        [_cancelrepeat.layer setCornerRadius:16.0];
        [_cancelrepeat addTarget:self action:@selector(cancelrepeats) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancelrepeat;;
}

/// 自定义弹窗左下角的取消
-(UIButton *)sharecancel{
    if(!_sharecancel){
        _sharecancel = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.128, 220, 120, 40)];
        _sharecancel.backgroundColor = [UIColor colorNamed:@"232_241_252&31_31_31"];
        [_sharecancel setTitle:@"取消" forState:UIControlStateNormal];
        [_sharecancel.layer setMasksToBounds:YES];
        [_sharecancel.layer setCornerRadius:16.0];
        [_sharecancel addTarget:self action:@selector(poptime) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sharecancel;
}

///选择重复时间的加号
-(UIButton *)addbtn{
    if(!_addbtn){
        _addbtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.82133, SCREEN_HEIGHT*0.13638, 18, 18)];
        [_addbtn setBackgroundImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
    }
    return  _addbtn;
}

///折叠按钮
- (UIButton *)foldButton {
    if (!_foldButton) {
        _foldButton = ({
            UIButton *object = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [object setImage:[UIImage imageNamed:@"foldImage"] forState:(UIControlStateNormal)];
            [object addTarget:self action:@selector(foldAction) forControlEvents:(UIControlEventTouchUpInside)];
            object.frame = CGRectMake(90,16,40,40);
            object;
        });
    }
    return _foldButton;
}

#pragma mark - Events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}

#pragma mark - Others
- (void)resetDateSelected {
    self.com3Selected =
    self.com2Selected = 0;
}

@end
