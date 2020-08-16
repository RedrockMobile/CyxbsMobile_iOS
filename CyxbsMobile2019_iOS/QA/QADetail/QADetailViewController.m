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
#import "QADetailReportView.h"
#import "GKPhotoBrowser.h"
#import "QAReviewViewController.h"
@interface QADetailViewController ()<QADetailDelegate>
///貌似这个属性没有用到，先注释掉
//@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)NSNumber *question_id;
@property(strong,nonatomic)QADetailModel *model;
//举报界面
@property(strong,nonatomic)SDMask *reportViewMask;
@property(strong,nonatomic)QADetailReportView *reportView;
@property(strong,nonatomic)QADetailView *detailView;
@end

@implementation QADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F9FC"];
    
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"QAListCellColor"];
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    }
}

- (void)customNavigationRightButton{
    [self.rightButton setImage:[UIImage imageNamed:@"QAMoreButton"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(showReportView) forControlEvents:UIControlEventTouchUpInside];
}

-(instancetype)initViewWithId:(NSNumber *)question_id title:(NSString *)title{
    self = [super init];
    self.title = title;
//    [self setNavigationBar:title];
    self.question_id = question_id;
    self.model = [[QADetailModel alloc]init];
    [self setNotification];
    
    [self loadData];
    return self;
}

- (void)setupUI{
    
    NSDictionary *detailData = self.model.detailData;
    NSArray *answersData = self.model.answersData;
    QADetailView *detailView = [[QADetailView alloc]initWithFrame:CGRectMake(0, TOTAL_TOP_HEIGHT, SCREEN_WIDTH, self.view.height - TOTAL_TOP_HEIGHT)];
    self.detailView = detailView;
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
    //getDataWithId会发送网络请求，请求后会发送通知，
    //成功->调用控制器的QADetailDataLoadSuccess方法，失败->QADetailDataLoadError
    [self.model getDataWithId:self.question_id];
}
- (void)setNotification{
    //数据加载
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
    //举报问题
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailReportSuccess)
                                                 name:@"QADetailReportSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(QADetailReportError)
                                                    name:@"QADetailReportError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailReportFailure)
                                                 name:@"QADetailReportFailure" object:nil];
    //忽略问题
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailIgnoreSuccess)
                                                 name:@"QADetailIgnoreSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailIgnoreError)
                                                 name:@"QADetailIgnoreError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailIgnoreFailure)
                                                 name:@"QADetailIgnoreFailure" object:nil];
    //上拉加载
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailDataLoadMoreSuccess)
                                                 name:@"QADetailDataLoadMoreSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailDataLoadMoreError)
                                                 name:@"QADetailDataLoadMoreError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailDataLoadMoreFailure)
                                                 name:@"QADetailDataLoadMoreFailure" object:nil];
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
- (void)QADetailReportSuccess{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"举报成功" message:@"会尽快为您处理" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [controller addAction:act1];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
- (void)QADetailReportError{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"举报失败" message:@"服务器错误或您已举报过该问题。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
- (void)QADetailReportFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"举报失败" message:@"举报请求提交失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [controller addAction:act1];
    [self presentViewController:controller animated:YES completion:^{}];
}
- (void)QADetailIgnoreSuccess{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"忽略问题" message:@"已忽略该问题" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self.navigationController popViewControllerAnimated:YES];
    }];
    [controller addAction:act1];
    [self presentViewController:controller animated:YES completion:^{}];
}
- (void)QADetailIgnoreError{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"忽略问题" message:@"服务器错误或您已忽略过该问题。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [controller addAction:act1];
    [self presentViewController:controller animated:YES completion:^{}];
}
- (void)QADetailIgnoreFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"忽略问题" message:@"忽略问题请求提交失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [controller addAction:act1];
    [self presentViewController:controller animated:YES completion:^{}];
}
- (void)QADetailDataLoadMoreSuccess{
    [self.detailView loadMoreWithArray:self.model.answersData ifSuccessful:YES];
}
- (void)QADetailDataLoadMoreError{
    [self.detailView loadMoreWithArray:self.model.answersData ifSuccessful:NO];
}
- (void)QADetailDataLoadMoreFailure{
    [self.detailView loadMoreWithArray:self.model.answersData ifSuccessful:NO];
}

