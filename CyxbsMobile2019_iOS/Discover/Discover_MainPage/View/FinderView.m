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

#define Gap 17               //控件距离两边的距离
#define EnterButtonWidth 38  //首页的几个入口的按钮的宽度

@interface FinderView()

@end

@implementation FinderView

// MARK: - 初始化部分
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F2F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        self.bannerURLStrings = [NSMutableArray array];
        
        // Remake by SSR
        [self addSubview:self.topView];
        [self addBannerView];
        [self addSomeEnters];
    }
    return self;
}

#pragma mark - Method

- (void)addBannerView {
    NSArray *imagesURLStrings = self.bannerURLStrings;
    SDCycleScrollView *cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(16, self.topView.bottom + 16, self.width - 2 * 16, 134)];
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"Discover_placeholder"];
    
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
    [self addSubview:cycleScrollView];
    
}
- (void)updateBannerViewIfNeeded {
    [self.bannerView removeFromSuperview];
    [self addBannerView];
}

- (void)remoreAllEnters {
    for (EnterButton *enterButton in self.enterButtonArray) {
        [enterButton removeFromSuperview];
    }
}

- (void)addSomeEnters {
    //循环将四个按钮添加到数组self.enterButtonArray
    NSArray <NSString*>*favToolArray = [NSUserDefaults.standardUserDefaults objectForKey:@"ToolPage_UserFavoriteToolsName"];
    NSMutableArray <NSString*>*nameArray = [NSMutableArray array];
    if (favToolArray) {
        for(NSString *str in favToolArray) {
             [nameArray addObject:str];
        }
        [nameArray addObject:@"更多功能"];
    } else {
        nameArray = [@[@"重邮地图", @"校车轨迹", @"查课表", @"更多功能"] mutableCopy];  // 用来保存图片和名称
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
        button.top = self.bannerView.bottom + 25;
        button.width = imageButton.width;
        button.height = imageButton.height + label.height;
        [array addObject:button];
    }
    self.enterButtonArray = array;

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

#pragma mark - Getter // Remake by SSR

- (FinderTopView *)topView {
    if (_topView == nil) {
        _topView = [[FinderTopView alloc] init];
        // -- 我的消息 --
    }
    return _topView;
}

- (UIViewController *)msgViewController {
    return self.topView.msgVC;
}

@end
