//
//  QAReviewViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAReviewViewController.h"
#import "QAReviewModel.h"
#import "QAReviewView.h"
#import "QAReviewReportView.h"
#import "GKPhotoBrowser.h"
@interface QAReviewViewController ()<QAReviewDelegate>
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)NSNumber *answer_id;
@property(strong,nonatomic)QAReviewModel *model;
@property(strong,nonatomic)NSDictionary *answerData;
//举报界面
@property(strong,nonatomic)SDMask *reportViewMask;
@property(strong,nonatomic)QAReviewReportView *reportView;
@end

@implementation QAReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"QAListCellColor"];
    } else {
        self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F9FC"];
    }
    
}

- (void)customNavigationRightButton{
    [self.rightButton setImage:[UIImage imageNamed:@"QAMoreButton"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(showReportView) forControlEvents:UIControlEventTouchUpInside];
}

-(instancetype)initViewWithId:(NSNumber *)answer_id answerData:(NSDictionary *)answerData{
    self = [super init];
    self.answer_id = answer_id;
    self.answerData = answerData;
    self.model = [[QAReviewModel alloc]init];
    [self setNotification];
    
    [self loadData];
    return self;
}

- (void)setupUI{
    //    NSLog(@"%@",self.model.dataDic);
    NSString *title = [NSString stringWithFormat:@"评论（%lu）",(unsigned long)self.model.reviewData.count];
    self.title = title;
    [self customNavigationBar];
    [self customNavigationRightButton];
    NSArray *reviewData = self.model.reviewData;
    NSDictionary *answerData = self.answerData;
    QAReviewView *reviewView = [[QAReviewView alloc]initWithFrame:CGRectMake(0, TOTAL_TOP_HEIGHT, SCREEN_WIDTH, self.view.height - TOTAL_TOP_HEIGHT)];
    
    [reviewView setupUIwithDic:answerData reviewData:reviewData];
    reviewView.delegate = self;
    [self.view addSubview:reviewView];
}
- (void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载数据中...";
    hud.color = [UIColor colorWithWhite:0.f alpha:0.4f];
    [self.model getDataWithId:self.answer_id];
}
- (void)setNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAReviewDataLoadSuccess)
                                                 name:@"QAReviewDataLoadSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAReviewDataLoadError)
                                                 name:@"QAReviewDataLoadError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAReviewDataLoadFailure)
                                                 name:@"QAReviewDataLoadFailure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:@"QAReviewDataReLoad" object:nil];
    //举报回答
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(QAReviewReportSuccess)
                                                    name:@"QAReviewReportSuccess" object:nil];
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                   selector:@selector(QAReviewReportError)
                                                       name:@"QAReviewReportError" object:nil];
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(QAReviewReportFailure)
                                                    name:@"QAReviewReportFailure" object:nil];
}

- (void)QAReviewDataLoadSuccess{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self setupUI];
    //    NSLog(@"%D,%@",self.model.dataArray.count, self.model.dataArray[0]);
}
- (void)QAReviewDataLoadError{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"数据加载错误" message:@"网络数据解析错误" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

- (void)QAReviewDataLoadFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"网络错误" message:@"数据加载失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

- (void)QAReviewReportSuccess{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"举报成功" message:@"会尽快为您处理" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [controller addAction:act1];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
- (void)QAReviewReportError{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"举报失败" message:@"服务器错误或您已举报过该回答。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
- (void)QAReviewReportFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"举报失败" message:@"举报请求提交失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [controller addAction:act1];
    [self presentViewController:controller animated:YES completion:^{}];
}
- (void)reloadView{
    [self.view removeAllSubviews];
    [self customNavigationBar];
    [self customNavigationRightButton];
    [self loadData];
}
- (void)showReportView{
    
    self.reportView = [[QAReviewReportView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 470)];
    [self.reportView setBackgroundColor:UIColor.clearColor];
    [self.reportView setupView];
    for (UIButton *btn in self.reportView.reportBtnCollection) {
        [btn addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.reportView.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    self.reportViewMask = [[SDMaskUserView(self.reportView) sdm_showActionSheetIn:self.view usingBlock:nil] usingAutoDismiss];
        [self.reportViewMask show];
}
//举报回答
- (void)report:(UIButton *)sender{
    [self.reportViewMask dismiss];
    [self.model report:sender.titleLabel.text answer_id:self.answer_id];
}

- (void)cancel:(UIButton *)sender{
    [self.reportViewMask dismiss];
}


- (void)replyComment:(nonnull NSNumber *)answerId {
}


- (void)tapPraiseBtn:(UIButton *)pariseBtn answerId:(nonnull NSNumber *)answerId{
    if ([pariseBtn isSelected]) {
        [self.model cancelPraise:answerId];
    }else{
        [self.model praise:answerId];
    }
}

- (void)tapToViewBigImage:(NSInteger)answerIndex{
    for (NSDictionary *answerData in self.model.reviewData) {
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
- (void)replyComment:(NSString *)content answerId:(NSNumber *)answerId{
//    NSLog(@"%@,%@",content,answerId);
    [self.model replyComment:content answerId:answerId];
}
@end
