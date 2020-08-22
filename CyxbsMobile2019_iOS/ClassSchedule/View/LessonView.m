//
//  LessonView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "LessonView.h"
@interface LessonView()

/// 课程名称
@property(nonatomic,strong)UILabel *titleLable;

/// 教室名
@property(nonatomic,strong)UILabel *detailLable;

/// 课程时长
@property(nonatomic,assign)int period;

/// 周几的课，hash_day=3代表周四
@property(nonatomic,assign)int hash_day;

/// 第几节大课，hash_lesson=2代表第3节大课，也就是5-6节
@property(nonatomic,assign)int hash_lesson;



/// 提醒是只有一节课还是有多节课
@property(nonatomic,strong)UIView *tipView;
@end
@implementation LessonView

- (instancetype)init{
    self = [super init];
    if(self){
        self.layer.cornerRadius = 8;
        [self addTipView];
        self.noteDataModelArray = [NSMutableArray array];
        UITapGestureRecognizer *TGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTouched)];
        [self addGestureRecognizer:TGR];
    }
    return self;
}
- (UILabel *)titleLable{
    if(_titleLable==nil){
        UILabel *lable = [[UILabel alloc] init];
        _titleLable = lable;
        lable.font = [UIFont fontWithName:PingFangSCRegular size: 11];
        lable.numberOfLines = 4;
        [self addSubview:lable];
        [lable setTextAlignment:(NSTextAlignmentCenter)];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(self.frame.size.height*0.0727);
            make.width.equalTo(self).multipliedBy(0.7234);
        }];
    }
    return _titleLable;
}
- (UILabel *)detailLable{
    if(_detailLable==nil){
        UILabel *lable = [[UILabel alloc] init];
        _detailLable = lable;
        lable.font = [UIFont fontWithName:PingFangSCRegular size: 11];
        lable.numberOfLines = 3;
        [self addSubview:lable];
        [lable setTextAlignment:(NSTextAlignmentCenter)];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-self.frame.size.height*0.0455);
            make.width.equalTo(self).multipliedBy(0.7234);
        }];
    }
    return _detailLable;
}

