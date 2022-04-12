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

#import "FinderTopView.h"

#define PingFangSC @".PingFang SC"
#define Gap 17                   //控件距离两边的距离
#define EnterButtonWidth 38      //首页的几个入口的按钮的宽度

#define color21_49_91_F2F4FF [UIColor colorNamed:@"color21_49_91_&#F2F4FF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface FinderView() <
    SDCycleScrollViewDelegate
>

/// 顶端视图 / Remake by SSR
@property (nonatomic, strong) FinderTopView *topView;

/// 教务在线 / Remake by SSR
@property (nonatomic, strong) DiscoverJWZXVC *jwzxVC;

@property (nonatomic, weak)SDCycleScrollView *cycleScrollView;

@end

@implementation FinderView
//MARK: - 初始化部分
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorNamed:@"ColorBackground"];
        self.bannerURLStrings = [NSMutableArray array];
        
        // Remake by SSR
        [self addSubview:self.topView];
        
        [self addBannerView];
        
        [self addSubview:self.jwzxVC.view];
//        [self addNewsSender];
//        [self addNews];
        [self addSomeEnters];
    }
    return self;
}

#pragma mark - Getter // Remake by SSR

- (FinderTopView *)topView {
    if (_topView == nil) {
        _topView = [[FinderTopView alloc] init];
        [_topView addSignBtnTarget:self action:@selector(touchWriteButton)];
        // -- 我的消息 --
    }
    return _topView;
}

- (DiscoverJWZXVC *)jwzxVC {
    if (_jwzxVC == nil) {
        _jwzxVC = [[DiscoverJWZXVC alloc] initWithViewFrame:CGRectMake(0, self.bannerView.bottom + 14, self.width, 19.52)];
    }
    return _jwzxVC;
}

#pragma mark - Method

- (UIViewController *)jwzxViewController {
    return self.jwzxVC;
}

