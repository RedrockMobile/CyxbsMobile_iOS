//
//  LQQFinderToolViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2019/11/15.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "LQQFinderToolViewController.h"
#import "FinderToolViewItem.h"
@interface LQQFinderToolViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic)NSArray<FinderToolViewItem *> *toolViewItems;
@property (nonatomic, weak)UILabel *toolTitle;
@end

@implementation LQQFinderToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addContentView];//添加底层的ScrollView
    [self configNavigationBar];
    [self addToolTitle];
    [self addSettingButton];
    [self addToolViewItems];//将每个工具添加到当前页面
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    [self layoutItems];

}

- (void)addContentView {
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    if(@available(iOS 11.0, *)){
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        contentView.frame = CGRectMake(0,self.navigationController.navigationBar.height + statusBarFrame.size.height, self.view.width, self.view.height);
    }
    self.contentView = contentView;
//    contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];

    contentView.contentSize = CGSizeMake(self.view.width, 1.5 * self.view.height);
    [self.view addSubview:contentView];
}
- (void)configNavigationBar {
    self.contentView.delegate = self;
    self.navigationController.navigationBar.topItem.title = @"";
    self.title = @"工具";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:176/255.0 green:189/255.0 blue:215/255.0 alpha:1];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y >= self.navigationController.navigationBar.height + self.toolTitle.height){
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1]}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:0]}];
    }
}
- (void) addToolTitle {
    UILabel *toolTitle = [[UILabel alloc]init];
    self.toolTitle = toolTitle;
    toolTitle.text = @"工具";
    toolTitle.font = [UIFont fontWithName:PingFangSCBold size: 34];
    toolTitle.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    [self.contentView addSubview:toolTitle];
    [toolTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(14);
        make.top.equalTo(self.contentView).offset(8);
    }];
}
- (void)addSettingButton {
    UIButton *button = [[UIButton alloc]init];
    [self.contentView addSubview:button];
    [button setImage:[UIImage imageNamed:@"LQQsetting"] forState:normal];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolTitle);
        make.right.equalTo(self.view).offset(-15.32);
        make.width.height.equalTo(@30);
    }];
}
- (void)addToolViewItems {
    FinderToolViewItem *item1 = [[FinderToolViewItem alloc]initWithIconView:@"同学课表" Title:@"同学课表" Detail:@"帮助同学们更快的查找到课表"];
    FinderToolViewItem *item2 = [[FinderToolViewItem alloc]initWithIconView:@"校车轨迹" Title:@"校车轨迹" Detail:@"帮助同学们找到当前校车"];
    FinderToolViewItem *item3 = [[FinderToolViewItem alloc]initWithIconView:@"教室查询" Title:@"课表查询" Detail:@"帮助同学们知道应该上什么课"];
    FinderToolViewItem *item4 = [[FinderToolViewItem alloc]initWithIconView:@"考试成绩" Title:@"考试成绩" Detail:@"帮助同学们知道应该上什么课"];
    FinderToolViewItem *item5 = [[FinderToolViewItem alloc]initWithIconView:@"空课表" Title:@"空课表" Detail:@"帮助同学们找到当前校车"];
    FinderToolViewItem *item6 = [[FinderToolViewItem alloc]initWithIconView:@"校历" Title:@"校历" Detail:@"帮助同学们找到当前校车"];
    FinderToolViewItem *item7 = [[FinderToolViewItem alloc]initWithIconView:@"重邮地图" Title:@"重邮地图" Detail:@"帮助同学们找到当前校车"];
    FinderToolViewItem *item8 = [[FinderToolViewItem alloc]initWithIconView:@"更多功能" Title:@"更多功能" Detail:@"帮助同学们找到当前校车"];

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
    for (FinderToolViewItem*item in itemsArray) {
        [self.contentView addSubview:item];
    }
}
- (void)layoutItems {
    int times = 0;//用来记录当前正在遍历第几个
    for (FinderToolViewItem*item in self.toolViewItems) {
        [self.contentView addSubview:item];
        if(item == self.toolViewItems[0]) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.toolTitle.mas_bottom).offset(22);
                make.left.equalTo(self.contentView).offset(16);
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
        }
        times++;
    }

}

@end