- (void)reloadView{
    [self.view removeAllSubviews];
    [self customNavigationBar];
    [self customNavigationRightButton];
    [self loadData];
}
- (void)showReportView{
    
    self.reportView = [[QADetailReportView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 530)];
    [self.reportView setBackgroundColor:UIColor.clearColor];
    [self.reportView setupView];
    for (UIButton *btn in self.reportView.reportBtnCollection) {
        if (btn.tag == 5){
             [btn addTarget:self action:@selector(ignore:) forControlEvents:UIControlEventTouchUpInside];
        }else{
        [btn addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self.reportView.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    self.reportViewMask = [[SDMaskUserView(self.reportView) sdm_showActionSheetIn:self.view usingBlock:nil] usingAutoDismiss];
        [self.reportViewMask show];
}
//举报问题
- (void)report:(UIButton *)sender{
    [self.reportViewMask dismiss];
    [self.model report:sender.titleLabel.text question_id:self.question_id];
}
//忽略问题
- (void)ignore:(UIButton *)sender{
    [self.reportViewMask dismiss];
    [self.model ignore:self.question_id];
}
- (void)cancel:(UIButton *)sender{
    [self.reportViewMask dismiss];
}

- (void)answer:(UIButton *)sender{
    QAAnswerViewController *vc = [[QAAnswerViewController alloc]initWithQuestionId:self.question_id content:[self.model.detailData objectForKey:@"description"] answer:@""];
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
    [self.model adoptAnswer:self.question_id answerId:answerId];
}

// 这个方法是查看问题大图，由于种种原因，这里的参数名称不太对，懒得改了，将就看吧
- (void)tapToViewBigImage:(NSInteger)answerIndex{
    NSArray *imageUrls = [self.model.detailData objectForKey:@"photo_url"];
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < imageUrls.count; i++) {
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrls[i]]];
        [photos addObject:photo];
    }
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:answerIndex];
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    [browser showFromVC:self];
}

// 这个是查看回答的大图，由于种种原因，和上面那个方法基本上一样，也懒得改了了，将就看吧
- (void)tapToViewBigAnswerImage:(NSInteger)answerIndex {
    for (NSDictionary *answerData in self.model.answersData) {
        if ([[answerData objectForKey:@"id"] integerValue] == answerIndex){
            
            NSArray *imageUrls = [answerData objectForKey:@"photo_url"];
            NSMutableArray *photos = [NSMutableArray array];
            for (int i = 0; i < imageUrls.count; i++) {
                GKPhoto *photo = [GKPhoto new];
                photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrls[i]]];
                [photos addObject:photo];
            }
            GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:0];
            browser.showStyle = GKPhotoBrowserShowStyleNone;
            [browser showFromVC:self];
            
        }
    }
}

//点击某条回答后调用，answerId是某条回答的tag
- (void)tapToViewComment:(NSNumber *)answerId{
    for(int i = 0; i < self.model.answersData.count; i++){
        NSDictionary *dic = self.model.answersData[i];
        if ([answerId integerValue] == [[dic objectForKey:@"id"] integerValue]) {
            QAReviewViewController *vc = [[QAReviewViewController alloc]initViewWithId:answerId answerData:dic];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
    
    
}
//QADetailView的代理方法，用来下拉刷新
- (void)reloadData{
    [self.detailView removeFromSuperview];
    [self loadData];
}
//QADetailView的代理方法，用来上拉加载
- (void)loadMoreAtPage:(NSNumber*)page{
    //这个方法请求数据后会发送通知中心，调用self的几个方法
    [self.model getAnswersWithId:self.question_id AndPage:page];
}
@end
