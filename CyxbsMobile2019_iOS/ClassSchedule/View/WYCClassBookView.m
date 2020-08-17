//
//  WYCClassBookView.m
//  ChatBotTest
//
//  Created by 王一成 on 2018/8/29.
//  Copyright © 2018年 wyc. All rights reserved.
//

#import "WYCClassBookView.h"
#import "Masonry.h"
#import "WYCShowDetailView.h"
#import "DLReminderViewController.h"
#import "DayBarView.h"
#define LESSON_W (MAIN_SCREEN_W*0.1253)
#define LESSON_H (MAIN_SCREEN_H*0.06775)
@interface WYCClassBookView()<UIScrollViewDelegate,WYCShowDetailDelegate>

@property (nonatomic, strong) UIView *topBar;    //顶栏日期月份
@property (nonatomic, strong) UIView *leftBar;   //左边栏课数
@property (nonatomic, strong) UIView *month;
@property (nonatomic, strong) UIView *dayBar;
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) WYCShowDetailView *detailClassBookView;
@property (nonatomic, strong) NSArray *classBookData;  //课表数据
@property (nonatomic, strong) NSArray *noteData;  //备忘数据
@property (nonatomic, strong) NSMutableArray *detailDataArray;  //详细信息，每个btn包含多个信息
@property (nonatomic, assign) NSInteger classCount;  //课数
@property (nonatomic, assign) NSInteger noteCount;  //备忘数
@property (nonatomic, assign) CGFloat btnWidth;
@property (nonatomic, assign) CGFloat btnHeight;
@property (nonatomic, assign) NSInteger classNum;
@property (nonatomic, strong) UIButton *backButton;



@end
@implementation WYCClassBookView

-(void)initViewIsFirst:(BOOL)isFirst{
    
//    self.backgroundColor = [UIColor whiteColor];
    
    
    _month = [[UIView alloc]init];
    if (@available(iOS 11.0, *)) {
               _month.backgroundColor = [UIColor colorNamed:@"peopleListViewBackColor"];
           } else {
               _month.backgroundColor = [UIColor clearColor];
           }
   
    
    _dayBar = [[UIView alloc]init];
    if (@available(iOS 11.0, *)) {
        _dayBar.backgroundColor = [UIColor colorNamed:@"peopleListViewBackColor"];
    } else {
        _dayBar.backgroundColor = [UIColor clearColor];
    }
   
    
    _topBar = [[UIView alloc]init];
    if (@available(iOS 11.0, *)) {
           _topBar.backgroundColor = [UIColor redColor];
       } else {
           _topBar.backgroundColor = [UIColor clearColor];
       }
  
    
    [_topBar addSubview:_month];
    [_topBar addSubview:_dayBar];
    
    [self addSubview:_topBar];
    
    _rootView = [[UIView alloc]init];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
             _scrollView.backgroundColor = [UIColor colorNamed:@"peopleListViewBackColor"];
         } else {
            _scrollView.backgroundColor = [UIColor whiteColor];
         }
    _scrollView.scrollEnabled = YES;
    
    _scrollView.contentSize = CGSizeMake(0,680*autoSizeScaleY);
    _scrollView.delegate = self;
    
    [_rootView addSubview:_scrollView];
    [self addSubview:_rootView];
    
    _leftBar = [[UIView alloc]init];
    _backButton.frame = CGRectMake(20, 60, 50, 30);
    [_backButton setTitle:@"back" forState:UIControlStateNormal];
    [_backButton setTintColor:[UIColor blueColor]];
    [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_topBar addSubview:_backButton];
    if (@available(iOS 11.0, *)) {
        _leftBar.backgroundColor = [UIColor colorNamed:@"peopleListViewBackColor"];
    } else {
       _leftBar.backgroundColor = [UIColor whiteColor];
    }
    
    [_scrollView addSubview: _leftBar];
   
    
    [_month mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_topBar.mas_top).offset(0);
        make.left.equalTo(self->_topBar.mas_left).offset(0);
        make.bottom.equalTo(self->_topBar.mas_bottom).offset(0);
        make.width.mas_equalTo(31*autoSizeScaleX);
        
    }];
    
    [_dayBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_topBar.mas_top).offset(0);
        make.left.equalTo(self->_month.mas_right).offset(0);
        make.bottom.equalTo(self->_topBar.mas_bottom).offset(0);
        make.right.equalTo(self->_topBar.mas_right).offset(0);
        
    }];
    
    [_topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(49*autoSizeScaleY);
        
    }];
    
    
    [_rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_topBar.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_rootView.mas_top).offset(0);
        make.left.equalTo(self->_rootView.mas_left).offset(0);
        make.right.equalTo(self->_rootView.mas_right).offset(0);
        make.bottom.equalTo(self->_rootView.mas_bottom).offset(0);
        
    }];

    [_leftBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_scrollView.mas_top).offset(0);
        make.left.equalTo(self->_scrollView.mas_left).offset(0);
        make.height.mas_equalTo(606*autoSizeScaleY);
        make.width.mas_equalTo(31*autoSizeScaleX);
        
    }];
    
}
-(void)backButtonClicked{
    NSLog(@"The Button is clicked");
}

