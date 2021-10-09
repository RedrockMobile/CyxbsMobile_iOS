//
//  ChoosePeopleListView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/30.
//  Copyright © 2020 Redrock. All rights reserved.
//这个类是点击键盘上的搜索按钮后的底部弹窗

#import "ChoosePeopleListView.h"

@interface ChoosePeopleListView() <
    UITableViewDelegate,
    UITableViewDataSource,
    PeopleListTableViewCellDelegateAdd,
    UIScrollViewDelegate
>
/**有圆角的那个view，里面有一个tableView和取消按钮*/
@property (nonatomic, strong)UIView *peopleListView;
/**self.peopleListView的父控件，实现peopleListView的滚动*/
@property (nonatomic, strong)UIScrollView *scrollView;
/**
 所有cell的数据都是来自这个属性，内部结构：@[
 @{@"name:@"xxx",@"stuNum":@"201921134"},
 @{@"name:@"x",@"stuNum":@"23900423134"}
  。。。
  。。
];
*/
@property (nonatomic, strong)NSArray *infoDictArray;

@property (nonatomic, assign, readonly)CGFloat tableViewCellHeight;
@end
@implementation ChoosePeopleListView
- (instancetype)initWithInfoDictArray:(NSArray*)infoDictArray{
    self = [super init];
    if(self){
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"ChoosePeopleListViewBackColor"];
        } else {
            self.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.14];
        }
        self.infoDictArray = infoDictArray;
        [self addScrollView];
        [self addPeopleListView];
        _tableViewCellHeight = 0.07*SCREEN_HEIGHT;
        self.alpha = 0;
    }
    return self;
}


//MARK:-初始、添加化控件的方法
//添加self.peopleListView的背景
- (void)addScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(MAIN_SCREEN_H*0.55);
    }];
}

//添加弹窗
-(void)addPeopleListView{
    //______________________添加整体背景__________________________________
    UIView *backgroundView =  [[UIView alloc] init];
    self.peopleListView = backgroundView;
    [self.scrollView addSubview:backgroundView];
    
    if (@available(iOS 11.0, *)) {
        backgroundView.backgroundColor = [UIColor colorNamed:@"peopleListViewBackColor"];
    } else {
        backgroundView.backgroundColor = [UIColor whiteColor];
    }
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, MAIN_SCREEN_H*0.55);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(16, 0)];
    
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    mask.path = path.CGPath;
    mask.frame = rect;
    backgroundView.layer.mask = mask;
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView).offset(MAIN_SCREEN_H*0.55);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(MAIN_SCREEN_H*0.55);
    }];
    
    //_______________________添加取消按钮_________________________________
    
    
    UIButton *btn = [[UIButton alloc] init];
    [backgroundView addSubview:btn];
    
    [btn setTitle:@"取消" forState:(UIControlStateNormal)];
    if (@available(iOS 11.0, *)) {
        [btn setTitleColor:[UIColor colorNamed:@"color21_49_91&#F0F0F2"] forState:(UIControlStateNormal)];
    } else {
        [btn setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1] forState:(UIControlStateNormal)];
    }
    btn.titleLabel.font = [UIFont fontWithName:@".PingFang SC" size: 15];
    [btn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView).offset(0.0259*MAIN_SCREEN_H);
        make.left.equalTo(backgroundView).offset(0.0426*MAIN_SCREEN_W);
        make.height.mas_equalTo(0.0259*MAIN_SCREEN_H);
        make.width.mas_equalTo(0.08*MAIN_SCREEN_W);
    }];
    
    //_______________________添加tableview_________________________________
    
    UITableView *tableView = [[UITableView alloc] init];
    [backgroundView addSubview:tableView];
    
    [tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    tableView.rowHeight = MAIN_SCREEN_H*0.0875;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.allowsSelection = NO;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView);
        make.right.equalTo(backgroundView);
        make.bottom.equalTo(backgroundView);
        make.top.equalTo(btn).offset(MAIN_SCREEN_H*0.04);
    }];
    CCLog(@"tttt = %@", tableView);
    [self.scrollView layoutIfNeeded];
}


//MARK:-点击某按钮后调用的方法：
//取消按钮点击后调用
- (void)cancelBtnClicked{
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


//MARK:-需实现的代理方法：
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoDictArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PeopleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeDateVCPeopleListTableViewCellAdd"];
    if (cell==nil) {
        cell = [[PeopleListTableViewCell alloc] initWithRightBtnType:(PeopleListTableViewCellRightBtnTypeAdd) ID:@"WeDateVCPeopleListTableViewCellAdd"];
    }
    [cell updataWithDict:self.infoDictArray[indexPath.row]];
    cell.delegateAdd = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _tableViewCellHeight;
}

//cell的add按钮点击后调用
- (void)peopleListTableViewCellRightBtnClickedInfoDict:(NSDictionary *)infoDict{
    [self.delegate peopleListTableViewCellRightBtnClickedInfoDict:infoDict];
    [self cancelBtnClicked];
}
//下面两个方法实现当弹窗被拖移后的回弹或者消失
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if([scrollView isEqual:self.scrollView]){
        if(decelerate==YES) return;
        if(scrollView.contentOffset.y > self.peopleListView.frame.size.height*0.7){
            //t: (0, 0.3)
            CGFloat t = (1 - scrollView.contentOffset.y/self.peopleListView.frame.size.height);
            [UIView animateWithDuration:t animations:^{
                scrollView.contentOffset = CGPointMake(0, MAIN_SCREEN_H*0.55);
            }];
        }else{
            [UIView animateWithDuration:0.4 animations:^{
                scrollView.contentOffset = CGPointMake(0, 0);
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView isEqual:self.scrollView]){
        if(scrollView.tracking==YES)return;
        
        if(scrollView.contentOffset.y > self.peopleListView.frame.size.height*0.7){
            CGFloat t = (1 - scrollView.contentOffset.y/self.peopleListView.frame.size.height);
            [UIView animateWithDuration:t animations:^{
                scrollView.contentOffset = CGPointMake(0, MAIN_SCREEN_H*0.55);
            }];
        }else{
            [UIView animateWithDuration:0.4 animations:^{
                scrollView.contentOffset = CGPointMake(0, 0);
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }
}


//MARK:-其他：
//调用这个方法会让这个类弹出来
- (void)showPeopleListView{
    [UIView animateWithDuration:0.7 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, MAIN_SCREEN_H*0.55);
        self.alpha = 1;
    }];
}

//用这个方法实现点击空白处弹窗就自弹回去再消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelBtnClicked];
}

@end
