//
//  WYCClassBookViewController.m
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2018/9/21.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import "WYCClassBookViewController.h"

#import "WYCClassAndRemindDataModel.h"

#import "DateModle.h"
#import "WYCClassBookView.h"
#import "WYCClassDetailView.h"
#import "WYCShowDetailView.h"
#import "WMTWeekChooseBar.h"
#import "LoginViewController.h"


#import "AddRemindViewController.h"
#import "UIFont+AdaptiveFont.h"
#import "RemindNotification.h"


#define DateStart @"2020-02-17"

@interface WYCClassBookViewController ()<UIScrollViewDelegate,WYCClassBookViewDelegate,WYCShowDetailDelegate>
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, assign) BOOL hiddenWeekChooseBar;
@property (nonatomic, strong) NSNumber *nowWeek;
@property (nonatomic, strong) NSMutableArray *titleTextArray;
//@property (nonatomic, strong) IBOutlet UIView *rootView;
@property (nonatomic, strong)  UIScrollView *scrollView;

@property (nonatomic, strong) WMTWeekChooseBar *weekChooseBar;
@property (nonatomic, strong) DateModle *dateModel;
@property (nonatomic, strong) WYCClassAndRemindDataModel *model;

@property (nonatomic, copy) NSString *stuNum;
@property (nonatomic, copy) NSString *idNum;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL weekChooseBarLock;


@end

@implementation WYCClassBookViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ModelDataLoadSuccess)
                                                 name:@"ModelDataLoadSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ModelDataLoadFailure)
                                                 name:@"ModelDataLoadFailure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:@"RemindAddSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:@"RemindEditSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:@"RemindDeleteSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateScrollViewOffSet)
                                                 name:@"ScrollViewBarChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:@"reloadView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSucceeded)
                                                 name:@"Login_LoginSuceeded" object:nil];
    //默认星期选择条不显示
    self.hiddenWeekChooseBar = YES;
    self.isLogin = NO;
    [self initModel];

}
-(void)loginSucceeded{
    [self initModel];
    self.isLogin = YES;
}

-(void)reloadView{
    [self.view removeAllSubviews];
    [self initModel];
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    _index = (long)roundf(scrollView.contentOffset.x/_scrollView.frame.size.width);
    [self initTitleLabel];
    [self.weekChooseBar changeIndex:_index];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"y:%f",self.scrollView.contentOffset.y);
    if (self.scrollView.contentOffset.y <= -100) {
        [self reloadView];
    }
    
}
-(void)updateScrollViewOffSet{
    self.index = self.weekChooseBar.index;
    [UIView animateWithDuration:0.2f animations:^{
        self.scrollView.contentOffset = CGPointMake(self.index*self.scrollView.frame.size.width,0);
    } completion:nil];
    [self initTitleLabel];
    
    
}

- (void)initModel{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载数据中...";
    hud.color = [UIColor colorWithWhite:0.f alpha:0.4f];
    self.weekChooseBarLock = YES;
    self.stuNum = [UserDefaultTool getStuNum];
    self.idNum = [UserDefaultTool getIdNum];
    if (!self.model) {
        self.dateModel = [DateModle initWithStartDate:DateStart];
        self.index = self.dateModel.nowWeek.integerValue;
        [self initWeekChooseBar];
        [self initScrollView];
        [self initTitleLabel];
        [self initNavigationBar];
        
        self.model = [[WYCClassAndRemindDataModel alloc]init];
        [self.model getClassBookArray:self.stuNum];
        [self.model getRemind:self.stuNum idNum:self.idNum];
        
        
    }else{
        [self initWeekChooseBar];
        [self initScrollView];
        [self initTitleLabel];
        [self initNavigationBar];

        [self.model getClassBookArrayFromNet:_stuNum];
        [self.model getRemindFromNet:_stuNum idNum:_idNum];
        
        
    }
    
}