-(void)addBar:(NSArray *)date isFirst:(BOOL)isFirst{
    if(isFirst==YES)return;
    DayBarView *dayBarView = [[DayBarView alloc] initWithDataArray:date];
    [self addSubview:dayBarView];
    [dayBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBar);
        make.top.equalTo(_topBar);
        make.right.equalTo(_topBar);
        make.bottom.equalTo(_topBar);
    }];
//    _topBar.backgroundColor = UIColor.redColor;
}
//用户课表和同学课表页面的课表显示，要调用这个方法
- (void)addBtn:(NSMutableArray *)day{
    self.schedulData = day;
    @autoreleasepool {
        [_dayBar layoutIfNeeded];
        [_leftBar layoutIfNeeded];
        
        _classNum = 0;
        self.detailDataArray = [[NSMutableArray alloc]init];
        for (int dayNum = 0; dayNum < 7; dayNum++) {
            for (int lessonNum = 0; lessonNum < 6; lessonNum++) {
                //day[dayNum][lessonNum]代表（星期dayNum+1）的（第lessonNum+1节大课）有几节课。
                NSArray *tmp = day[dayNum][lessonNum];
                //课数不等于0，就添加
                if (tmp.count != 0) {
                    [self.detailDataArray addObject:tmp];
                    //@"id"用来区别是课表还是备忘
                    if ([tmp[0] objectForKey:@"id"]) {
                        [self addNoteBtn:tmp];
                    }else{
                        [self addClassBtn:tmp];
                    }
                }else{//否则添加备忘按钮
                    UIButton *btn = [[UIButton alloc] init];
                    btn.backgroundColor = UIColor.clearColor;
                    [self.scrollView addSubview:btn];
                     [btn addTarget:self action:@selector(blankSpaceClicked) forControlEvents:UIControlEventTouchUpInside];
                    float btnW = _dayBar.frame.size.width/7;
                    float btnH =  50.5*autoSizeScaleY;
                     [btn setFrame:(CGRectMake(self.leftBar.width+dayNum*btnW,2*lessonNum*btnH , btnW, 2*btnH))];
                }
            }
        }
    }
}

