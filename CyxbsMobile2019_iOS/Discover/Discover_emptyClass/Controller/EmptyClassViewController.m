//
//  EmptyClassViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/13.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "EmptyClassViewController.h"
#import "LQButton.h"
#import "EmptyClassModel.h"
#import "StoreyResultView.h"
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define color242_243_248toFFFFFF [UIColor colorNamed:@"color242_243_248&#FFFFFF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define NUMBEROFWEEKS 13
#define BACKGROUNDCOLOR [UIColor colorWithRed:239/255.0 green:240/255.0 blue:247/255.0 alpha:1]
#define HIGHLIGHTCOLOR     [UIColor colorWithRed:221/255.0 green:227/255.0 blue:248/255.0 alpha:1]
@interface EmptyClassViewController ()
//选择部分
@property (nonatomic, copy)NSArray *floorArray;
@property (nonatomic)NSArray<UIButton*>* weekViewArray;
@property (nonatomic, weak)UIScrollView *numberOfWeekView;
@property int numberOfWeek;//第几周:从0开始

@property (nonatomic)NSArray<UIButton*>* weekDayArray;
@property (nonatomic, weak)UIView *weekDayView;
@property int weekDay;//周几：0-6表示周一到周日

@property (nonatomic, weak)UIView *answerView;//显示结果的View

@property (nonatomic)NSArray<LQButton*> *classArray;
@property (nonatomic, weak)UIView *classView;
@property int classTime;//第几节课：0-5表示 1,2节 到 11，12节
@property (nonatomic)NSMutableArray *allClassTimeChoose;//储存当前所点亮的按钮（哪几节课）

@property (nonatomic)NSArray<UIButton*>* buildArray;
@property (nonatomic, weak)UIView *buildView;
@property int build;//在几教的课：0,1,2,3,4 表示：2，3，4，5，8教学楼

@property (nonatomic, strong) EmptyClassModel *model;

//结果部分
@property (nonatomic) NSMutableArray<StoreyResultView*> *storeyViewArray;//里面装着每一层以及其空教室
@end

@implementation EmptyClassViewController
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:240/255.0 blue:247/255.0 alpha:1];
    self.navigationController.navigationBar.hidden = YES;
    [self addHorizontallyScrollView];//第几周
    [self addBackButton];//返回按钮的约束依赖于上面那个方法的结果
    [self addDayView];//第几天
    [self addAnswerView];//中间的数据展示View
    [self addBuildView];//几教
    [self addClassView];//第几节课
    
    // Do any additional setup after loading the view.
}
- (void)addBackButton {
    UIButton *backButton = [[UIButton alloc]init];
    [self.view addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"EmptyClassBackButton"] forState:UIControlStateNormal];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(17);
        make.centerY.equalTo(self.numberOfWeekView);
        make.width.equalTo(@9);
        make.height.equalTo(@19);
    }];
    [backButton addTarget:self action: @selector(back) forControlEvents:UIControlEventTouchUpInside];
}
- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
}
//MARK: 选择第几周
- (void) addHorizontallyScrollView {
    UIScrollView *numberOfWeekView = [[UIScrollView alloc]init];
    self.numberOfWeekView = numberOfWeekView;
    [self.view addSubview:numberOfWeekView];
    self.numberOfWeekView.showsHorizontalScrollIndicator = NO;
    self.numberOfWeekView.contentSize = CGSizeMake(NUMBEROFWEEKS * 56 + 3 * (NUMBEROFWEEKS - 1), 0);
    [numberOfWeekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(34);
        make.top.equalTo(self.view).offset(55);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(@30);
    }];
    numberOfWeekView.backgroundColor = BACKGROUNDCOLOR;
    NSMutableArray<UIButton*>* weekViewArray = [NSMutableArray array];
    for(int i = 0; i < NUMBEROFWEEKS; i++) {
        UIButton *button = [[UIButton alloc]init];
        if (@available(iOS 11.0, *)) {
            button.backgroundColor = BACKGROUNDCOLOR;
        } else {
            // Fallback on earlier versions
        }
        
        [weekViewArray addObject:button];
    }
    self.weekViewArray = weekViewArray;
    int flag = 0;//标记遍历到了第几个
    for (UIButton *buttonItem in self.weekViewArray) {
        [numberOfWeekView addSubview:buttonItem];
        //makeContraints
        if (buttonItem == self.weekViewArray[0]) {
            [buttonItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.numberOfWeekView);
                make.height.equalTo(@26);
                make.centerY.equalTo(self.numberOfWeekView);
                make.width.equalTo(@56);
            }];
        }else {
            [buttonItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.weekViewArray[flag-1].mas_right).offset(0);
                make.width.height.centerY.equalTo(self.weekViewArray[flag-1]);
            }];
        }
        flag++;
        //set text
        [buttonItem setTitle:[NSString stringWithFormat:@"第%d周",flag] forState:normal];
        if (@available(iOS 11.0, *)) {
            [buttonItem setTitleColor:Color21_49_91_F0F0F2 forState:normal];
        } else {
            // Fallback on earlier versions
        }
        //set highLight states
        buttonItem.titleLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
        buttonItem.layer.cornerRadius = 13;
        buttonItem.clipsToBounds = YES;
        [buttonItem addTarget:self action:@selector(chooseNumberOfWeek:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}
- (void)chooseNumberOfWeek: (UIButton*)sender {
    int i = 0;
    [sender setBackgroundColor:HIGHLIGHTCOLOR];
    sender.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:15];
    for (UIButton *button in self.weekViewArray) {
        if(sender == self.weekViewArray[i]) {
            self.numberOfWeek = i;
        }else {
            if (@available(iOS 11.0, *)) {
                [button setBackgroundColor:color242_243_248toFFFFFF];
            }
            button.titleLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];

        }
        i++;

    }
    [self getEmptyClassData];
    
}

