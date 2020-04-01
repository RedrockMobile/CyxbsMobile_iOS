//
//  QADetailViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QADetailViewController.h"
#import "QAAnswerViewController.h"
#import "QADetailModel.h"
#import "QADetailView.h"
@interface QADetailViewController ()<QADetailDelegate>
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)NSNumber *id;
@property(strong,nonatomic)QADetailModel *model;
@end

@implementation QADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F9FC"];
}


-(instancetype)initViewWithId:(NSNumber *)id title:(NSString *)title{
    self = [super init];
    self.title = title;
//    [self setNavigationBar:title];
    self.id = id;
    self.model = [[QADetailModel alloc]init];
    [self setNotification];
    
    [self loadData];
    return self;
}

- (void)setupUI{
    //    NSLog(@"%@",self.model.dataDic);
    NSDictionary *detailData = self.model.detailData;
    NSArray *answersData = self.model.answersData;
    QADetailView *detailView = [[QADetailView alloc]initWithFrame:CGRectMake(0, TOTAL_TOP_HEIGHT, SCREEN_WIDTH, self.view.height - TOTAL_TOP_HEIGHT)];
    
    [detailView setupUIwithDic:detailData answersData:answersData];
    [detailView.answerButton setTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside];
    detailView.delegate = self;
    [self.view addSubview:detailView];
}
- (void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载数据中...";
    hud.color = [UIColor colorWithWhite:0.f alpha:0.4f];
    [self.model getDataWithId:self.id];
}
- (void)setNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailDataLoadSuccess)
                                                 name:@"QADetailDataLoadSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailDataLoadError)
                                                 name:@"QADetailDataLoadError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailDataLoadFailure)
                                                 name:@"QADetailDataLoadFailure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:@"QADetailDataReLoad" object:nil];
}

- (void)QADetailDataLoadSuccess{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self setupUI];
    //    NSLog(@"%D,%@",self.model.dataArray.count, self.model.dataArray[0]);
}
- (void)QADetailDataLoadError{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"数据加载错误" message:@"网络数据解析错误" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

- (void)QADetailDataLoadFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"网络错误" message:@"数据加载失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
- (void)reloadView{
    [self.view removeAllSubviews];
    [self loadData];
}
- (void)report{
    /*
     先创建UIAlertController，preferredStyle：选择UIAlertControllerStyleActionSheet，这个就是相当于创建8.0版本之前的UIActionSheet；
     
     typedef NS_ENUM(NSInteger, UIAlertControllerStyle) {
     UIAlertControllerStyleActionSheet = 0,
     UIAlertControllerStyleAlert
     } NS_ENUM_AVAILABLE_IOS(8_0);
     */
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择对象" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    /*
     typedef NS_ENUM(NSInteger, UIAlertActionStyle) {
     UIAlertActionStyleDefault = 0,
     UIAlertActionStyleCancel,         取消按钮
     UIAlertActionStyleDestructive     破坏性按钮，比如：“删除”，字体颜色是红色的
     } NS_ENUM_AVAILABLE_IOS(8_0);
     
     */
    // 创建action，这里action1只是方便编写，以后再编程的过程中还是以命名规范为主
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"A类" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择了A类" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"B类" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择了B类" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    
    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)answer:(UIButton *)sender{
    QAAnswerViewController *vc = [[QAAnswerViewController alloc]initWithQuestionId:self.id content:[self.model.detailData objectForKey:@"title"]];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)replyComment:(nonnull NSNumber *)answerId {
}

- (void)tapCommentBtn:(nonnull NSNumber *)answerId {
    [self.model getCommentData:answerId];
}

- (void)tapPraiseBtn:(UIButton *)pariseBtn answerId:(nonnull NSNumber *)answerId{
    if ([pariseBtn isSelected]) {
        [self.model cancelPraise:answerId];
    }else{
        [self.model praise:answerId];
    }
}
- (void)tapAdoptBtn:(nonnull NSNumber *)answerId{
    [self.model adoptAnswer:self.id answerId:answerId];
}
@end