- (void)ModelDataLoadSuccess{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.weekChooseBarLock = NO;
    @autoreleasepool {
        for (int dateNum = 0; dateNum < self.dateModel.dateArray.count + 1; dateNum++) {
            
            NSMutableArray *day = [[NSMutableArray alloc]initWithCapacity:7];
            
            for (int i = 0; i < 7; i++) {
                
                NSMutableArray *lesson = [[NSMutableArray alloc]initWithCapacity:6];
                
                for (int j = 0; j < 6; j++) {
                    
                    [lesson addObject:[@[] mutableCopy]];
                }
                [day addObject:[lesson mutableCopy]];
            }
            
            NSArray *classBookData = self.model.weekArray[dateNum];
            for (int i = 0; i < classBookData.count; i++) {
                
                NSNumber *hash_day = [classBookData[i] objectForKey:@"hash_day"];
                NSNumber *hash_lesson = [classBookData[i] objectForKey:@"hash_lesson"];
                
                [ day[hash_day.integerValue][hash_lesson.integerValue] addObject: classBookData[i]];
                
            }
            
            
            if (dateNum !=0) {
                NSArray *noteData = self.model.remindArray[dateNum-1];
                
                for (int i = 0; i < noteData.count; i++) {
                    
                    NSNumber *hash_day = [noteData[i] objectForKey:@"hash_day"];
                    NSNumber *hash_lesson = [noteData[i] objectForKey:@"hash_lesson"];
                    
                    [ day[hash_day.integerValue][hash_lesson.integerValue] addObject: noteData[i]];
                }
            }
            
            WYCClassBookView *view = [[WYCClassBookView alloc]initWithFrame:CGRectMake(dateNum*_scrollView.frame.size.width, 60, _scrollView.frame.size.width, _scrollView.frame.size.height)];
            view.detailDelegate = self;
            if (dateNum == 0) {
                [view initView:YES];
                NSArray *dateArray = @[];
                [view addBar:dateArray isFirst:YES];
            }else{
                [view initView:NO];
                [view addBar:self.dateModel.dateArray[dateNum-1] isFirst:NO];
            }
            
            [view addBtn:day];
            [_scrollView addSubview:view];
        }
    }
    [_scrollView layoutSubviews];
    self.scrollView.contentOffset = CGPointMake(self.index*self.scrollView.frame.size.width,0);

    [self.view layoutSubviews];
    
}

- (void)ModelDataLoadFailure{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"网络错误" message:@"数据加载失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
    
    self.scrollView.backgroundColor = [UIColor blueColor];
    UIView *view = [[UIView alloc]initWithFrame:self.scrollView.frame];
    view.backgroundColor = [UIColor blackColor];
    [self.scrollView addSubview:view];
    self.scrollView.contentSize = CGSizeMake(0, self.scrollView.height + 100);
}
- (void)initScrollView{
    //[self.rootView layoutIfNeeded];
    self.scrollView = [[UIScrollView alloc]init];
    [self.scrollView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-HEADERHEIGHT-NVGBARHEIGHT)];
    _scrollView.contentSize = CGSizeMake(self.dateModel.dateArray.count * _scrollView.frame.size.width, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [_scrollView removeAllSubviews];
    [_scrollView layoutIfNeeded];
    [self.view addSubview:self.scrollView];
}
- (void)initNavigationBar{
    [self initTitleView];
    [self initRightButton];
}
- (void)initTitleView{
    
    //自定义titleView
    self.titleView = [[UIView alloc]init];
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, 0, 120, 40)];
    self.titleView.backgroundColor = [UIColor clearColor];
    [self initTitleLabel];
    [self initTitleBtn];
}
- (void)initTitleLabel{
    if (_titleLabel) {
        [_titleLabel removeFromSuperview];
    }
    CGFloat titleLabelWidth = SCREEN_WIDTH * 0.3;
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((_titleView.width - titleLabelWidth)/ 2, 0, titleLabelWidth, _titleView.height)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    NSMutableArray *titleArray = [@[@"整学期",@"第一周",@"第二周",@"第三周",@"第四周",@"第五周",@"第六周",@"第七周",@"第八周",@"第九周",@"第十周",@"第十一周",@"第十二周",@"第十三周",@"第十四周",@"第十五周",@"第十六周",@"第十七周",@"第十八周",@"第十九周",@"第二十周",@"二十一周",@"二十二周",@"二十三周",@"二十四周",@"二十五周"] mutableCopy];
    if(self.dateModel.nowWeek.integerValue != 0){
        titleArray[self.dateModel.nowWeek.integerValue] = @"本 周";
    }
    
    
    self.titleText = titleArray[_index];
    self.titleLabel.text = self.titleText;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.titleLabel.userInteractionEnabled = YES;
    
    //添加点击手势
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateWeekChooseBar)];
    [self.titleLabel addGestureRecognizer:tapGesture];
    [self.titleView addSubview:self.titleLabel];
}
- (void)initTitleBtn{
    //添加箭头按钮
    if (_titleBtn) {
        [_titleBtn removeFromSuperview];
    }
    self.titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(_titleView.width - 15, 0, 9, _titleView.height)];
    //判断箭头方向
    if (_hiddenWeekChooseBar) {
        [self.titleBtn setImage:[UIImage imageNamed:@"downarrow"] forState:UIControlStateNormal];   //初始是下箭头
    }else{
        [self.titleBtn setImage:[UIImage imageNamed:@"uparrow"] forState:UIControlStateNormal];
    }
    
    [self.titleBtn addTarget: self action:@selector(updateWeekChooseBar) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview: self.titleBtn];
    
    self.navigationItem.titleView = self.titleView;
}
- (void)initRightButton{
    //添加备忘按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus"] style:UIBarButtonItemStylePlain target:self action:@selector(addNote)];
    self.navigationItem.rightBarButtonItem = right;
    
}