- (void) addBannerView {

    NSArray *imagesURLStrings = self.bannerURLStrings;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(16, self.topView.bottom + 16, self.width - 2 * 16, 134) delegate:self placeholderImage:[UIImage imageNamed:@"Discover_placeholder"]];
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
//- (void) addNewsSender {
//    UIButton *button = [[UIButton alloc]init];
//    self.newsSender = button;
//    [button addTarget:self action:@selector(touchNewsSender) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:@"教务在线" forState:normal];
//    button.titleLabel.textColor = [UIColor whiteColor];
//    if (@available(iOS 11.0, *)) {
//        [button setBackgroundImage:[UIImage imageNamed:@"教务在线背景"] forState:normal];
//        [button setTitleColor:[UIColor colorNamed:@"whiteColor" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] forState:normal];
//    }
//    button.titleLabel.font = [UIFont fontWithName:PingFangSCBold size: 11];
//
//    button.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:button];
//}
//- (void) addNews {
//    UIButton *newsButton = [[UIButton alloc]init];
//    self.news = newsButton;
//    NSString *title = [NSUserDefaults.standardUserDefaults objectForKey:@"OneNews_oneNews"];
//
//    [newsButton setTitle: title forState:normal];
//    if (@available(iOS 11.0, *)) {
//        [newsButton setTitleColor:color21_49_91_F2F4FF forState:normal];
//    }
//    newsButton.titleLabel.font = [UIFont fontWithName:PingFangSC size: 15];
//    newsButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    [newsButton addTarget:self action:@selector(touchNews) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:newsButton];
//}
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
        //nameArray = [@[@"空教室", @"校车轨迹", @"查课表", @"更多功能"] mutableCopy];//用来保存图片和名称
        nameArray = [@[@"空教室", @"查课表",@"我的考试", @"更多功能"] mutableCopy];//用来保存图片和名称
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *name in nameArray){
        UIButton *imageButton= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, EnterButtonWidth, EnterButtonWidth)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, EnterButtonWidth, EnterButtonWidth, 20)];
        EnterButton *button;
        [imageButton setImage:[UIImage imageNamed:name] forState:normal];
        label.text = name;
        button = [[EnterButton alloc]initWithImageButton:imageButton label:label];
        button.top = self.jwzxVC.view.bottom + 15;
        button.width = imageButton.width;
        button.height = imageButton.height + label.height;
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
        }else if([enterButton.label.text isEqualToString:@"邮子清单"]){
            [enterButton.imageButton addTarget:self action:@selector(touchToDOListSender) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:enterButton];
    }

    // UI Remake by SSR : Need to Remake again
    EnterButton *firstBtn = self.enterButtonArray[0];
    firstBtn.left = Gap;
    
    EnterButton *lastBtn = self.enterButtonArray[3];
    lastBtn.right = self.SuperRight - Gap;
    
    CGFloat midleGap = (lastBtn.left - firstBtn.left) / 3;
    for (NSInteger i = 1; i < 3; i++) {
        self.enterButtonArray[i].left = firstBtn.left + i * midleGap;
    }
    
}
//MARK: - 约束部分
//- (void) layoutSubviews {
//    [super layoutSubviews];
////    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.left.equalTo(self).offset(16);
////        make.top.equalTo(self.topView.mas_bottom).offset(5);
////        make.right.equalTo(self).offset(-16);
////        make.height.equalTo(@134);
////    }];
////    [self layoutIfNeeded];
////    [self.newsSender mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self.bannerView.mas_bottom).offset(13);
////        make.left.equalTo(self.bannerView);
////        make.width.equalTo(@68);
////        make.height.equalTo(@19.52);
////    }];
////    [self.news mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self.newsSender);
////        make.left.equalTo(self.newsSender.mas_right).offset(14);
////        make.right.lessThanOrEqualTo(self.bannerView);
////        make.height.equalTo(self.newsSender);
////    }];
//
//    // 下面是按钮入口的约束
//
//    /*这里的实现思路是：将第一个和最后一个控件的位置写定，然后剩下的控件平分的排列在中央*/
//
//        //i是用来记录当前正在设置哪一个控件的约束
////        int i = 0;
////        for (EnterButton *button in self.enterButtonArray) {
////            if (button == self.enterButtonArray[0]) {
////                [button mas_makeConstraints:^(MASConstraintMaker *make) {
////                    make.left.equalTo(self).offset(Gap);
////                    make.top.equalTo(self.jwzxVC.view.mas_bottom).offset(15);
////                    make.width.height.equalTo(@EnterButtonWidth);
////                }];
////            } else if (button == self.enterButtonArray[self.enterButtonArray.count - 1]) {
////                [button mas_makeConstraints:^(MASConstraintMaker *make) {
////                    make.right.equalTo(self).offset(-Gap);
////                    make.top.equalTo(self.enterButtonArray[0].imageButton);
////                    make.width.height.equalTo(@EnterButtonWidth);
////                }];
////            } else {
////                //x表示第一个button的右边和最后一个button的左边中间的距离
////                float x = self.width - 2 * Gap - 2 * EnterButtonWidth;
////                //y表示x减去控件长度之后剩下的长度
////                float y = x - (self.enterButtonArray.count - 2) * EnterButtonWidth;
////                //z代表每个控件左边距离self的距离
////                float z = Gap + EnterButtonWidth + i * y / (self.enterButtonArray.count - 1) + (i - 1) * EnterButtonWidth;
////                [button mas_makeConstraints:^(MASConstraintMaker *make) {
////                    make.top.equalTo(self.enterButtonArray[0].imageButton);
////                    make.width.height.equalTo(@EnterButtonWidth);
////                    make.left.equalTo(@(z));
////                }];
////            }
////            i++;
////        }
//}
//MARK: - bannerView按钮触发事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    // 如果是http或者https协议的URL，用浏览器打开网页，如果是cyxbs协议的URL，打开对应页面
    if ([self.bannerGoToURL[index] hasPrefix:@"http"]) {
        URLController * controller = [[URLController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.toUrl = self.bannerGoToURL[index];
        [self.viewController.navigationController pushViewController:controller animated:YES];

    } else if ([self.bannerGoToURL[index] hasPrefix:@"cyxbs"]) {
        
        NSDictionary *userInfo = @{
            kMGJNavigationControllerKey: self.viewController.navigationController
        };
        
        [MGJRouter openURL:self.bannerGoToURL[index] withUserInfo:userInfo completion:nil];
    }
    
}
//MARK: - 按钮触发事件部分实现
-(void) touchMyTest {
    if([self.delegate respondsToSelector:@selector(touchMyTest)]) {
        [self.delegate touchMyTest];
    }
}
//- (void) touchNewsSender {
//    if([self.delegate respondsToSelector:@selector(touchNewsSender)]) {
//        [self.delegate touchNewsSender];
//    }
//}
//- (void) touchNews {
//    if([self.delegate respondsToSelector:@selector(touchNews)]) {
//        [self.delegate touchNews];
//    }
//}
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
- (void)touchToDOListSender{
    if ([self.delegate respondsToSelector:@selector(touchToDOList)]) {
        [self.delegate touchToDOList];
    }
}
@end
