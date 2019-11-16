//
//  LQQFinderToolViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2019/11/15.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "LQQFinderToolViewController.h"
#import "FinderToolViewItem.h"
@interface LQQFinderToolViewController ()
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic)NSArray<FinderToolViewItem *> *toolViewItems;
@end

@implementation LQQFinderToolViewController

- (void)viewDidLoad {
    [self.navigationItem setHidesBackButton:YES];
    [super viewDidLoad];
    [self addContentView];//添加底层的ScrollView
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
- (void)addToolViewItems {
    FinderToolViewItem *item1 = [[FinderToolViewItem alloc]initWithIconView:@"教室查询" Title:@"教室查询" Detail:@"帮助同学们更快的查找到课表"];
    FinderToolViewItem *item2 = [[FinderToolViewItem alloc]initWithIconView:@"校车轨迹" Title:@"校车轨迹" Detail:@"帮助同学们找到当前校车"];
    FinderToolViewItem *item3 = [[FinderToolViewItem alloc]initWithIconView:@"课表查询" Title:@"课表查询" Detail:@"帮助同学们知道应该上什么课"];
    FinderToolViewItem *item4 = [[FinderToolViewItem alloc]initWithIconView:@"课表查询" Title:@"课表查询" Detail:@"帮助同学们知道应该上什么课"];
    FinderToolViewItem *item5 = [[FinderToolViewItem alloc]initWithIconView:@"校车轨迹" Title:@"校车轨迹" Detail:@"帮助同学们找到当前校车"];

    NSMutableArray *itemsArray = [NSMutableArray array];
    [itemsArray addObject:item1];
    [itemsArray addObject:item2];
    [itemsArray addObject:item3];
    [itemsArray addObject:item4];
    [itemsArray addObject:item5];
    
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
                make.top.equalTo(self.contentView).offset(100);
                make.left.equalTo(self.contentView).offset(16);
                make.height.equalTo(@224);
                make.width.equalTo(self.view).multipliedBy(168/375.0);
            }];
        }else if (item == self.toolViewItems[1]) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.toolViewItems[0]);
                make.right.equalTo(self.view).offset(-16);
                make.height.equalTo(@255);
                make.width.equalTo(self.toolViewItems[0]);
            }];
        }else {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.toolViewItems[times-2].mas_bottom).offset(8);
                make.left.equalTo(self.toolViewItems[times-2]);
                make.width.height.equalTo(self.toolViewItems[0]);
            }];
        }
        times++;
    }

}

@end