//MARK: 选择周几
- (void) addDayView {
    UIView *weekDayView = [[UIView alloc]init];
    self.weekDayView = weekDayView;
    [self.view addSubview:weekDayView];
    [weekDayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.height.equalTo(self.numberOfWeekView);
        make.top.equalTo(self.numberOfWeekView.mas_bottom).offset(17);
    }];
    weekDayView.backgroundColor = BACKGROUNDCOLOR;
    NSMutableArray<UIButton*>* weekDayArray = [NSMutableArray array];
    for(int i = 0; i < 7; i++) {
        UIButton *button = [[UIButton alloc]init];
        if (@available(iOS 11.0, *)) {
            button.backgroundColor = color242_243_248toFFFFFF;
        } else {
            // Fallback on earlier versions
        }
        [weekDayArray addObject:button];
        
    }
    self.weekDayArray = weekDayArray;
    int flag = 0;//标记遍历到了第几个
    for (UIButton *buttonItem in self.weekDayArray) {
        [weekDayView addSubview:buttonItem];
        //makeContraints
        if (buttonItem == self.weekDayArray[0]) {
            [buttonItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.weekDayView);
                make.height.equalTo(@26);
                make.centerY.equalTo(self.weekDayView);
                make.width.equalTo(@56);
            }];
        }else {
               [buttonItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.weekDayArray[flag-1].mas_right).offset((self.view.width - 34 - 56 * weekDayArray.count)/ (weekDayArray.count - 1));
                   //34为zhegeView距离左边的距离，56为这个每一个button的宽度

                make.width.height.centerY.equalTo(self.weekDayArray[flag-1]);
            }];
        }
        flag++;
        //set text
        [buttonItem setTitle:[NSString stringWithFormat:@"周%d",flag] forState:normal];
        if (@available(iOS 11.0, *)) {
            [buttonItem setTitleColor:Color21_49_91_F0F0F2 forState:normal];
        } else {
            // Fallback on earlier versions
        }
        //set highLight states
        buttonItem.titleLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
        buttonItem.layer.cornerRadius = 13;
        buttonItem.clipsToBounds = YES;
        [buttonItem addTarget:self action:@selector(chooseWeekday:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}

- (void)chooseWeekday: (UIButton*)sender {
    int i = 0;
    [sender setBackgroundColor:HIGHLIGHTCOLOR];
    sender.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:15];
    for (UIButton *button in self.weekDayArray) {
        if(sender == self.weekDayArray[i]) {
            self.weekDay = i;
        }else {
            if (@available(iOS 11.0, *)) {
                [button setBackgroundColor:BACKGROUNDCOLOR];
            }
            button.titleLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
        }
        i++;

    }
    [self getEmptyClassData];
}
//MARK: 展示结果
- (void)addAnswerView {
    UIView * answerView = [[UIView alloc]init];
    self.answerView = answerView;
    answerView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    [self.view addSubview:answerView];
    [answerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.weekDayView.mas_bottom).offset(12);
    }];
    answerView.layer.cornerRadius = 16;
    answerView.layer.shadowOffset = CGSizeMake(0, 13);
    answerView.clipsToBounds = YES;
    self.storeyViewArray = [NSMutableArray array];
    NSArray *floorArray = @[@"一楼", @"二楼", @"三楼", @"四楼", @"五楼", @"六楼"];
    self.floorArray = floorArray;
    for(int i = 0 ; i < 6; i++) {
        StoreyResultView *view = [[StoreyResultView alloc]initWithStoreyString:floorArray[i]];
        [_storeyViewArray addObject:view];
        [self.answerView addSubview:view];
        if(view == self.storeyViewArray[0]) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.answerView);
                make.top.equalTo(self.answerView).offset(32);
                make.height.equalTo(@50);
            }];
        }else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.storeyViewArray[0]);
                make.height.equalTo(@50);
                make.top.equalTo(self.storeyViewArray[i - 1].mas_bottom).offset(27);
            }];
        }
    }
    
}
// MARK: 选择第几节课
- (void)addClassView {
    self.allClassTimeChoose = [NSMutableArray array];
    UIView *classView = [[UIView alloc]init];
       self.classView = classView;
       self.classView.layer.cornerRadius = 16;
    self.classView.layer.shadowOffset = CGSizeMake(0, 3);
       self.classView.clipsToBounds = YES;
       [self.answerView addSubview:classView];
       [self.
        classView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.left.equalTo(self.buildView);
           make.bottom.equalTo(self.buildView.mas_bottom).offset(-80);
           make.height.equalTo(@65);
       }];
       
    classView.backgroundColor = [UIColor whiteColor];
       NSMutableArray<LQButton*>* classArray = [NSMutableArray array];
       for(int i = 0; i < 6; i++) {
           LQButton *button = [[LQButton alloc]init];
           if (@available(iOS 11.0, *)) {
               button.backgroundColor = [UIColor whiteColor];
           } else {
               // Fallback on earlier versions
           }
           [classArray addObject:button];
           
       }
       self.classArray = classArray;
       int flag = 0;//标记遍历到了第几个
       for (LQButton *buttonItem in self.classArray) {
           [classView addSubview:buttonItem];
           //makeContraints
           if (buttonItem == self.classArray[0]) {
               [buttonItem mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.left.equalTo(self.classView).offset(15);
                   make.height.equalTo(@26);
                   make.centerY.equalTo(self.classView);
                   make.width.equalTo(@59);
               }];
           }else {
               [buttonItem mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.left.equalTo(self.classArray[flag-1].mas_right).offset((self.view.width - 15*2 - 59 * classArray.count)/ (classArray.count - 1));
                   make.width.height.centerY.equalTo(self.classArray[flag-1]);
               }];
           }
           
           flag++;
           //set text
           switch (flag) {
               case 1:
                   [self.classArray[flag-1] setTitle:@"1-2" forState:normal];
                   break;
               case 2:
                   [self.classArray[flag-1] setTitle:@"3-4" forState:normal];
                   break;
               case 3:
                   [self.classArray[flag-1] setTitle:@"5-6" forState:normal];
                   break;
               case 4:
                   [self.classArray[flag-1] setTitle:@"7-8" forState:normal];
                   break;
               case 5:
                   [self.classArray[flag-1] setTitle:@"9-10" forState:normal];
                   break;
               case 6:
                   [self.classArray[flag-1] setTitle:@"11-12" forState:normal];
 
               default:
                   break;
           }
           if (@available(iOS 11.0, *)) {
               [buttonItem setTitleColor:Color21_49_91_F0F0F2 forState:normal];
           } else {
               // Fallback on earlier versions
           }
           //set highLight states
           buttonItem.titleLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
           buttonItem.layer.cornerRadius = 13;
           buttonItem.clipsToBounds = YES;
           [buttonItem addTarget:self action:@selector(chooseClass:) forControlEvents:UIControlEventTouchUpInside];
       }
}
- (void)chooseClass: (LQButton*)sender {
    [sender choose];
    int i = 0;
    //遍历所有按钮将点亮的按钮添加到数组self.allClassTimeChoose
    for (LQButton *button in self.classArray) {
        if(sender == self.classArray[i]) {
            self.classTime = i;
        }
        if(button.isLight == YES && ![self.allClassTimeChoose containsObject:@(i)]) {
            [self.allClassTimeChoose addObject:@(self.classTime)];
        }else if(button.isLight == NO && [self.allClassTimeChoose containsObject:@(i)]) {
            [self.allClassTimeChoose removeObject:@(self.classTime)];
        }
        i++;

    }
    [self getEmptyClassData];
}





