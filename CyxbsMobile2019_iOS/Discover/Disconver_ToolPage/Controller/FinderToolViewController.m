//
//  FinderToolViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2019/11/15.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "FinderToolViewController.h"
#import "FinderToolViewItem.h"
#import "ScheduleInquiryViewController.h"
#import "TestArrangeViewController.h"
#import "SchoolBusViewController.h"
#import "EmptyClassViewController.h"

#define color242_243_248to000000 [UIColor colorNamed:@"color242_243_248&#000000" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define color242_243_248toFFFFFF [UIColor colorNamed:@"color242_243_248&#FFFFFF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]


@interface FinderToolViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *viewContainer;
@property (nonatomic)NSArray<FinderToolViewItem *> *toolViewItems;
@property (nonatomic, weak)UILabel *toolTitle;
@property (nonatomic, weak)UIButton *backButton;//返回按钮

@end

@implementation FinderToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    [self addContentView];//添加底层的ScrollView
    [self addViewContainer];
    [self addToolTitle];
    [self configNavigationBar];
    [self addSettingButton];
    [self addToolViewItems];//将每个工具添加到当前页面

    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = color242_243_248to000000;
    } else {
        // Fallback on earlier versions
    }
    [self layoutItems];

}
- (void)addBackButton {
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    self.backButton = button;
    [button setImage:[UIImage imageNamed:@"LQQBackButton"] forState:normal];
    [button setImage: [UIImage imageNamed:@"EmptyClassBackButton"] forState:UIControlStateHighlighted];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        if (IS_IPHONEX) {
            make.top.equalTo(self.view).offset(65);
        }else {
            make.top.equalTo(self.view).offset(40);
        }
        make.left.equalTo(self.view).offset(8.6);
    }];
    [button setImageEdgeInsets:UIEdgeInsetsMake(6, 10, 6, 10)];//增大点击范围
    [button addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
}
- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)addContentView {
    UIScrollView *contentView = [[UIScrollView alloc]init];
    self.scrollView = contentView;
    self.scrollView.delegate = self;
    if (@available(iOS 11.0, *)) {
        contentView.backgroundColor = color242_243_248to000000;
    } else {
        contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1];
    }

    [self.view addSubview:contentView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton.mas_bottom).offset(6.5);
        make.left.right.bottom.equalTo(self.view);
    }];
}
- (void)addViewContainer {
    UIView *viewContainer = [[UIView alloc]init];
    [self.scrollView addSubview:viewContainer];
    self.viewContainer = viewContainer;
    [viewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
    }];

}
- (void)configNavigationBar {
//    self.navigationController.navigationBar.topItem.title = @"";
//    self.title = @"工具";
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:176/255.0 green:189/255.0 blue:215/255.0 alpha:1];
    self.navigationController.navigationBar.hidden = YES;

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y >= self.navigationController.navigationBar.height + self.toolTitle.height){
        if (@available(iOS 11.0, *)) {
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color242_243_248toFFFFFF}];
        } else {
            // Fallback on earlier versions
        }
    }else{
        if (@available(iOS 11.0, *)) {
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color242_243_248to000000}];
        } else {
            // Fallback on earlier versions
        }
    }
}
- (void) addToolTitle {
    UILabel *toolTitle = [[UILabel alloc]init];
    self.toolTitle = toolTitle;
    toolTitle.text = @"工具";
    toolTitle.font = [UIFont fontWithName:PingFangSCBold size: 34];
    if (@available(iOS 11.0, *)) {
        toolTitle.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    [self.viewContainer addSubview:toolTitle];
    [toolTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewContainer).offset(14);
        make.top.equalTo(self.viewContainer).offset(0);
    }];
}
- (void)addSettingButton {
    UIButton *button = [[UIButton alloc]init];
    [self.viewContainer addSubview:button];
    [button setImage:[UIImage imageNamed:@"LQQsetting"] forState:normal];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolTitle);
        make.right.equalTo(self.view).offset(-15.32);
        make.width.height.equalTo(@30);
    }];
}
- (void)addToolViewItems {
    FinderToolViewItem *item1 = [[FinderToolViewItem alloc]initWithIconView:@"没课约" Title:@"没课约" Detail:@"多人空课表同步查询"];
    
    FinderToolViewItem *item2 = [[FinderToolViewItem alloc]initWithIconView:@"校车轨迹" Title:@"校车轨迹" Detail:@"校园观光车轨迹路线实时查看"];
    FinderToolViewItem *item3 = [[FinderToolViewItem alloc]initWithIconView:@"教室查询" Title:@"空教室" Detail:@"空余教室及时查询"];
    FinderToolViewItem *item4 = [[FinderToolViewItem alloc]initWithIconView:@"考试成绩" Title:@"我的考试" Detail:@"考试安排、成绩学分轻松查询"];
    FinderToolViewItem *item5 = [[FinderToolViewItem alloc]initWithIconView:@"空课表" Title:@"空课表" Detail:@"同学、老师课表快捷查询"];
    FinderToolViewItem *item6 = [[FinderToolViewItem alloc]initWithIconView:@"校历" Title:@"校历" Detail:@"学期安排一目了然"];
    FinderToolViewItem *item7 = [[FinderToolViewItem alloc]initWithIconView:@"重邮地图" Title:@"重邮地图" Detail:@"校园地图，尽收重邮风光"];
    FinderToolViewItem *item8 = [[FinderToolViewItem alloc]initWithIconView:@"更多功能" Title:@"更多功能" Detail:@"敬请期待"];

    [item2 addTarget:self action:@selector(chooseSchoolBus) forControlEvents:UIControlEventTouchUpInside];
    [item4 addTarget:self action:@selector(chooseTestArrange) forControlEvents:UIControlEventTouchUpInside];
    [item5 addTarget:self action:@selector(chooseScheduleInquiry) forControlEvents:UIControlEventTouchUpInside];
    [item3 addTarget:self action:@selector(chooseEmptyClassRoom) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    [itemsArray addObject:item1];
    [itemsArray addObject:item2];
    [itemsArray addObject:item3];
    [itemsArray addObject:item4];
    [itemsArray addObject:item5];
    [itemsArray addObject:item6];
    [itemsArray addObject:item7];
    [itemsArray addObject:item8];
    
    
    self.toolViewItems = itemsArray;
    for (FinderToolViewItem*item in self.toolViewItems) {
        [self.viewContainer addSubview:item];
    }
}
- (void)layoutItems {
    int times = 0;//用来记录当前正在遍历第几个
    for (FinderToolViewItem*item in self.toolViewItems) {
        [self.viewContainer addSubview:item];
        if(item == self.toolViewItems[0]) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.toolTitle.mas_bottom).offset(6.5);
                make.left.equalTo(self.viewContainer).offset(16);
                make.height.equalTo(@224);
                make.width.equalTo(self.view).multipliedBy(168/375.0);
            }];
        }else if (item == self.toolViewItems[1]) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.toolViewItems[0]);
                make.right.equalTo(self.view).offset(-16);
                make.height.equalTo(@255);
                make.left.equalTo(self.toolViewItems[0].mas_right).offset(8);
            }];
        }else {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.toolViewItems[times-2].mas_bottom).offset(8);
                make.left.right.equalTo(self.toolViewItems[times-2]);
                make.height.equalTo(self.toolViewItems[0]);
            }];
            if(item == self.toolViewItems.lastObject) {
                [item mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.viewContainer);
                }];
            }
        }
        times++;
    }

}


//MARK: - 空课表
- (void) chooseScheduleInquiry {
    //点击了空课表
    ScheduleInquiryViewController *vc = [[ScheduleInquiryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK: - 考试查询
- (void)chooseTestArrange {
    TestArrangeViewController *vc = [[TestArrangeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK: - 校车定位
- (void)chooseSchoolBus {
    SchoolBusViewController *vc = [[SchoolBusViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK: - 空教室
- (void)chooseEmptyClassRoom {
    EmptyClassViewController *vc = [[EmptyClassViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
