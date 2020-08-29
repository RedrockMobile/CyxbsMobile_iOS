//
//  FinderView.m
//  testForLargeTitle
//
//  Created by 千千 on 2019/10/22.
//  Copyright © 2019 千千. All rights reserved.
//

#import "FinderView.h"
#import <SDCycleScrollView.h>
#import "URLController.h"
#import "WeekAndDay.h"

#define PingFangSC @".PingFang SC"
#define Gap 17                   //控件距离两边的距离
#define EnterButtonWidth 38      //首页的几个入口的按钮的宽度

#define color21_49_91_F2F4FF [UIColor colorNamed:@"color21_49_91_&#F2F4FF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface FinderView()<SDCycleScrollViewDelegate>
@property NSUserDefaults *defaults;
@property (nonatomic, weak)SDCycleScrollView *cycleScrollView;
@end
@implementation FinderView
//MARK: - 初始化部分
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"ColorBackground" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
        } else {
            // Fallback on earlier versions
        }
        self.bannerURLStrings = [NSMutableArray array];
        [self configUserDefaults];
        [self addWeekTimeLabel];
        [self addFinderTitle];
        [self addWriteButton];
        [self addBannerView];
        [self addNewsSender];
        [self addNews];
        [self addSomeEnters];
    }
    return self;
}