//MARK: 选择教学楼
- (void)addBuildView {
    UIView *buildView = [[UIView alloc]init];
    self.buildView = buildView;
    [self.answerView addSubview:buildView];
    [self.
     buildView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.answerView);
        make.height.equalTo(@100);
    }];
    
    buildView.backgroundColor = [UIColor whiteColor];
    NSMutableArray<UIButton*>* buildArray = [NSMutableArray array];
    for(int i = 0; i < 5; i++) {
        UIButton *button = [[UIButton alloc]init];
        if (@available(iOS 11.0, *)) {
            button.backgroundColor = [UIColor whiteColor];
        } else {
            // Fallback on earlier versions
        }
        [buildArray addObject:button];
        
    }
    self.buildArray = buildArray;
    int flag = 0;//标记遍历到了第几个
    for (UIButton *buttonItem in self.buildArray) {
        [buildView addSubview:buttonItem];
        //makeContraints
        if (buttonItem == self.buildArray[0]) {
            [buttonItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.buildView).offset(15);
                make.height.equalTo(@26);
                make.centerY.equalTo(self.buildView);
                make.width.equalTo(@59);
            }];
        }else {
                [buttonItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.buildArray[flag-1].mas_right).offset((self.view.width - 15*2 - 59 * buildArray.count)/ (buildArray.count - 1));
                make.width.height.centerY.equalTo(self.buildArray[flag-1]);
            }];
            
            
        }
        flag++;
        //set text
        switch (flag) {
            case 1:
                [self.buildArray[flag-1] setTitle:@"二教" forState:normal];
                break;
            case 2:
                [self.buildArray[flag-1] setTitle:@"三教" forState:normal];
                break;
            case 3:
                [self.buildArray[flag-1] setTitle:@"四教" forState:normal];
                break;
            case 4:
                [self.buildArray[flag-1] setTitle:@"五教" forState:normal];
                break;
            case 5:
                [self.buildArray[flag-1] setTitle:@"八教" forState:normal];
                break;
            default:
                break;
        }
        //set highLight states
        if (@available(iOS 11.0, *)) {
            [buttonItem setTitleColor:Color21_49_91_F0F0F2 forState:normal];
        } else {
            // Fallback on earlier versions
        }
        buttonItem.titleLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
        buttonItem.layer.cornerRadius = 13;
        buttonItem.clipsToBounds = YES;
        [buttonItem addTarget:self action:@selector(chooseBuild:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)chooseBuild: (UIButton*)sender {
    int i = 0;
    [sender setBackgroundColor:HIGHLIGHTCOLOR];
    sender.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:15];
    for (UIButton *button in self.buildArray) {
        if(sender == self.buildArray[i]) {
            self.build = i;
        }else {
            if (@available(iOS 11.0, *)) {
                [button setBackgroundColor:[UIColor whiteColor]];
            }
            button.titleLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
        }
        i++;

    }
    [self getEmptyClassData];
}



