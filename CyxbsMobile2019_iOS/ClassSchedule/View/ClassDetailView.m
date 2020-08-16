//
//  ClassDetailView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ClassDetailView.h"
@interface ClassDetailView()

/// 课程名称
@property (nonatomic, strong)UILabel *lessonNameLabel;

/// 教室名
@property (nonatomic, strong)UILabel *classroomNameLabel;

/// 老师名
@property (nonatomic, strong)UILabel *teacherNameLabel;

/// 周期
@property (nonatomic, strong)UILabel *weekRangeLabel;

/// 时间
@property (nonatomic, strong)UILabel *classTimeLabel;

/// 学分数
@property (nonatomic, strong)UILabel *scoreLabel;

/// 显示“周期”二字的label
@property (nonatomic, strong)UILabel *week;

/// 显示“时间”二字的label
@property (nonatomic, strong)UILabel *time;

/// 显示“学分数”二字的label
@property (nonatomic, strong)UILabel *score;

@end

@implementation ClassDetailView

/// 显示一节课详情的view
/// @param dataDict 一节课的信息
- (instancetype)initWithLessonDataDict:(NSDictionary*)dataDict{
    self = [super init];
    if(self){
        [self initLabel];
        self.dataDict = dataDict;
    }
    return self;
}
/// 重写了dataDict的set方法，这样给dataDict赋值就可以自动完成对文字的设置
- (void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    self.lessonNameLabel.text = dataDict[@"course"];
    self.classroomNameLabel.text = dataDict[@"classroom"];
    self.teacherNameLabel.text = dataDict[@"teacher"];
    self.weekRangeLabel.text = dataDict[@"rawWeek"];
    
    NSString *daytime = [self transformDataString:dataDict[@"lesson"] withPeriod:[dataDict[@"period"]intValue]];
    self.classTimeLabel.text =
    [NSString stringWithFormat:@"%@  %@",dataDict[@"day"],daytime];
    self.scoreLabel.text = dataDict[@"type"];
}

//文本框初始化
- (void)initLabel{
    //alloc init
    self.lessonNameLabel = [[UILabel alloc] init];
    self.weekRangeLabel = [[UILabel alloc] init];
    self.classTimeLabel = [[UILabel alloc] init];
    self.scoreLabel = [[UILabel alloc] init];
    self.classroomNameLabel = [[UILabel alloc] init];
    self.teacherNameLabel = [[UILabel alloc] init];
    self.week = [[UILabel alloc] init];
    self.time = [[UILabel alloc] init];
    self.score = [[UILabel alloc] init];
    
    //上色
    UIColor *textColor;
    if(@available(iOS 11.0, *)){
        textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    }else{
        textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    self.lessonNameLabel.textColor = textColor;
    self.weekRangeLabel.textColor = textColor;
    self.classTimeLabel.textColor = textColor;
    self.scoreLabel.textColor = textColor;
    self.classroomNameLabel.textColor = textColor;
    self.teacherNameLabel.textColor = textColor;
    self.week.textColor = textColor;
    self.time.textColor = textColor;
    self.score.textColor = textColor;
    
    //字号
    UIFont *font1 = [UIFont fontWithName:@".PingFang SC" size: 15];
    UIFont *font2 = [UIFont fontWithName:@".PingFang SC" size: 13];
    
    self.lessonNameLabel.font = [UIFont fontWithName:@".PingFang SC" size: 22];
    self.weekRangeLabel.font = font1;
    self.classTimeLabel.font = font1;
    self.scoreLabel.font = font1;
    
    self.classroomNameLabel.font = font2;
    self.teacherNameLabel.font = font2;
    self.week.font = font2;
    self.time.font = font2;
    self.score.font = font2;
    
    //addsubView
    [self addSubview:self.lessonNameLabel];
    [self addSubview:self.weekRangeLabel];
    [self addSubview:self.classTimeLabel];
    [self addSubview:self.scoreLabel];
    [self addSubview:self.classroomNameLabel];
    [self addSubview:self.teacherNameLabel];
    [self addSubview:self.week];
    [self addSubview:self.time];
    [self addSubview:self.score];
    
    //给几个文字定死的label加字
    self.week.text = @"周期";
    self.time.text = @"时间";
    self.score.text = @"课程类型";
}

- (void)layoutSubviews{
    /// 加约束
    float h = MAIN_SCREEN_H*0.3281;
    [self.lessonNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.04*MAIN_SCREEN_W);
        make.top.equalTo(self).offset(0.0873*h);
    }];
    
    [self.classroomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.04*MAIN_SCREEN_W);
        make.top.equalTo(self).offset(0.2341*h);
    }];
    
    [self.week mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.04*MAIN_SCREEN_W);
    make.top.equalTo(self).offset(0.4048*h);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.04*MAIN_SCREEN_W);
        make.top.equalTo(self).offset(0.5833*h);
    }];
    
    [self.score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.04*MAIN_SCREEN_W);
        make.top.equalTo(self).offset(0.7619*h);
    }];
    
//___________________________________________________
    
    [self.teacherNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.classroomNameLabel.mas_right).offset(0.0747*MAIN_SCREEN_W);
        make.top.equalTo(self).offset(0.2341*h);
    }];
    
//___________________________________________________
    
    [self.weekRangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-0.04*MAIN_SCREEN_W);
        make.top.equalTo(self).offset(0.4048*h);
    }];
    
    [self.classTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-0.04*MAIN_SCREEN_W);
        make.top.equalTo(self).offset(0.5833*h);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-0.04*MAIN_SCREEN_W);
        make.top.equalTo(self).offset(0.7619*h);
    }];
}
//把@"一二节"转换为@"1-2节"、如果period==3，那么@"九十节"->@"9-11节"
- (NSString*)transformDataString:(NSString*)dataString withPeriod:(int)period{
    NSDictionary *tranfer = @{
        @"一二节":[NSString stringWithFormat:@"1-%d节",0+period],
        @"三四节":[NSString stringWithFormat:@"3-%d节",2+period],
        @"五六节":[NSString stringWithFormat:@"5-%d节",4+period],
        @"七八节":[NSString stringWithFormat:@"7-%d节",4+period],
        @"九十节":[NSString stringWithFormat:@"9-%d节",8+period],
    };
    return tranfer[dataString];
}
@end
//"begin_lesson" = 1;
//教室                                classroom = 2217;
//课程名称                        course = "高等数学A(下)";
//                                    "course_num" = A1110310;
//                                    day = "星期一";
//周几的课                        "hash_day" = 0;
//从第几节开始上                  "hash_lesson" = 0;
//                                    lesson = "一二节";
//这节课的时长                    period = 2;
//                                    rawWeek = "3-17周";
//                                    teacher = "邓志颖";
//                                    type = "必修";
//  那些周有课                    week =         (
//                                                            3,
//                                                          5,
//                                                            7,
//                                                            9,
//                                                            11,
//                                                            13,
//                                                            15,
//                                                            17
//                                                  );
//                                        weekBegin = 3;
//                                        weekEnd = 17;
//                                        weekModel = single;