//添加备忘
- (void)addNote{
    
    AddRemindViewController *vc = [[AddRemindViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//初始化星期选择条
- (void)initWeekChooseBar{
    self.weekChooseBar = [[WMTWeekChooseBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 39*autoSizeScaleY) nowWeek:self.dateModel.nowWeek];
    self.weekChooseBar.hidden = self.hiddenWeekChooseBar;
    [self.weekChooseBar changeIndex:self.index];
    [self.view addSubview:self.weekChooseBar];
}

//更新星期选择条状态
- (void)updateWeekChooseBar{
    if (!self.weekChooseBarLock) {
        
        
        if (self.hiddenWeekChooseBar) {
            self.hiddenWeekChooseBar = NO;
            [UIView animateWithDuration:0.1f animations:^{
                self.weekChooseBar.layer.opacity = 1.0f;
            } completion:^(BOOL finished) {
                self.weekChooseBar.hidden = self.hiddenWeekChooseBar;
            }];
            
            [self initTitleBtn];
            [self updateScrollViewFame];
            
        }else{
            self.hiddenWeekChooseBar = YES;
            [UIView animateWithDuration:0.1f animations:^{
                self.weekChooseBar.layer.opacity = 0.0f;
            } completion:^(BOOL finished) {
                self.weekChooseBar.hidden = self.hiddenWeekChooseBar;
            }];
            [self initTitleBtn];
            [self updateScrollViewFame];
        }
    }
}
-(void)updateScrollViewFame{
    //NSLog(@"num:%lu",(unsigned long)_scrollView.subviews.count);
    if (self.hiddenWeekChooseBar) {

        [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.scrollView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-HEADERHEIGHT-NVGBARHEIGHT)];
        } completion:nil];
        
        for (int i = 0; i < 26; i++) {
            //NSLog(@"num:%d",i);
            WYCClassBookView *view = _scrollView.subviews[i];
            [view changeScrollViewContentSize:CGSizeMake(0, 606*autoSizeScaleY)];
            [view layoutIfNeeded];
            [view layoutSubviews];
        }
    }else{
        [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.scrollView setFrame:CGRectMake(0, self.weekChooseBar.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-HEADERHEIGHT-NVGBARHEIGHT- self.weekChooseBar.frame.size.height)];
        } completion:nil];


        for (int i = 0; i < 26; i++) {
            WYCClassBookView *view = _scrollView.subviews[i];
            [view changeScrollViewContentSize:CGSizeMake(0, 606*autoSizeScaleY + self.weekChooseBar.frame.size.height)];
            [view layoutIfNeeded];
            [view layoutSubviews];

        }
    }
}



- (void)showDetail:(NSArray *)array{
    if ([[UIApplication sharedApplication].keyWindow viewWithTag:999]) {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:999] removeFromSuperview];
    }
    //初始化全屏view
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //设置view的tag
    view.layer.shadowOffset = CGSizeMake(0,1.5);
    view.layer.shadowRadius = 5;
    view.layer.shadowOpacity = 0.5;
    view.layer.cornerRadius = 8;
    view.tag = 999;
    
    // 汪明天要改的东西
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *blurBackgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    blurBackgroundView.frame = view.frame;
//    [view addSubview:blurBackgroundView];
//    
    
    //往全屏view上添加内容
    WYCShowDetailView *detailClassBookView  = [[WYCShowDetailView alloc]initWithFrame:CGRectMake(0, 2 * SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    detailClassBookView.chooseClassListDelegate = self;
    [detailClassBookView initViewWithArray:array];
    
    
    //添加点击手势
    UIGestureRecognizer *hiddenDetailView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenDetailView)];
    [detailClassBookView addGestureRecognizer:hiddenDetailView];
    
    
    //显示全屏view
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    view.layer.opacity = 0.0f;
    [view addSubview:detailClassBookView];
    [window addSubview:view];
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        view.layer.opacity = 1.0f;
        detailClassBookView.layer.opacity = 1.0f;
        detailClassBookView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:nil];
    
}
- (void)hiddenDetailView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [window viewWithTag:999];
    [UIView animateWithDuration:0.4f animations:^{
//        [view.subviews[1] setFrame: CGRectMake(0, 2 * SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}



- (void)clickEditNoteBtn:(NSDictionary *)dic{
    [self hiddenDetailView];
    AddRemindViewController *vc = [[AddRemindViewController alloc]initWithRemind:dic];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)clickDeleteNoteBtn:(NSDictionary *)dic{
    [self hiddenDetailView];
    NSNumber *noteId = [dic objectForKey:@"id"];
    NSString *stuNum = [UserDefaultTool getStuNum];
    NSString *idNum = [UserDefaultTool getIdNum];
    
    WYCClassAndRemindDataModel *model = [[WYCClassAndRemindDataModel alloc]init];
    [model deleteRemind:stuNum idNum:idNum remindId:noteId];
    [self reloadView];
}


@end


