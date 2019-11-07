//
//  LQQFinderView.m
//  testForLargeTitle
//
//  Created by 千千 on 2019/10/22.
//  Copyright © 2019 千千. All rights reserved.
//

#import "LQQFinderView.h"
#define PingFangSC @".PingFang SC"
#define PingFangSCBold @"PingFang-SC-Semibold"
#define Gap 17                   //控件距离两边的距离
#define EnterButtonWidth 38      //首页的几个入口的按钮的宽度
@interface LQQFinderView()
@property NSUserDefaults *defaults;

@end
@implementation LQQFinderView
//MARK: - 初始化部分
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
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
    weekTimeLabel.backgroundColor = [UIColor blackColor];
    self.weekTime = weekTimeLabel;
    weekTimeLabel.text = @"第666周，周666";
    weekTimeLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    weekTimeLabel.font = [UIFont fontWithName:PingFangSCBold size: 10];
    [self addSubview:weekTimeLabel];

}
- (void) addFinderTitle {
    UILabel *finderTitle = [[UILabel alloc]init];
    self.finderTitle = finderTitle;
    finderTitle .text = @"发现";
    finderTitle.font = [UIFont fontWithName:PingFangSCBold size: 34];
    finderTitle.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
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
    UIView *view = [[UIView alloc] init];
    self.bannerView = view;
    view.backgroundColor = [UIColor blueColor];
    view.layer.cornerRadius = 15;
    [self addSubview:view];
}
- (void) addNewsSender {
    UIButton *button = [[UIButton alloc]init];
    self.newsSender = button;

//    [button setImage:<#(nullable UIImage *)#> forState:normal];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(touchNewsSender) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"教务在线" forState:normal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont fontWithName:PingFangSCBold size: 11];
    
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:button];
}
- (void) addNews {
    UIButton *newsButton = [[UIButton alloc]init];
    self.news = newsButton;
    NSString *title = [self.defaults objectForKey:@"oneNews"];
    [newsButton setTitle: title forState:normal];
    [newsButton setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] forState:normal];
    newsButton.titleLabel.font = [UIFont fontWithName:PingFangSC size: 15];
    [newsButton addTarget:self action:@selector(touchNews) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:newsButton];
}
- (void) addSomeEnters {
    //循环将四个按钮添加到数组self.enterButtonArray
    NSArray *nameArray = @[@"教室查询", @"校车轨迹", @"课表查询", @"更多功能"];//用来保存图片和名称
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
    
    //点击教室查询
    [self.enterButtonArray[0].imageButton addTarget:self action:@selector(touchFindClass) forControlEvents:UIControlEventTouchUpInside];
    //点击校车轨迹
    [self.enterButtonArray[1].imageButton addTarget:self action:@selector(touchSchoolCar) forControlEvents:UIControlEventTouchUpInside];
    //点击课表查询
    [self.enterButtonArray[2].imageButton addTarget:self action:@selector(touchSchedule) forControlEvents:UIControlEventTouchUpInside];
    //点击更多功能
    [self.enterButtonArray[3].imageButton addTarget:self action:@selector(touchMore) forControlEvents:UIControlEventTouchUpInside];
    for (EnterButton *enterButton in self.enterButtonArray) {
        [self addSubview:enterButton];
    }

    
}
//MARK: - 约束部分
- (void) layoutSubviews {
    [super layoutSubviews];
    [self.weekTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(15);
    }];
    [self.finderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weekTime.mas_bottom).offset(15);
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
        make.top.equalTo(self.finderTitle.mas_bottom).offset(10);
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
        make.left.equalTo(self.newsSender.mas_right).offset(16);
        make.height.equalTo(self.newsSender);
    }];
    
    // 下面是封装好的四个按钮入口的约束

    /*这里的实现思路是：将第一个和最后一个控件的位置写定，然后剩下的控件平分的排列在中央*/
    
        //i是用来记录当前正在设置哪一个控件的约束
        int i = 0;
        for (EnterButton *button in self.enterButtonArray) {
            if (button == self.enterButtonArray[0]) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(Gap);
                    make.top.equalTo(self.newsSender.mas_bottom).offset(25);
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
//MARK: - 按钮触发事件部分实现
- (void) touchNewsSender {
    
}
- (void) touchNews {
    
}
- (void) touchWriteButton {
    
}
- (void) touchFindClass {
    
}
- (void) touchSchoolCar {
    
}
- (void) touchSchedule {
    
}
- (void) touchMore {
    
}
@end