- (void)configUserDefaults {
    self.defaults = [NSUserDefaults standardUserDefaults];
}
//MARK: - 添加子控件部分
- (void) addWeekTimeLabel {
    UILabel *weekTimeLabel = [[UILabel alloc]init];
    self.weekTime = weekTimeLabel;
    NSString *weekNum = [WeekAndDay defaultWeekDay].weekNumber;
    NSString *weekday = [WeekAndDay defaultWeekDay].weekday;
    weekTimeLabel.text =[NSString stringWithFormat:@"第%@周，周%@",weekNum,weekday];
    
    if ([weekNum isEqual: @"0"]) {
        weekTimeLabel.text =[NSString stringWithFormat:@"欢迎新同学～"];
    }
//    weekTimeLabel.text = @"";
    if (@available(iOS 11.0, *)) {
        [weekTimeLabel setTextColor:[UIColor colorNamed:@"QANavigationTitleColor"]];
    } else {
        [weekTimeLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    }
    weekTimeLabel.font = [UIFont fontWithName:PingFangSCLight size: 10];
    [self addSubview:weekTimeLabel];
    
}
- (void) addFinderTitle {
    UILabel *finderTitle = [[UILabel alloc]init];
    self.finderTitle = finderTitle;
    finderTitle .text = @"发现";
    finderTitle.font = [UIFont fontWithName:PingFangSCBold size: 34];
    if (@available(iOS 11.0, *)) {
        finderTitle.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    }
    [self addSubview:finderTitle];
}
- (void) addWriteButton {
    UIButton *writeButton = [[UIButton alloc]init];
    self.writeButton = writeButton;
    [writeButton addTarget:self action:@selector(touchWriteButton) forControlEvents:UIControlEventTouchUpInside];
    writeButton.contentMode = UIViewContentModeScaleToFill;
    writeButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [writeButton setImage:[UIImage imageNamed:@"writeDiscover"] forState:normal];
    [self addSubview:writeButton];
}
- (void) addBannerView {

    NSArray *imagesURLStrings = self.bannerURLStrings;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"Discover_placeholder"]];
    self.bannerView = cycleScrollView;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView.clipsToBounds = YES;
    cycleScrollView.layer.cornerRadius = 15;
    cycleScrollView.layer.shadowColor = [UIColor blackColor].CGColor;
    cycleScrollView.layer.shadowOpacity = 0.33f;
    cycleScrollView.layer.shadowColor = [UIColor colorWithRed:140/255.0 green:150/255.0 blue:217/255.0 alpha:1].CGColor;
    cycleScrollView.autoScrollTimeInterval = 3;

    cycleScrollView.layer.shadowOffset = CGSizeMake(0, 3);
    self.cycleScrollView = cycleScrollView;
    [self addSubview:cycleScrollView];
    
}
-(void)updateBannerViewIfNeeded {
    [self.cycleScrollView removeFromSuperview];
    [self addBannerView];
}
- (void) addNewsSender {
    UIButton *button = [[UIButton alloc]init];
    self.newsSender = button;
    [button addTarget:self action:@selector(touchNewsSender) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"教务在线" forState:normal];
    button.titleLabel.textColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        [button setBackgroundImage:[UIImage imageNamed:@"教务在线背景"] forState:normal];
        [button setTitleColor:[UIColor colorNamed:@"whiteColor" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] forState:normal];
    }
    button.titleLabel.font = [UIFont fontWithName:PingFangSCBold size: 11];
    
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:button];
}
- (void) addNews {
    UIButton *newsButton = [[UIButton alloc]init];
    self.news = newsButton;
    NSString *title = [self.defaults objectForKey:@"OneNews_oneNews"];

    [newsButton setTitle: title forState:normal];
    if (@available(iOS 11.0, *)) {
        [newsButton setTitleColor:color21_49_91_F2F4FF forState:normal];
    }
    newsButton.titleLabel.font = [UIFont fontWithName:PingFangSC size: 15];
    newsButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [newsButton addTarget:self action:@selector(touchNews) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:newsButton];
}
-(void) remoreAllEnters {
    for (EnterButton *enterButton in self.enterButtonArray) {
        [enterButton removeFromSuperview];
    }
}
- (void) addSomeEnters {
    //循环将四个按钮添加到数组self.enterButtonArray
    NSArray <NSString*>*favToolArray =[[NSUserDefaults standardUserDefaults] objectForKey:@"ToolPage_UserFavoriteToolsName"];
    NSMutableArray <NSString*>*nameArray = [NSMutableArray array];
    if(favToolArray) {
        for(NSString *str in favToolArray) {
             [nameArray addObject:str];
        }
        [nameArray addObject:@"更多功能"];
    }else {
        nameArray = [@[@"空教室", @"校车轨迹", @"查课表", @"更多功能"] mutableCopy];//用来保存图片和名称
    }
        
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *name in nameArray){
        UIButton *imageButton= [[UIButton alloc]init];
        UILabel *label = [[UILabel alloc]init];
        EnterButton *button;
        [imageButton setImage:[UIImage imageNamed:name] forState:normal];
        label.text = name;
        button = [[EnterButton alloc]initWithImageButton:imageButton label:label];
        [array addObject:button];
    }
    self.enterButtonArray = array;
    

    for (EnterButton *enterButton in self.enterButtonArray) {
        if ([enterButton.label.text isEqual: @"空教室"]) {
            [enterButton.imageButton addTarget:self action:@selector(touchFindClass) forControlEvents:UIControlEventTouchUpInside];
        }else if([enterButton.label.text isEqual: @"查课表"]) {
            [enterButton.imageButton addTarget:self action:@selector(touchSchedule) forControlEvents:UIControlEventTouchUpInside];
        }else if([enterButton.label.text isEqual: @"校车轨迹"]) {
            [enterButton.imageButton addTarget:self action:@selector(touchSchoolCar) forControlEvents:UIControlEventTouchUpInside];
        }else if([enterButton.label.text isEqual: @"更多功能"]) {
            [enterButton.imageButton addTarget:self action:@selector(touchMore) forControlEvents:UIControlEventTouchUpInside];
        }else if ([enterButton.label.text isEqual: @"没课约"]) {
            [enterButton.imageButton addTarget:self action:@selector(touchNoClassAppointment) forControlEvents:UIControlEventTouchUpInside];
        }else if ([enterButton.label.text isEqual: @"我的考试"]) {
        [enterButton.imageButton addTarget:self action:@selector(touchMyTest) forControlEvents:UIControlEventTouchUpInside];
        }else if([enterButton.label.text isEqual: @"校历"]) {
        [enterButton.imageButton addTarget:self action:@selector(touchSchoolCalender) forControlEvents:UIControlEventTouchUpInside];
        }else if([enterButton.label.text isEqual:@"重邮地图"]){
        [enterButton.imageButton addTarget:self action:@selector(touchMap) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:enterButton];
    }

    
}
//MARK: - 约束部分
- (void) layoutSubviews {
    [super layoutSubviews];
    [self.weekTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(STATUSBARHEIGHT + 1.7);
        make.left.equalTo(self).offset(17);
    }];
    [self.finderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weekTime.mas_bottom).offset(1);
        make.left.equalTo(self.weekTime);
    }];
    [self.writeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.finderTitle);
        make.width.height.equalTo(@28);
        make.right.equalTo(self).offset(-15.6);
    }];
    [self.writeButton.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.writeButton);
        make.width.height.equalTo(@28);
    }];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self.finderTitle.mas_bottom).offset(5);
        make.right.equalTo(self).offset(-16);
        make.height.equalTo(@134);
    }];
    [self.newsSender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom).offset(13);
        make.left.equalTo(self.bannerView);
        make.width.equalTo(@68);
        make.height.equalTo(@19.52);
    }];
    [self.news mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.newsSender);
        make.left.equalTo(self.newsSender.mas_right).offset(14);
        make.right.lessThanOrEqualTo(self.bannerView);
        make.height.equalTo(self.newsSender);
    }];
    
    // 下面是按钮入口的约束

    /*这里的实现思路是：将第一个和最后一个控件的位置写定，然后剩下的控件平分的排列在中央*/
    
        //i是用来记录当前正在设置哪一个控件的约束
        int i = 0;
        for (EnterButton *button in self.enterButtonArray) {
            if (button == self.enterButtonArray[0]) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(Gap);
                    make.top.equalTo(self.newsSender.mas_bottom).offset(15);
                    make.width.height.equalTo(@EnterButtonWidth);
                }];
            } else if (button == self.enterButtonArray[self.enterButtonArray.count - 1]) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self).offset(-Gap);
                    make.top.equalTo(self.enterButtonArray[0].imageButton);
                    make.width.height.equalTo(@EnterButtonWidth);
                }];
            } else {
                //x表示第一个button的右边和最后一个button的左边中间的距离
                float x = self.width - 2 * Gap - 2 * EnterButtonWidth;
                //y表示x减去控件长度之后剩下的长度
                float y = x - (self.enterButtonArray.count - 2) * EnterButtonWidth;
                //z代表每个控件左边距离self的距离
                float z = Gap + EnterButtonWidth + i * y / (self.enterButtonArray.count - 1) + (i - 1) * EnterButtonWidth;
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.enterButtonArray[0].imageButton);
                    make.width.height.equalTo(@EnterButtonWidth);
                    make.left.equalTo(@(z));
                }];
            }
            i++;
        }
}
//MARK: - bannerView按钮触发事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    URLController * controller = [[URLController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.toUrl = self.bannerGoToURL[index];
    [self.viewController.navigationController pushViewController:controller animated:YES];