//MARK: 发送网络请求
- (void)getEmptyClassData {
    HttpClient *client = [HttpClient defaultClient];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //处理移动端后后端接口匹配问题
    switch (self.build) {
        case 0:
            [parameters setObject:@2 forKey:@"buildNum"];
            break;
        case 1:
            [parameters setObject:@3 forKey:@"buildNum"];
            break;
        case 2:
            [parameters setObject:@4 forKey:@"buildNum"];
            break;
        case 3:
            [parameters setObject:@5 forKey:@"buildNum"];
            break;
        case 4:
            [parameters setObject:@8 forKey:@"buildNum"];
            break;
        default:
            break;
    }
    [parameters setObject:@(self.weekDay + 1) forKey:@"weekDayNum"];
    [parameters setObject:@(self.numberOfWeek + 1) forKey:@"week"];
    NSMutableArray *allClassTimeChoose2 = [NSMutableArray array];//为了适应后端的参数，所以这里需要将参数进行简单处理后再发送
    
    for (NSNumber *sectionNum in _allClassTimeChoose) {
        [allClassTimeChoose2 addObject:@(sectionNum.intValue + 1)];
    }
    NSString*sectionNumParameters = [allClassTimeChoose2 componentsJoinedByString:@","];
    [parameters setObject:sectionNumParameters forKey:@"sectionNum"];
    NSLog(@"当前的参数是%@",parameters);
    [client requestWithPath:EMPTYCLASSAPI method:HttpRequestPost parameters:parameters prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        EmptyClassModel *model = [EmptyClassModel modelWithDictionary:responseObject];
        self.model = model;
        //更新UI
        [self clearUI];
        [self updateUI];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void) clearUI {
    for (StoreyResultView*view in _storeyViewArray) {
        [view clearUI];
    }
}
- (void)updateUI {
    NSLog(@"当前空闲教室有%@",_model.emptyClassArray);
    //数据过滤
    NSMutableArray *floor1Array = [NSMutableArray array];
    NSMutableArray *floor2Array = [NSMutableArray array];
    NSMutableArray *floor3Array = [NSMutableArray array];
    NSMutableArray *floor4Array = [NSMutableArray array];
    NSMutableArray *floor5Array = [NSMutableArray array];
    NSMutableArray *floor6Array = [NSMutableArray array];
    NSArray *floorArray = @[floor1Array, floor2Array, floor3Array, floor4Array, floor5Array, floor6Array];
    for (NSString *roomNum in self.model.emptyClassArray) {

        char floorNumChar = [[NSNumber numberWithUnsignedChar:[roomNum characterAtIndex:1]] intValue];
        NSString *floorNumStr = [NSString stringWithFormat:@"%c",floorNumChar];
        int floorNum = [floorNumStr intValue];
  
        switch (floorNum) {
            case 1: {
                [floor1Array addObject:roomNum];
            }
                break;
            case 2: {
                [floor2Array addObject:roomNum];
            }
                break;
            case 3: {
                [floor3Array addObject:roomNum];
            }
                break;
            case 4: {
                [floor4Array addObject:roomNum];
            }
                break;
            case 5: {
                [floor5Array addObject:roomNum];
            }
                break;
            case 6: {
                [floor6Array addObject:roomNum];
            }
                break;
            default:
                break;
        };
    }
    for(int i = 0; i < _storeyViewArray.count; i++) {
//        NSLog(@"所有楼层信息%@",floorArray);
        _storeyViewArray[i].StoreyArray = floorArray[i];
        [_storeyViewArray[i] refreshUI];
    }
    //当选择的教学楼为8教时，将“层”改为“栋”
    if(self.build == 4) {
        for(int i = 0 ; i < _storeyViewArray.count; i++) {
            switch (i) {
                case 0:
                    _storeyViewArray[i].storeyLabel.text = @"一栋";
                    break;
                case 1:
                    _storeyViewArray[i].storeyLabel.text = @"二栋";
                    break;
                case 2:
                    _storeyViewArray[i].storeyLabel.text = @"三栋";
                    break;
                default:
                    [_storeyViewArray[i] setHidden:YES];
                    break;
            }
        }
    }else {//否则就以楼的形式呈现
        for(int i = 0 ; i < _storeyViewArray.count; i++) {
            _storeyViewArray[i].storeyLabel.text = self.floorArray[i];
            [_storeyViewArray[i] setHidden:NO];
        }
    }
    //重新布局一下，隐藏那些没有空房间的splitView
    for (StoreyResultView*view in _storeyViewArray) {
        if([view.StoreyArray  isEqual: @[]]){//当这一层没有房间时
            [view setHidden:YES];
            //隐藏之后
        }else {
            [view setHidden:NO];
        }
    }

}
@end
