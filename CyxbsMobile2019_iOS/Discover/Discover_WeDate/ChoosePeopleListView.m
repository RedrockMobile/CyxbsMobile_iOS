//
//  ChoosePeopleListView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/30.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ChoosePeopleListView.h"

@interface ChoosePeopleListView()<UITableViewDelegate,UITableViewDataSource,PeopleListTableViewCellDelegateAdd,UIScrollViewDelegate>
@property (nonatomic, strong)UIView *peopleListView;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)NSArray *infoDictArray;
@end
@implementation ChoosePeopleListView
- (instancetype)initWithInfoDictArray:(NSArray*)infoDictArray{
    self = [super init];
    if(self){
//        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:83/255.0 green:105/255.0 blue:188/255.0 alpha:0.27];
        self.infoDictArray =infoDictArray;
        [self addScrollView];
        [self addPeopleListView];
        self.alpha = 0;
    }
    return self;
}

//MARK:初始、添加化控件的方法
- (void)addScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.backgroundColor = UIColor.clearColor;
    
    scrollView.contentSize = CGSizeMake(0, MAIN_SCREEN_H*1.0845);
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

-(void)addPeopleListView{
    UIView *backgroundView =  [[UIView alloc] init];
    self.peopleListView = backgroundView;
    [self.scrollView addSubview:backgroundView];
    
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.cornerRadius = 8;
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.scrollView.mas_bottom).offset(MAIN_SCREEN_H*0.55);
        make.height.mas_equalTo(MAIN_SCREEN_H*0.5345);
    }];
    
    //________________________________________________________
    
    
    UIButton *btn = [[UIButton alloc] init];
    [backgroundView addSubview:btn];
    
    [btn setTitle:@"取消" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont fontWithName:@".PingFang SC" size: 15];
    [btn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView).offset(0.0259*MAIN_SCREEN_H);
        make.left.equalTo(backgroundView).offset(0.0426*MAIN_SCREEN_W);
        make.height.mas_equalTo(0.0259*MAIN_SCREEN_H);
        make.width.mas_equalTo(0.08*MAIN_SCREEN_W);
    }];
    
    //________________________________________________________
    
    UITableView *tableView = [[UITableView alloc] init];
    [backgroundView addSubview:tableView];
    
    [tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    tableView.rowHeight = MAIN_SCREEN_H*0.0875;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView);
        make.right.equalTo(backgroundView);
        make.bottom.equalTo(backgroundView);
        make.top.equalTo(btn).offset(MAIN_SCREEN_H*0.04);
    }];
}


//MARK:点击某按钮后调用的方法：
//取消按钮
- (void)cancelBtnClicked{
    [UIView animateWithDuration:0.7 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


//MARK:需实现的代理方法：

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoDictArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *infoDict = self.infoDictArray[indexPath.row];
    PeopleListTableViewCell *cell = [[PeopleListTableViewCell alloc] initWithInfoDict:@{
        @"name":infoDict[@"name"],
        @"stuNum":infoDict[@"stuNum"]
    } andRightBtnType:(PeopleListTableViewCellRightBtnTypeAdd)];
    
    cell.delegateAdd = self;
    return cell;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if([scrollView isEqual:self.scrollView]){
        return self.peopleListView;
    }else{
        return nil;
    }
}

- (void)PeopleListTableViewCellAddBtnClickInfoDict:(NSDictionary *)infoDict{
    [self.delegate PeopleListTableViewCellAddBtnClickInfoDict:infoDict];
    [self cancelBtnClicked];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if([scrollView isEqual:self.scrollView]){
        if(scrollView.contentOffset.y>self.peopleListView.frame.size.height*0.7){
            [UIView animateWithDuration:0.5 animations:^{
                scrollView.contentOffset = CGPointMake(0, MAIN_SCREEN_H*0.5345);
            }];
            
        }else{
            [self cancelBtnClicked];
        }
    }
}

//MARK:其他：
- (void)showPeopleListView{
    [UIView animateWithDuration:1 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, MAIN_SCREEN_H*0.5345);
        self.alpha = 1;
    }];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelBtnClicked];
}

@end
