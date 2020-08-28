//
//  QAAskNextStepView.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAAskNextStepView.h"
#import "QAAskIntegralPickerView.h"
#import "IntegralIntroductionController.h"

#define NAVIGATIONTITLECOLOR [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1]


@implementation QAAskNextStepView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *name = NSStringFromClass(self.class);
        [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
        self.contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        self.contentView.layer.cornerRadius = 16;
        self.integralPickBackgroundView.frame = CGRectMake(0, 0, self.frame.size.width, 105);
        [self addSubview:self.contentView];
    }
    [self setupView];
    return self;
}


- (void)setupView{
    self.alpha = 1.0;
//    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:83/255.0 green:105/255.0 blue:188/255.0 alpha:0.27].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,5);
    self.layer.shadowRadius = 30;
    self.layer.shadowOpacity = 1;
    self.layer.cornerRadius = 16;
    
    NSString *integralNum = [NSString stringWithFormat:@"拥有积分：%@", [UserItemTool defaultItem].integral];
    [self.integralNumLabel setText:integralNum];
    [self.timeLabel setTextColor:[UIColor colorWithHexString:@"#29D1F1"]];
    
    self.commitBtn.layer.cornerRadius = 20;
    self.questionmarkBtn.layer.borderWidth = 1;
    self.questionmarkBtn.layer.cornerRadius = self.questionmarkBtn.bounds.size.width / 2;
    [self.questionmarkBtn addTarget:self action:@selector(displayIntegralInstructions) forControlEvents:UIControlEventTouchUpInside];
    //    [self displayIntegralInstructions];
    
    self.integralPickView = [[QAAskIntegralPickerView alloc]initWithFrame:CGRectMake(0, 0, self.integralPickBackgroundView.frame.size.width, self.integralPickBackgroundView.frame.size.height)];
    [self.integralPickBackgroundView addSubview:self.integralPickView];
    
    
    NSDate *date = [NSDate date];
    //如果没有规定formatter的时区，那么formatter默认的就是当前时区
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //最结尾的Z表示的是时区，零时区表示+0000，东八区表示+0800s
    //准备数据源
    self.timePickViewContent = [NSMutableArray array];
    NSMutableArray *dayArray = [NSMutableArray array];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    // 使用formatter转换后的date字符串变成了当前时区的时间
    for (int i = 0; i < 30; i++) {
        
        NSDate *tmpDate = [NSDate dateWithTimeInterval:86400*i sinceDate:date];
        NSString *dateString = [formatter stringFromDate:tmpDate];
        //        NSLog(@"%@",dateString);
        [dayArray addObject:dateString];
        
    }
    [self.timePickViewContent addObject:dayArray];
    
    NSMutableArray *hourArray = [NSMutableArray array];
    
    for (int i = 0; i < 24; i++) {
        NSString *hourString;
        if(i < 10){
            hourString = [NSString stringWithFormat:@"0%d时",i];
        }else{
            hourString = [NSString stringWithFormat:@"%d时",i];
        }
        [hourArray addObject:hourString];
    }
    [self.timePickViewContent addObject:hourArray];
    
    NSMutableArray *minutesArray = [NSMutableArray array];
    for (int i = 0; i < 60; i++) {
        NSString *minutesString;
        if (i < 10) {
            minutesString = [NSString stringWithFormat:@"0%d分",i];
        }else{
            minutesString = [NSString stringWithFormat:@"%d分",i];
        }
        [minutesArray addObject:minutesString];
    }
    [self.timePickViewContent addObject:minutesArray];
    
    //默认显示当前时间往后一小时
    NSDate *defultDate = [NSDate dateWithTimeInterval:3600 sinceDate:date];
    [formatter setDateFormat:@"今天 HH时 mm分"];
    NSString *defultDateString = [formatter stringFromDate:defultDate];
    [self.timeLabel setText:defultDateString];
    //默认选中当前时间
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    self.time = [formatter stringFromDate:defultDate];
    //设置默认选中时间
    [formatter setDateFormat:@"HH"];
    NSInteger hour = [formatter stringFromDate:defultDate].integerValue;
    [self.timePickerVIew selectRow:hour inComponent:1 animated:NO];
    if (hour == 0) {
        [self.timePickerVIew selectRow:1 inComponent:0 animated:NO];
    }
    [formatter setDateFormat:@"mm"];
    NSInteger minute = [formatter stringFromDate:defultDate].integerValue;
    [self.timePickerVIew selectRow:minute inComponent:2 animated:NO];
    
    
    if (@available(iOS 11.0, *)) {
        self.contentView.backgroundColor = [UIColor colorNamed:@"QABackgroundColor"];
        self.integralSettingTitleLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        [self.questionmarkBtn setTitleColor:[UIColor colorNamed:@"QANavigationTitleColor"] forState:UIControlStateNormal];
        self.questionmarkBtn.layer.borderColor = [UIColor colorNamed:@"QANavigationTitleColor"].CGColor;
        [self.cancelBtn setTitleColor:[UIColor colorNamed:@"QANavigationTitleColor"] forState:UIControlStateNormal];
        self.DDLLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        self.awardLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        self.integralNumLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.integralSettingTitleLabel.textColor = NAVIGATIONTITLECOLOR;
        [self.questionmarkBtn setTitleColor:NAVIGATIONTITLECOLOR forState:UIControlStateNormal];
        self.questionmarkBtn.layer.borderColor = NAVIGATIONTITLECOLOR.CGColor;
        [self.cancelBtn setTitleColor:NAVIGATIONTITLECOLOR forState:UIControlStateNormal];
        self.DDLLabel.textColor = NAVIGATIONTITLECOLOR;
        self.awardLabel.textColor = NAVIGATIONTITLECOLOR;
        self.integralNumLabel.textColor = NAVIGATIONTITLECOLOR;
    }
}
- (void)displayIntegralInstructions{
    IntegralIntroductionController *vc = [[IntegralIntroductionController alloc] init];
    [self.viewController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UIPickerViewDelegate
#pragma mark 列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
#pragma mark 每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *arr = self.timePickViewContent[component];
    return arr.count;
}

#pragma mark pickerView内容
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    ((UILabel *)[pickerView.subviews objectAtIndex:1]).hidden = YES;    //隐藏分隔线
    ((UILabel *)[pickerView.subviews objectAtIndex:2]).hidden = YES;    //隐藏分隔线
    if (component==0&&row==0) {
        return @"今天";
    }else{
        return self.timePickViewContent[component][row];
    }
}
#pragma mark pickerView每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0) {
        return 150;
    }else{
        return 80;
    }
}
#pragma mark pickerView滚动方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    NSInteger day = [self.timePickerVIew selectedRowInComponent:0];
    NSInteger hour = [self.timePickerVIew selectedRowInComponent:1];
    NSInteger minute = [self.timePickerVIew selectedRowInComponent:2];
    NSString *selectedDateString = [NSString stringWithFormat:@"%@ %@%@",self.timePickViewContent[0][day],self.timePickViewContent[1][hour],self.timePickViewContent[2][minute]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-ddHH时mm分"];
    NSDate *date = [formatter dateFromString:selectedDateString];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.time = [formatter stringFromDate:date];
    [self.timeLabel setText:selectedDateString];
    
}
@end
