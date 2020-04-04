//
//  WYCClassDetailView.m
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2018/9/23.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import "WYCClassDetailView.h"

@interface WYCClassDetailView()
@property (nonatomic, strong) IBOutlet UILabel *className;

@property (nonatomic, strong) IBOutlet UILabel *teacher;
@property (nonatomic, strong) IBOutlet UILabel *classroom;
@property (nonatomic, strong) IBOutlet UILabel *classTime;
@property (nonatomic, strong) IBOutlet UILabel *classType;
@property (nonatomic, strong) IBOutlet UILabel *classWeek;
@property (weak, nonatomic) IBOutlet UILabel *Week;
@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UILabel *Type;

@property (nonatomic, strong) NSDictionary *dic;

@end
@implementation WYCClassDetailView
+(WYCClassDetailView *)initViewFromXib{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"WYCClassDetailView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.frame = CGRectMake(0, 0, 270, 360);
        
    }
    return self;
}

-(void)initWithDic:(NSDictionary *)dic{

    self.dic = dic;
    self.Type.text = @"类型";
    self.Type.font =[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.Type.textColor = [UIColor colorWithHexString:@"#15315B"];
    self.Type.textAlignment = NSTextAlignmentLeft;
    [self.Type setNumberOfLines:1];
    self.Type.lineBreakMode = NSLineBreakByWordWrapping;

    
    self.Time.text = @"时间";
    self.Time.font =[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.Time.textColor = [UIColor colorWithHexString:@"#15315B"];
    self.Time.textAlignment = NSTextAlignmentLeft;
    [self.Time setNumberOfLines:1];
    self.Time.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.Week.text = @"周数";
    self.Week.font =[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.Week.textColor = [UIColor colorWithHexString:@"#15315B"];
    self.Week.textAlignment = NSTextAlignmentLeft;
    [self.Week setNumberOfLines:1];
    self.Week.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.className.text = [dic objectForKey:@"course"];
    self.className.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    self.className.alpha = 1.0;
    self.className.textColor = [UIColor colorWithHexString:@"#15315B"];
    self.className.textAlignment = NSTextAlignmentLeft;
    [self.className setNumberOfLines:1];
    self.className.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.teacher.text = [dic objectForKey:@"teacher"];
    self.teacher.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.teacher.alpha = 1.0;
    self.teacher.textColor = [UIColor colorWithHexString:@"#15315B"];
    self.teacher.textAlignment = NSTextAlignmentLeft;
    [self.teacher setNumberOfLines:1];
    self.teacher.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    self.classroom.text = [dic objectForKey:@"classroom"];
    self.classroom.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.classroom.alpha = 1.0;
    self.classroom.textColor = [UIColor colorWithHexString:@"#15315B"];
    self.classroom.textAlignment = NSTextAlignmentLeft;
    [self.classroom setNumberOfLines:1];
    self.classroom.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    self.classTime.text = [self getClassTime];
    self.classTime.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    self.classTime.alpha = 1.0;
    self.classTime.textColor = [UIColor colorWithHexString:@"#15315B"];
    self.classTime.textAlignment = NSTextAlignmentLeft;
    [self.classTime setNumberOfLines:1];
    self.classTime.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.classType.text = [dic objectForKey:@"type"];
    self.classType.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    self.classType.alpha = 1.0;
    self.classType.textColor = [UIColor colorWithHexString:@"#15315B"];
    self.classType.textAlignment = NSTextAlignmentLeft;
    
    self.classWeek.text = [dic objectForKey:@"rawWeek"];
    self.classWeek.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    self.classWeek.textColor = [UIColor colorWithHexString:@"#15315B"];
    self.classWeek.alpha = 1.0;
    self.classWeek.textAlignment = NSTextAlignmentLeft;
    [self.classWeek setNumberOfLines:1];
    self.classWeek.lineBreakMode = NSLineBreakByWordWrapping;
    
}


- (NSString *)getClassTime{
    NSString *classTime = [[NSString alloc]init];
    
    NSArray *timeArray = @[@"8:00",@"9:40",@"10:15",@"11:55",@"14:00",@"15:40",@"16:15",@"17:55",@"19.00",@"20:40",@"21:15",@"22:55"];
    
    NSString *day = [self.dic objectForKey:@"day"];
    //NSString *lesson = [self.dic objectForKey:@"lesson"];
    //NSNumber *hash_lesson = [self.dic objectForKey:@"hash_lesson"];
    NSNumber *begin_lesson = [self.dic objectForKey:@"begin_lesson"];
    NSNumber *period = [self.dic objectForKey:@"period"];
    
    NSString *classNum = [NSString stringWithFormat:@"%ld-%ld节",begin_lesson.integerValue,(begin_lesson.integerValue + period.integerValue - 1)];
    NSString *beginTime = timeArray[begin_lesson.integerValue - 1];
    NSString *finishTime = @"";
    if([period isEqualToNumber:@3]){
        NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
        dateFormate.dateFormat = @"HH:mm";
        NSDate *beginDate = [dateFormate dateFromString:beginTime];
        NSDate *finishDate = [NSDate dateWithTimeInterval:9300 sinceDate:beginDate];
        finishTime = [dateFormate stringFromDate:finishDate];
    }else{
        finishTime = timeArray[begin_lesson.integerValue + period.integerValue - 2];
    }
    classTime = [NSString stringWithFormat:@"%@ ~ %@\n%@ ~ %@",day,classNum,beginTime,finishTime];
    
    return classTime;
}

@end