//没课约页面的课表显示，要调用这个方法
- (void)addBtnForWedate:(NSMutableArray *)day{
    self.schedulData = day;
    @autoreleasepool {
        [_dayBar layoutIfNeeded];
        [_leftBar layoutIfNeeded];
        
        _classNum = 0;
        self.detailDataArray = [[NSMutableArray alloc]init];
        for (int dayNum = 0; dayNum < 7; dayNum++) {
            for (int lessonNum = 0; lessonNum < 6; lessonNum++) {
                NSArray *tmp = day[dayNum][lessonNum];
                if (tmp.count==0) {
                    //array233是根据addClassBtn:里面需要的参数手动模拟出的
                    //用array233作为参数，而不是直接用tmp作为参数可以避免同一位置出现多张课表
                    NSArray *array233 =  @[
                            @{
                                @"begin_lesson" : @1,
                                @"classroom" : @"",
                                @"course" : @"无课",
                                @"course_num" : @"A1110020",
                                @"day" : @"星期",
                                @"hash_day" :[NSNumber numberWithInt:dayNum],
                                @"hash_lesson" : [NSNumber numberWithInt:lessonNum],
                                @"lesson" : @"lesson",
                                @"period" : @2,
                                @"rawWeek" : @"rawWeek",
                                @"teacher" : @"teacher",
                                @"type" : @"type",
                                @"week" :  @[
                                    @2,
                                    @5,
                                ],
                                @"weekBegin" : @2,
                                @"weekEnd" : @17,
                                @"weekModel" : @"all",
                        }
                    ];
                    [self addClassBtn:array233];
                }
            }
        }
        
    }
}
//点击了没有课的空白处后调用
- (void)blankSpaceClicked{
    DLReminderViewController *re = [[DLReminderViewController alloc] init];
    self.viewController.tabBarController.tabBar.hidden = YES;
    [self.viewController.navigationController pushViewController:re animated:YES];
}

