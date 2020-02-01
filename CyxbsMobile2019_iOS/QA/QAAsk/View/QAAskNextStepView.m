//
//  QAAskNextStepView.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAAskNextStepView.h"
#import "QAAskIntegralPickerView.h"
@implementation QAAskNextStepView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *name = NSStringFromClass(self.class);
        [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
        self.contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.contentView];
    }
    [self setupView];
    return self;
}


-(void)setupView{
    self.alpha = 1.0;
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:83/255.0 green:105/255.0 blue:188/255.0 alpha:0.27].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,5);
    self.layer.shadowRadius = 30;
    self.layer.shadowOpacity = 1;
    self.layer.cornerRadius = 16;
    
    NSString *integralNum = [NSString stringWithFormat:@"拥有积分：%@", [UserItemTool defaultItem].integral];
    [self.integralNumLabel setText:integralNum];
    [self.timeLabel setTextColor:[UIColor colorWithHexString:@"#29D1F1"]];
    
    self.commitBtn.layer.cornerRadius = 20;
    
    QAAskIntegralPickerView *view = [[QAAskIntegralPickerView alloc]initWithFrame:CGRectMake(0, 0, self.integralPickBackgroundView.frame.size.width, self.integralPickBackgroundView.frame.size.height)];
    self.integralPickView = view;
    [self.integralPickBackgroundView addSubview:self.integralPickView];
    
    
   NSDate *date = [NSDate date];
//如果没有规定formatter的时区，那么formatter默认的就是当前时区
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //最结尾的Z表示的是时区，零时区表示+0000，东八区表示+0800
//    [formatter setDateFormat:@"YYYY年"];
//    NSString *nowYear = [formatter stringFromDate:date];
//    [formatter setDateFormat:@"MM月"];
//    NSString *nowMonth = [formatter stringFromDate:date];
    [formatter setDateFormat:@"dd日"];
    self.day = [formatter stringFromDate:date];
    [formatter setDateFormat:@"HH时"];
    self.hour = [formatter stringFromDate:date];
    [formatter setDateFormat:@"mm分"];
    self.minutes = [formatter stringFromDate:date];
//    NSString *nowDateString = [NSString stringWithFormat:@"%@%@%@日%@时%@分",nowYear,nowMonth,self.day,self.hour,self.minutes];
    [formatter setDateFormat:@"YYYY年MM月dd日HH时mm分"];
    NSString *nowDateString = [formatter stringFromDate:date];
    [self.timeLabel setText:nowDateString];
    
    self.timePickViewContent = [NSMutableArray array];
    NSMutableArray *dayArray = [NSMutableArray array];
    [formatter setDateFormat:@"MM-dd"];
    // 使用formatter转换后的date字符串变成了当前时区的时间
    for (int i = 0; i < 7; i++) {
        
        NSDate *tmpDate = [NSDate dateWithTimeInterval:86400*i sinceDate:date];
        NSString *tmpDateStr = [formatter stringFromDate:tmpDate];
        NSString *month = [tmpDateStr substringWithRange:NSMakeRange(0, 2)];
        NSString *day = [tmpDateStr substringWithRange:NSMakeRange(3, 2)];
        NSString *dateString = [NSString stringWithFormat:@"%@月%@日",month,day];
//        NSLog(@"%@",dateString);
        [dayArray addObject:dateString];

    }
    [self.timePickViewContent addObject:dayArray];
    
    NSMutableArray *hourArray = [NSMutableArray array];
    for (int i = 0; i < 24; i++) {
        NSString *hourString = [NSString stringWithFormat:@"%d时",i];
        [hourArray addObject:hourString];
    }
    [self.timePickViewContent addObject:hourArray];
    
    NSMutableArray *minutesArray = [NSMutableArray array];
    for (int i = 0; i < 60; i++) {
        NSString *minutesString = [NSString stringWithFormat:@"%d分",i];
        [minutesArray addObject:minutesString];
    }
    [self.timePickViewContent addObject:minutesArray];
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
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.day = self.timePickViewContent[component][row];
    }else if(component == 1){
        self.hour = self.timePickViewContent[component][row];
    }else{
        self.minutes = self.timePickViewContent[component][row];
    }
    NSString *year = [self.timeLabel.text substringWithRange:NSMakeRange(0, 5)];
    NSString *nowDateString = [NSString stringWithFormat:@"%@%@%@%@",year,self.day,self.hour,self.minutes];
    [self.timeLabel setText:nowDateString];

}
@end