//    self.viewController.hidesBottomBarWhenPushed = YES;
    NSLog(@"点击了第%ld个bannerView", (long)index);
}
//MARK: - 按钮触发事件部分实现
-(void) touchMyTest {
    if([self.delegate respondsToSelector:@selector(touchMyTest)]) {
        [self.delegate touchMyTest];
    }
}
- (void) touchNewsSender {
    if([self.delegate respondsToSelector:@selector(touchNewsSender)]) {
        [self.delegate touchNewsSender];
    }
}
- (void) touchNews {
    if([self.delegate respondsToSelector:@selector(touchNews)]) {
        [self.delegate touchNews];
    }
}
- (void) touchWriteButton {
    if([self.delegate respondsToSelector:@selector(touchWriteButton)]) {
        [self.delegate touchWriteButton];
    }
}
- (void) touchFindClass {
    if([self.delegate respondsToSelector:@selector(touchFindClass)]) {
        [self.delegate touchFindClass];
    }
}
- (void) touchSchoolCar {
    if([self.delegate respondsToSelector:@selector(touchSchoolCar)]) {
        [self.delegate touchSchoolCar];
    }
    
}
- (void) touchSchedule {
    if ([self.delegate respondsToSelector:@selector(touchSchedule)]) {
        [self.delegate touchSchedule];
    }
}
-(void)touchMap {
    if ([self.delegate respondsToSelector:@selector(touchMap)]) {
        [self.delegate touchMap];
    }
}
- (void) touchMore {
    if([self.delegate respondsToSelector:@selector(touchMore)]) {
        [self.delegate touchMore];
    }
}
-(void) touchSchoolCalender {
    if ([self.delegate respondsToSelector:@selector(touchSchoolCalender)]) {
        [self.delegate touchSchoolCalender];
    }
}
- (void) touchNoClassAppointment{
    if ([self.delegate respondsToSelector:@selector(touchNoClassAppointment)]) {
        [self.delegate touchNoClassAppointment];
    }
}
@end