/// 更新显示的课表数据，调用前需确保已经对self.courseDataDict进行更新、且已经调用了setUpUI
- (void)setUpData{
    //根据备忘和课的总数判断是否显示提示view
    if(self.courseDataDictArray.count+self.noteDataModelArray.count>1){
        self.tipView.hidden = NO;
    }else{
        self.tipView.hidden = YES;
    }
    
    if(self.isEmptyLesson==NO){
        //如果是有课，那么选取self.courseDataDictArray来设置这节课的位置、时长、view的frame
        self.courseDataDict = [self.courseDataDictArray firstObject];
        [self setFrameAndLessonLocationWithInfoDict:self.courseDataDict];
        [self setCourseInfoWithCourseDataDict:self.courseDataDict];
    }else if(self.isNoted==YES){
        //如果是无课而有备忘，那么选取self.emptyClassDate来设置这节课的位置、时长、view的frame
        [self setFrameAndLessonLocationWithInfoDict:self.emptyClassDate];
        NoteDataModel *model = [self.noteDataModelArray firstObject];
        [self setNoteInfoWithNoteDataModel:model];
    }else{
        //如果是无课而无备忘，那么选取self.emptyClassDate来设置这节课的位置、时长、view的frame
        [self setFrameAndLessonLocationWithInfoDict:self.emptyClassDate];
        self.backgroundColor = UIColor.clearColor;
        self.titleLable = nil;
        self.detailLable = nil;
    }
    
    if(self.noteDataModelArray.count+self.courseDataDictArray.count>1){
        self.tipView.hidden = NO;
    }else{
        self.tipView.hidden = YES;
    }
}
///调用后会设置titleLabe的文字为课程名称，detailLabel的文字为教室地点，背景颜色，字体
- (void)setCourseInfoWithCourseDataDict:(NSDictionary*)courseDataDict{
    //根据self.courseDataDict对子控件的数据更新：
    self.titleLable.text = courseDataDict[@"course"];
    self.detailLable.text = courseDataDict[@"classroom"];
    UIColor *textColor;
    if(self.isEmptyLesson==YES){self.backgroundColor = [UIColor clearColor];}else{
        switch (self.hash_lesson) {
            case 0:
            case 1:
                if(@available(iOS 11.0, *)){
                    self.backgroundColor = [UIColor colorNamed:@"hash_lesson.integerValue<2"];
                    textColor = [UIColor colorNamed:@"ClassLabelColor1"];
                }else{
                    self.backgroundColor = [UIColor colorWithRed:249/255.0 green:231/255.0 blue:216/255.0 alpha:1.0];
                    textColor = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:21/255.0 alpha:1.0];
                }
                break;
                
                
            case 2:
            case 3:
            if(@available(iOS 11.0, *)){
                self.backgroundColor = [UIColor colorNamed:@"hash_lesson.integerValue>=2&&hash_lesson.integerValue<4"];
                textColor = [UIColor colorNamed:@"ClassLabelColor2"];
            }else{
                self.backgroundColor = [UIColor colorWithRed:249/255.0 green:227/255.0 blue:228/255.0 alpha:1.0];
                textColor = [UIColor colorWithRed:255/255.0 green:98/255.0 blue:98/255.0 alpha:1.0];
            }
            break;
            
                
            default:
                if(@available(iOS 11.0, *)){
                    self.backgroundColor = [UIColor colorNamed:@"hash_lesson.integerValue>4"];
                    textColor = [UIColor colorNamed:@"ClassLabelColor3"];
                }else{
                    self.backgroundColor = [UIColor colorWithRed:221/255.0 green:227/255.0 blue:248/255.0 alpha:1.0];
                    textColor = [UIColor colorWithRed:64/255.0 green:102/255.0 blue:234/255.0 alpha:1.0];
                }
                break;
        }
    }
    self.titleLable.textColor = textColor;
    self.detailLable.textColor = textColor;
}
///调用后会设置titleLabe的文字为备忘标题，detailLabel的文字为备忘详情，背景颜色，字体
- (void)setNoteInfoWithNoteDataModel:(NoteDataModel*)model{
    if(model==nil)return;
    
    self.titleLable.text = model.noteTitleStr;
    self.detailLable.text = model.noteDetailStr;
    
    //加备忘、删备忘、修改备忘、第一次加载
    //      移除model+reload
    self.backgroundColor = UIColor.clearColor;
    
    if (@available(iOS 11.0, *)) {
        self.titleLable.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
        self.detailLable.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        self.titleLable.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
        self.detailLable.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
}
- (void)setFrameAndLessonLocationWithInfoDict:(NSDictionary*)infoDict{
    NSString *hash_day = infoDict[@"hash_day"];
       self.hash_day = [hash_day intValue];
       
       NSString *hash_lesson = infoDict[@"hash_lesson"];
       self.hash_lesson = [hash_lesson intValue];
       
       NSString *period = infoDict[@"period"];
       self.period = [period intValue];
       
       //对自己的frame更新：
       self.frame = CGRectMake(self.hash_day*(LESSON_W+DISTANCE_W), self.hash_lesson*(2*LESSON_H+DISTANCE_H), LESSON_W, self.period*LESSON_H);
}

//self被点击后调用
- (void)viewTouched{
    
    if(self.isEmptyLesson==YES){
        
        if(self.isNoted==NO){
            
            [self.addNoteDelegate addNoteWithEmptyLessonData:self.emptyClassDate];
        }else{
            self.delegate.courseDataDictArray = @[];
            self.delegate.noteDataModelArray = self.noteDataModelArray;
            [self.delegate showDetail];
        }
    }else{
        
        self.delegate.courseDataDictArray = self.courseDataDictArray;
        self.delegate.noteDataModelArray = self.noteDataModelArray;
        [self.delegate showDetail];
    }
}

- (void)addTipView{
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    self.tipView = view;
    
    if (@available(iOS 11.0, *)) {
        view.backgroundColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        view.backgroundColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    view.hidden = YES;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.092*MAIN_SCREEN_W);
        make.top.equalTo(self).offset(0.012*MAIN_SCREEN_W);
        make.width.mas_equalTo(0.0213*MAIN_SCREEN_W);
        make.height.mas_equalTo(0.008*MAIN_SCREEN_W);
    }];
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