- (void)addClassBtn:(NSArray *)tmp{
    
    NSNumber *hash_day = [tmp[0] objectForKey:@"hash_day"];
    NSNumber *hash_lesson = [tmp[0] objectForKey:@"hash_lesson"];
    NSNumber *period = [tmp[0] objectForKey:@"period"];
    UIColor *viewColor = [[UIColor alloc]init];
    if (hash_lesson.integerValue<2) {
        if (@available(iOS 11.0, *)) {
            viewColor = [UIColor colorNamed:@"hash_lesson.integerValue<2"];
        } else {
            // Fallback on earlier versions
             viewColor = [UIColor colorWithRed:249/255.0 green:231/255.0 blue:216/255.0 alpha:1.0];
        }
       
    }else if(hash_lesson.integerValue>=2&&hash_lesson.integerValue<4){
        if (@available(iOS 11.0, *)) {
                   viewColor = [UIColor colorNamed:@"hash_lesson.integerValue>=2&&hash_lesson.integerValue<4"];
               } else {
                   // Fallback on earlier versions
                    viewColor = [UIColor colorWithRed:249/255.0 green:227/255.0 blue:228/255.0 alpha:1.0];
               }
    }else{
        if (@available(iOS 11.0, *)) {
            viewColor = [UIColor colorNamed:@"hash_lesson.integerValue>4"];
        } else {
            // Fallback on earlier versions
              viewColor = [UIColor colorWithRed:221/255.0 green:227/255.0 blue:248/255.0 alpha:1.0];
        }
    }
    _btnWidth = _dayBar.frame.size.width/7;
    _btnHeight =  50.5*autoSizeScaleY*period.integerValue;
    UIView *btnView = [[UIView alloc]init];
    [btnView setFrame:CGRectMake(_leftBar.frame.size.width +  hash_day.integerValue*_btnWidth, hash_lesson.integerValue*101*autoSizeScaleY, _btnWidth, _btnHeight)];
    [btnView layoutIfNeeded];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(1, 1, _btnWidth-2, _btnHeight-2)];
    backgroundView.backgroundColor = viewColor;
    backgroundView.layer.cornerRadius = 6.0 ;
    [backgroundView layoutIfNeeded];
    if (tmp.count<1) {
        UIView *blankBtnView = [[UIView alloc]init];
        [blankBtnView setFrame:CGRectMake(_leftBar.frame.size.width +  hash_day.integerValue*_btnWidth, hash_lesson.integerValue*101*autoSizeScaleY, _btnWidth, _btnHeight)];
        [blankBtnView layoutIfNeeded];
        [blankBtnView addSubview:backgroundView];
    }
     //如果同一个位置有多个课，添加小三角
    if (tmp.count>1) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(backgroundView.width - 10, 2, 8, 8)];
        img.image = [UIImage imageNamed:@"triangle"];
        [backgroundView addSubview:img];
    }
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor clearColor];
    btn.layer.cornerRadius = 4.0 ;
    btn.tag = _classNum;
    _classNum++;
    [btn setFrame:CGRectMake(0, 0, _btnWidth-2, _btnHeight-2)];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *classRoomNumLabel = [[UILabel alloc]init];
    [classRoomNumLabel setFrame:CGRectMake(0, btn.frame.size.height-20, btn.frame.size.width, 10)];
    classRoomNumLabel.text = [NSString stringWithFormat:@"%@", [tmp[0] objectForKey:@"classroom"]];
    
    classRoomNumLabel.textAlignment = NSTextAlignmentCenter;
    if (hash_lesson.integerValue<2) {
        if (@available(iOS 11.0, *)) {
            classRoomNumLabel.textColor = [UIColor colorNamed:@"ClassLabelColor1"];
            classRoomNumLabel.alpha = 1.0;
        } else {
            // Fallback on earlier versions
            classRoomNumLabel.textColor = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:21/255.0 alpha:1.0];
                   classRoomNumLabel.alpha = 1.0;
        }
       
    }else if(hash_lesson.integerValue>=2&&hash_lesson.integerValue<4)
    {
        if (@available(iOS 11.0, *)) {
            classRoomNumLabel.textColor = [UIColor colorNamed:@"ClassLabelColor2"];
            classRoomNumLabel.alpha = 1.0;
        } else {
            // Fallback on earlier versions
             classRoomNumLabel.textColor = [UIColor colorWithRed:255/255.0 green:98/255.0 blue:98/255.0 alpha:1.0];
                   classRoomNumLabel.alpha = 1.0;
        }
    }else{
        if (@available(iOS 11.0, *)) {
                   classRoomNumLabel.textColor = [UIColor colorNamed:@"ClassLabelColor3"];
                   classRoomNumLabel.alpha = 1.0;
               } else {
                   // Fallback on earlier versions
                      classRoomNumLabel.textColor =[UIColor colorWithRed:64/255.0 green:102/255.0 blue:234/255.0 alpha:1.0];
                          classRoomNumLabel.alpha = 1.0;
               }
    }
    classRoomNumLabel.font = [UIFont systemFontOfSize:12];
    
    UILabel *classNameLabel = [[UILabel alloc]init];
    CGFloat classNameLabelHeight = [self calculateRowHeight:[NSString stringWithFormat:@"%@", [tmp[0] objectForKey:@"course"]] fontSize:12 width:btn.frame.size.width - 10];
    if (classNameLabelHeight > btn.frame.size.height-30) {
        classNameLabelHeight = btn.frame.size.height-30;
    }
    
    [classNameLabel setFrame:CGRectMake(5, 9, btn.frame.size.width - 10, classNameLabelHeight)];
    classNameLabel.text = [NSString stringWithFormat:@"%@", [tmp[0] objectForKey:@"course"]];
    classNameLabel.textAlignment = NSTextAlignmentCenter;
    if (hash_lesson.integerValue<2) {
        if (@available(iOS 11.0, *)) {
            classNameLabel.textColor = [UIColor colorNamed:@"ClassLabelColor1"];
            classNameLabel.alpha = 1.0;
        } else {
            // Fallback on earlier versions
           classNameLabel.textColor = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:21/255.0 alpha:1.0];
            classNameLabel.alpha = 1.0;
        }
    }else if (hash_lesson.integerValue>=2&&hash_lesson.integerValue<4){
        if (@available(iOS 11.0, *)) {
            classNameLabel.textColor = [UIColor colorNamed:@"ClassLabelColor2"];
            classNameLabel.alpha = 1.0;
        } else {
            // Fallback on earlier versions
             classNameLabel.textColor = [UIColor colorWithRed:255/255.0 green:98/255.0 blue:98/255.0 alpha:1.0];
             classNameLabel.alpha = 1.0;
        }
    }else{
        if (@available(iOS 11.0, *)) {
            classNameLabel.textColor = [UIColor colorNamed:@"ClassLabelColor3"];
            classNameLabel.alpha = 1.0;
        } else {
            // Fallback on earlier versions
              classNameLabel.textColor =[UIColor colorWithRed:64/255.0 green:102/255.0 blue:234/255.0 alpha:1.0];
               classNameLabel.alpha = 1.0;
        }
    }
    classNameLabel.font = [UIFont systemFontOfSize:12];
    [classNameLabel setNumberOfLines:0];
    classNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    [btn addSubview:classRoomNumLabel];
    [btn addSubview:classNameLabel];
    
    [backgroundView addSubview:btn];
    
    [btnView addSubview:backgroundView];
    [_scrollView addSubview:btnView];
    
}

