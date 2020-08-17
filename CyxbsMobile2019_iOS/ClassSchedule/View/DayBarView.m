//
//  DayBarView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "DayBarView.h"
//#define DAY_BAR_ITEM_H (MAIN_SCREEN_H*0.0616)
//#define DAY_BAR_ITEM_W (MAIN_SCREEN_W*0.1227)
//#define MONTH_ITEM_W (MAIN_SCREEN_W*0.088)
//#define DAYBARVIEW_DISTANCE (MAIN_SCREEN_W*0.00885)
@interface DayBarView ()
@property (nonatomic,strong)NSMutableArray *weekLabelViewArray;
@property (nonatomic,strong)UIView *monthView;
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation DayBarView
/// 初始化成为某周准备的bar
- (instancetype)initWithDataArray:(NSArray*)dataArray{
    self = [super init];
    if(self){
        self.dataArray = dataArray;
        NSDictionary *firstDay =[dataArray firstObject];
        self.monthView = [self getMonthViewWithNum:firstDay[@"month"]];
        [self addSubview:self.monthView];
        self.weekLabelViewArray = [NSMutableArray array];
        for (int i=0; i<7; i++) {
            NSDictionary *dayData = [self transferData:@{
                @"day":dataArray[i][@"day"],
                @"index":[NSNumber numberWithInt:i],
            }];
            
            UIView *weekLabelView = [self getLabelViewWithDict:dayData];
            [self addSubview:weekLabelView];
            [self.weekLabelViewArray addObject:weekLabelView];
        }
//        [self updata];
        [self addConstraint];
    }
    return self;
}

/// 初始化成为整学期准备的bar
- (instancetype)initForWholeTerm{
    self = [super init];
    if(self){
        self.monthView = [self getMonthViewWithNum:nil];
        [self addSubview:self.monthView];
        self.weekLabelViewArray = [NSMutableArray array];
        for (int i=0; i<7; i++) {
            NSDictionary *dayData = [self transferData:@{
                @"index":[NSNumber numberWithInt:i],
            }];
            UIView *weekLabelView = [self getLabelViewWithDict:dayData];
            [self addSubview:weekLabelView];
            [self.weekLabelViewArray addObject:weekLabelView];
        }
        [self addConstraint];
    }
    return self;
}

/// 得到一个显示”周x“和@”x日“的view
/// @param dict 结构：@{@"week":@"周x", @"day":@"x日"}
- (UIView*)getLabelViewWithDict:(NSDictionary*)dict{
    UIView *backView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)) {
        backView.backgroundColor = [UIColor colorNamed:@"peopleListViewBackColor"];
    } else {
        backView.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.14];
    }
    backView.layer.cornerRadius = 4;
    
    
    UILabel *week = [[UILabel alloc] init];
    [backView addSubview:week];
    
    week.backgroundColor = UIColor.clearColor;
    week.font = [UIFont fontWithName:@".PingFang SC" size: 12];
    week.text = dict[@"week"];
    if (@available(iOS 11.0, *)) {
        week.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        week.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    
    [week mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(DAY_BAR_ITEM_H*0.12);
        make.centerX.equalTo(backView);
    }];
    
    
    UILabel *day = [[UILabel alloc] init];
    [backView addSubview:day];
    
    day.backgroundColor = UIColor.clearColor;
    day.font = [UIFont fontWithName:@".PingFang SC" size: 12];
    day.text = dict[@"day"];
    if (@available(iOS 11.0, *)) {
        day.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        day.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    day.alpha = 0.64;
    
    [day mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView).offset(-DAY_BAR_ITEM_H*0.12);
        make.centerX.equalTo(backView);
    }];
    //布局调试用
//    backView.backgroundColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:0.7];
    return backView;
}

//得到一个显示@“num月”的monthView,如果num==nil那么显示的文字为空
- (UIView*)getMonthViewWithNum:(NSNumber*)num{
    UIView *backView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)) {
        backView.backgroundColor = [UIColor colorNamed:@"peopleListViewBackColor"];
    } else {
        backView.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.14];
    }
    
    UILabel *month =  [[UILabel alloc] init];
    [backView addSubview:month];
    
    month.backgroundColor = UIColor.clearColor;
    month.font = [UIFont fontWithName:@".PingFang SC" size: 12];
    if(num==nil){
        month.text = @"";
    }else{
        month.text = [NSString stringWithFormat:@"%@月",num];
    }
    if (@available(iOS 11.0, *)) {
        month.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        month.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    
    [month mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
    }];
    //布局调试用
//    backView.backgroundColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:0.7];
    return backView;
}

/// 加约束，调用前需确保：self.weekLabelViewArray、self.monthView初始化完成，且已经加到父控件
- (void)addConstraint{
    [self.monthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
        make.width.mas_equalTo(MONTH_ITEM_W);
    }];
    
    UIView *anchorView = self.monthView;
    for (UIView *v in self.weekLabelViewArray) {
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(anchorView.mas_right).offset(DAYBARVIEW_DISTANCE);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(DAY_BAR_ITEM_W);
        }];
        anchorView = v;
    }
    
    [anchorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
    }];
}

//@"index":@3, -> @"week":@"周四",
//@"day":26, -> @"day":@"x日",
- (NSDictionary*)transferData:(NSDictionary*)dict{
    NSString *index = dict[@"index"];
    NSString *day = dict[@"day"];
    NSArray *transfer = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSString *dayStr;
    if(day==nil){
        dayStr = @"";
    }else{
        dayStr = [NSString stringWithFormat:@"%@日",day];
    }
    return @{
        @"week":transfer[[index intValue]],
        @"day":dayStr,
    };
    
}
- (void)updata{
    NSDate *now = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"y"];
    NSString *year = [formate stringFromDate:[NSDate date]];
    NSString *selfMonth = [self.dataArray firstObject][@"month"];
    NSString *selfDay = [self.dataArray firstObject][@"day"];
    NSString *dataStr = [NSString stringWithFormat:@"%@-%@-%@",year,selfMonth,selfDay];
    
    
    
    formate.dateFormat = @"yyyy-M-d";
    NSString *today = [formate stringFromDate:[NSDate date]];
        
       // 2、拿现在的时间和过去时间或者将来时间对比，计算出相差多少天，多少年，多少秒等等；
       NSDate *beforTime = [formate dateFromString:@"2020-08-15"];
    
    
    
       NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
       NSDateComponents *compsday = [calender components:NSCalendarUnitDay fromDate:beforTime toDate:now options:0];
    
    
    NSLog(@"%@，%@相差天数 = %ld",dataStr,today,[compsday day]);
    
    return;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"M"];
    NSString *month = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"d"];
    NSString *day =[formatter stringFromDate:[NSDate date]];
    
    
    
    if([month isEqualToString:selfMonth]&&[day isEqualToString:selfDay]){
        
    }
    
}

@end
