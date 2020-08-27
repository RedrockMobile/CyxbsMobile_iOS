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
        lable.numberOfLines = 3;
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
    if(self.isEmptyLesson==NO){
        //这个代理非空说明上一节课长度超过2，所以本节课的内容要显示到上一节课上面
        if(self.noteShowerDelegate!=nil){
            NSMutableArray *temp = [self.noteShowerDelegate.courseDataDictArray mutableCopy];
            [temp addObjectsFromArray:self.courseDataDictArray];
            self.noteShowerDelegate.courseDataDictArray = temp;
            [self.noteShowerDelegate setUpData];
            return;
        }
        //如果是有课，那么选取self.courseDataDictArray来设置这节课的位置、时长、view的frame
        self.courseDataDict = [self.courseDataDictArray firstObject];
        [self setFrameAndLessonLocationWithInfoDict:self.courseDataDict];
        [self setCourseInfoWithCourseDataDict:self.courseDataDict];
    }else if(self.isNoted==YES){
        
        NoteDataModel *model = [self.noteDataModelArray firstObject];
        if(self.noteShowerDelegate!=nil){
            //某课前面是长度为3或4的大课时，备忘信息将显示在noteShowerDelegate上
            //noteShowerDelegate设置为那节长度过长的大课
            [self.noteShowerDelegate.noteDataModelArray addObject:model];
            [self.noteShowerDelegate setUpData];
            self.noteShowerDelegate.isNoted = YES;
            return;
        }
        //如果是无课而有备忘，那么选取self.emptyClassDate来设置这节课的位置、时长、view的frame
        [self setFrameAndLessonLocationWithInfoDict:self.emptyClassDate];
        [self setNoteInfoWithNoteDataModel:model];
    }else{
        //如果是无课而无备忘，那么选取self.emptyClassDate来设置这节课的位置、时长、view的frame
        [self setFrameAndLessonLocationWithInfoDict:self.emptyClassDate];
        self.backgroundColor = UIColor.clearColor;
        self.titleLable = nil;
        self.detailLable = nil;
    }
    
    //如果自己的信息显示偏移代理非空，那么就说自己的前面有一节长度超过2的课，
    //那么自己就不要响应点击事件什么的，所以使self.hidden = YES;
    if(self.noteShowerDelegate!=nil)self.hidden = YES;
    
    if(self.isEmptyLesson==YES&&self.isNoted==YES){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNote) name:@"Mine_DisplayMemopadOFF" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNote) name:@"Mine_DisplayMemopadON" object:nil];
    }
    //根据备忘和课的总数判断是否显示提示view
    if(self.courseDataDictArray.count+self.noteDataModelArray.count>1){
        self.tipView.hidden = NO;
    }else{
        self.tipView.hidden = YES;
    }
    //是否在没课的地方显示备忘
    if(self.isEmptyLesson==YES&&![[NSUserDefaults standardUserDefaults] objectForKey:@"Mine_DisplayMemoPad"]&&self.isNoted==YES){
        [self hideNote];
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
    
    if (@available(iOS 11.0, *)) {
        self.titleLable.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
        self.detailLable.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        self.titleLable.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
        self.detailLable.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"条纹"]];
}

- (void)setFrameAndLessonLocationWithInfoDict:(NSDictionary*)infoDict{
    NSString *hash_day = infoDict[@"hash_day"];
       self.hash_day = [hash_day intValue];
       
       NSString *hash_lesson = infoDict[@"hash_lesson"];
       self.hash_lesson = [hash_lesson intValue];
       
       NSString *period = infoDict[@"period"];
       self.period = [period intValue];
       
    float h;
    if(self.period>3){
        h = self.period*LESSON_H +(self.period-2)/2*DISTANCE_H;
    }else{
        h = self.period*LESSON_H;
    }
       //对自己的frame更新：
       self.frame = CGRectMake(self.hash_day*(LESSON_W+DISTANCE_W), self.hash_lesson*(2*LESSON_H+DISTANCE_H), LESSON_W, h);
}

//self被点击后调用
- (void)viewTouched{
    
    if(self.isEmptyLesson==YES){
        //如果是空课且不是在个人课表页，那就return
        if(self.schType!=ScheduleTypePersonal)return;
        if(self.isNoted==NO){
            //空课且无备忘则加备忘
            [self.addNoteDelegate addNoteWithEmptyLessonData:self.emptyClassDate];
        }else{
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"Mine_DisplayMemoPad"]){
                self.delegate.courseDataDictArray = @[];
                self.delegate.noteDataModelArray = self.noteDataModelArray;
                [self.delegate showDetail];
            }else{
                
                [self.addNoteDelegate addNoteWithEmptyLessonData:self.emptyClassDate];
            }
            
        }
    }else{
        self.delegate.courseDataDictArray = self.courseDataDictArray;
        self.delegate.noteDataModelArray = self.noteDataModelArray;
        [self.delegate showDetail];
    }
}

- (UIView *)tipView{
    if(_tipView==nil){
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        _tipView = view;
        
        UIColor *color;
        
        if(self.isEmptyLesson==YES){
            if (@available(iOS 11.0, *)) {
                color = [UIColor colorNamed:@"42_78_132&235_242_251_dayBar_today"];
            } else {
                color = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1.0];
            }
        }else{
            switch (self.hash_lesson) {
                case 0:
                case 1:
                    if(@available(iOS 11.0, *)){
                        color = [UIColor colorNamed:@"ClassLabelColor1"];
                    }else{
                        color = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:21/255.0 alpha:1.0];
                    }
                    break;
                case 2:
                case 3:
                if(@available(iOS 11.0, *)){
                    color = [UIColor colorNamed:@"ClassLabelColor2"];
                }else{
                    color = [UIColor colorWithRed:255/255.0 green:98/255.0 blue:98/255.0 alpha:1.0];
                }
                break;
                default:
                    if(@available(iOS 11.0, *)){
                        color = [UIColor colorNamed:@"ClassLabelColor3"];
                    }else{
                        color = [UIColor colorWithRed:64/255.0 green:102/255.0 blue:234/255.0 alpha:1.0];
                    }
                    break;
            }
        }
        view.backgroundColor = color;
        view.layer.cornerRadius = 0.004*MAIN_SCREEN_W;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0.092*MAIN_SCREEN_W);
            make.top.equalTo(self).offset(0.012*MAIN_SCREEN_W);
            make.width.mas_equalTo(0.0213*MAIN_SCREEN_W);
            make.height.mas_equalTo(0.008*MAIN_SCREEN_W);
        }];
    }
    return _tipView;
}

- (void)showNote{
    self.titleLable.hidden =
    self.detailLable.hidden = NO;
    if(self.noteDataModelArray.count!=0){
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"条纹"]];
    }
    if(self.courseDataDictArray.count+self.noteDataModelArray.count>1){
        self.tipView.hidden = NO;
    }
}

- (void)hideNote{
    self.tipView.hidden =
    self.titleLable.hidden =
    self.detailLable.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
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