- (void)addNoteBtn:(NSArray *)tmp{
    
    NSNumber *hash_day = [tmp[0] objectForKey:@"hash_day"];
    NSNumber *hash_lesson = [tmp[0] objectForKey:@"hash_lesson"];
    UIColor *viewColor = [[UIColor alloc]init];
    viewColor = [UIColor colorWithHexString:@"#E8F0FC"];
   
    _btnWidth = _dayBar.frame.size.width/7;
    _btnHeight =  101*autoSizeScaleY;
    UIView *btnView = [[UIView alloc]init];
    [btnView setFrame:CGRectMake(_leftBar.frame.size.width +  hash_day.integerValue*_btnWidth, hash_lesson.integerValue*101*autoSizeScaleY, _btnWidth, _btnHeight)];
    [btnView layoutIfNeeded];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(1, 1, _btnWidth-2, _btnHeight-2)];
    backgroundView.backgroundColor = viewColor;
    backgroundView.layer.cornerRadius = 4.0 ;
    [backgroundView layoutIfNeeded];
    //如果同一个位置有多个课，添加小三角
    if (tmp.count>1) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(backgroundView.width - 10, 2, 8, 8)];
        img.image = [UIImage imageNamed:@"triangle"];
        [backgroundView addSubview:img];
    }
    
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor clearColor];
    btn.layer.cornerRadius = 4.0 ;
    btn.tag = _classNum;
    _classNum++;
    [btn setFrame:CGRectMake(0, 0, _btnWidth-2, _btnHeight-2)];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [titleLabel setFrame:CGRectMake(0, 9, btn.frame.size.width, 10)];
    titleLabel.text = [NSString stringWithFormat:@"%@", [tmp[0] objectForKey:@"title"]];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    CGFloat contentLabelHeight = [self calculateRowHeight:[NSString stringWithFormat:@"%@", [tmp[0] objectForKey:@"content"]] fontSize:12 width:btn.frame.size.width - 10];
    if (contentLabelHeight > btn.frame.size.height-30) {
        contentLabelHeight = btn.frame.size.height-30;
    }
    
    [contentLabel setFrame:CGRectMake(5, 30, btn.frame.size.width - 10, contentLabelHeight)];
    contentLabel.text = [NSString stringWithFormat:@"%@", [tmp[0] objectForKey:@"content"]];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    contentLabel.font = [UIFont systemFontOfSize:12];
    [contentLabel setNumberOfLines:0];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    [btn addSubview:titleLabel];
    [btn addSubview:contentLabel];
    
    [backgroundView addSubview:btn];
    
    [btnView addSubview:backgroundView];
    [_scrollView addSubview:btnView];
}

- (void)clickBtn:(UIButton *)sender{
    if ([self.detailDelegate respondsToSelector:@selector(showDetail:)]) {
        //调用代理的方法，把btn的详细信息传入
        [self.detailDelegate showDetail:self.detailDataArray[sender.tag]];
    }
    NSLog(@"dayin");
}

- (void)hiddenDetailView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [window viewWithTag:999];
    [view removeFromSuperview];
}

- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize width:(CGFloat)width{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

- (void)changeScrollViewContentSize:(CGSize)contentSize{
    _scrollView.contentSize = contentSize;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_scrollView.contentOffset.y < -100) {
        //下拉刷新
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadView" object:nil];
    }
}

@end
