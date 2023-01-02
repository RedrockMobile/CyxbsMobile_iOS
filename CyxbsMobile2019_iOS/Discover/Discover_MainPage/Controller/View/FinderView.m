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

#define Gap 17                   //控件距离两边的距离
#define EnterButtonWidth 38      //首页的几个入口的按钮的宽度

@interface FinderView() <
    SDCycleScrollViewDelegate
>

/// 顶端视图 / Remake by SSR
@property (nonatomic, strong) FinderTopView *topView;

/// 教务在线 / Remake by SSR
@property (nonatomic, strong) DiscoverJWZXVC *jwzxVC;

@property (nonatomic, weak) SDCycleScrollView *cycleScrollView;

@end

@implementation FinderView
// MARK: - 初始化部分
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F2F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        self.bannerURLStrings = [NSMutableArray array];
        
        // Remake by SSR
        [self addSubview:self.topView];
        
        [self addBannerView];
        
//        [self addSubview:self.jwzxVC.view];
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
        _jwzxVC = [[DiscoverJWZXVC alloc] initWithWidth:self.width];
        _jwzxVC.view.top = self.bannerView.bottom + 14;
        
//        _jwzxVC = [[DiscoverJWZXVC alloc] initWithViewFrame:CGRectMake(0, self.bannerView.bottom + 14, self.width, 19.52)];
    }
    return _jwzxVC;
}

- (UIViewController *)msgViewController {
    return self.topView.msgVC;
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

-(void) remoreAllEnters {
    for (EnterButton *enterButton in self.enterButtonArray) {
        [enterButton removeFromSuperview];
    }
}
- (void) addSomeEnters {
    //循环将四个按钮添加到数组self.enterButtonArray
    NSArray <NSString*>*favToolArray = [NSUserDefaults.standardUserDefaults objectForKey:@"ToolPage_UserFavoriteToolsName"];
    NSMutableArray <NSString*>*nameArray = [NSMutableArray array];
    if(favToolArray) {
        for(NSString *str in favToolArray) {
             [nameArray addObject:str];
        }
        [nameArray addObject:@"更多功能"];
    }else {
        nameArray = [@[@"重邮地图", @"校车轨迹", @"查课表", @"更多功能"] mutableCopy];//用来保存图片和名称
//        nameArray = [@[@"空教室", @"查课表",@"我的考试", @"更多功能"] mutableCopy];//用来保存图片和名称
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *name in nameArray){
        UIButton *imageButton= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, EnterButtonWidth, EnterButtonWidth)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, EnterButtonWidth, EnterButtonWidth, 20)];
        EnterButton *button;
        [imageButton setImage:[UIImage imageNamed:name] forState:normal];
        label.text = name;
        button = [[EnterButton alloc]initWithImageButton:imageButton label:label];
//        button.top = self.jwzxVC.view.bottom + 15;
        button.top = self.bannerView.bottom + 25;
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
        }
        else if([enterButton.label.text isEqualToString:@"邮子清单"]){
            [enterButton.imageButton addTarget:self action:@selector(touchToDOListSender) forControlEvents:UIControlEventTouchUpInside];
        }
        else if([enterButton.label.text isEqualToString:@"体育打卡"]){
            [enterButton.imageButton addTarget:self action:@selector(touchSportAttendanceSender) forControlEvents:UIControlEventTouchUpInside];
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

//MARK: - bannerView按钮触发事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    // 如果是http或者https协议的URL，用浏览器打开网页，如果是cyxbs协议的URL，打开对应页面
    if ([self.bannerGoToURL[index] hasPrefix:@"http"]) {
        URLController * controller = [[URLController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.toUrl = self.bannerGoToURL[index];
        [self.viewController.navigationController pushViewController:controller animated:YES];

    } else if ([self.bannerGoToURL[index] hasPrefix:@"cyxbs"]) {
        
        // TODO: 使用RisingRouter
    }
    
}
//MARK: - 按钮触发事件部分实现
-(void) touchMyTest {
    if([self.delegate respondsToSelector:@selector(touchMyTest)]) {
        [self.delegate touchMyTest];
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
- (void)touchToDOListSender{
    if ([self.delegate respondsToSelector:@selector(touchToDOList)]) {
        [self.delegate touchToDOList];
    }
}
    
- (void)touchSportAttendanceSender{
    if ([self.delegate respondsToSelector:@selector(touchSportAttendance)]) {
        [self.delegate touchSportAttendance];
    }
    
}
@end
