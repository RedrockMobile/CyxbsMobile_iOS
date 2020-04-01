//
//  QAAskViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAAskViewController.h"
#import "QAAskModel.h"
#import "QAAskNextStepView.h"
#import "QAAskNextStepViewController.h"
#import "QAAskIntegralPickerView.h"
#import "QAAskExitView.h"
@interface QAAskViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(strong,nonatomic)UITextView *askTextView;
@property(strong,nonatomic)NSMutableArray *askImageArray;
@property(strong,nonatomic)QAAskModel *model;
@property(strong,nonatomic)UITextField *titleTextField;
@property(strong,nonatomic)QAAskNextStepView *nextStepView;
@property(copy,nonatomic)NSString *kind;
@property(strong,nonatomic)NSMutableArray *kindBtnArray;
@end

@implementation QAAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavagationBar];
    [self setNavigationBar:@"提问"];
    [self setNotification];
    [self setupUI];
}

- (void)setNavigationBar:(NSString *)title{
    //设置标题
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    [label setFrame:CGRectMake(0, 0, SCREEN_WIDTH, NVGBARHEIGHT)];
    label.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 23], NSForegroundColorAttributeName: [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    label.alpha = 1.0;
    self.navigationItem.titleView = label;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0 , 0, 60, 60);
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#15315B"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:PingFangSCRegular size:20]];
    [button addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    // 设置rightBarButtonItem
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //设置返回按钮样子
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#122D55"];
    
}
- (void)configNavagationBar {
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]}];
    //隐藏导航栏的分割线
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorNamed:@"navicolor" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    } else {
        // Fallback on earlier versions
    }
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}
- (void)setNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAQuestionCommitSuccess)
                                                 name:@"QAQuestionCommitSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAQuestionCommitFailure)
                                                 name:@"QAQuestionCommitFailure" object:nil];
}
- (void)QAQuestionCommitSuccess{
    [self hiddenNextStepView];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)QAQuestionCommitFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"网络错误" message:@"答案提交失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
- (void)setupUI{
    
    
    UIView *separateView = [[UIView alloc]init];
    separateView.backgroundColor = [UIColor colorWithHexString:@"#2A4E84"];
    separateView.alpha = 0.1;
    [self.view addSubview:separateView];
    
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(TOTAL_TOP_HEIGHT);
        make.height.mas_equalTo(1);
    }];
    
    UIView *titleView = [[UIView alloc]init];
    [self.view addSubview:titleView];
    [titleView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.top.mas_equalTo(separateView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(25);
    }];
    NSArray *titleArray = @[@"学习",@"匿名",@"生活",@"其他"];
    self.kindBtnArray = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i++) {
        
        UIButton *titleBtn = [[UIButton alloc]init];
        [titleBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor colorWithHexString:@"#94A6C4"] forState:UIControlStateNormal];
        [titleBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCRegular size:13]];

        titleBtn.layer.cornerRadius = 12;
        titleBtn.tag = i;
        [titleBtn addTarget:self action:@selector(tapTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [titleBtn setFrame:CGRectMake(20, 5, 45, 23)];
            titleBtn.backgroundColor = [UIColor colorWithHexString:@"#F7DAD7"];
        }else{
            [titleBtn setFrame:CGRectMake(20+i*65, 5, 45, 23)];
            titleBtn.backgroundColor = [UIColor colorWithHexString:@"#E8F0FC"];
        }
        
        [self.kindBtnArray addObject:titleBtn];
        [titleView addSubview:titleBtn];
        
    }
    self.titleTextField = [[UITextField alloc]init];
    self.titleTextField.backgroundColor = [UIColor colorWithHexString:@"#E8F0FC"];
    self.titleTextField.placeholder = @"  输入标题";
    [self.view addSubview:self.titleTextField];
    
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.top.mas_equalTo(titleView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(40);
    }];
    
    self.askTextView = [[UITextView alloc]init];
    self.askTextView.backgroundColor = [UIColor colorWithHexString:@"#e8edfd"];
    [self.askTextView setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    //自适应高度
    self.askTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.askTextView.text = @"提问内容";
    [self.askTextView setFont:[UIFont fontWithName:PingFangSCRegular size:16]];
    self.askTextView.delegate = self;
    [self.view addSubview:self.askTextView];
    [self.askTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(self.titleTextField.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(215);
    }];
    
    UIImageView *addImageView = [[UIImageView alloc]init];
    self.askImageArray = [NSMutableArray array];
//    [self.askImageArray addObject:addImageView];
    [addImageView setImage:[UIImage imageNamed:@"userIcon"]];
    //    [addImageView setImage:self.askImageArray[0]];
    addImageView.userInteractionEnabled = YES;
    //添加点击手势
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)];
    [addImageView addGestureRecognizer:tapGesture];
    [self.view addSubview:addImageView];
    [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(self.askTextView.mas_bottom).mas_offset(10);
        make.height.width.mas_equalTo(110);
        
    }];
    //
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}
- (void)tapTitleBtn:(UIButton *)sender{
    
    for (int i = 0;i < self.kindBtnArray.count;i++) {
        UIButton *btn = self.kindBtnArray[i];
        if (i == sender.tag) {
            btn.backgroundColor = [UIColor colorWithHexString:@"#F7DAD7"];
        }else{
            btn.backgroundColor = [UIColor colorWithHexString:@"#E8F0FC"];
        }
    }
    NSArray *titleArray = @[@"学习",@"匿名",@"生活",@"其他"];
    self.kind = titleArray[sender.tag];
}

- (void)setAddImageView{
    
    
    if (self.askImageArray.count<3&&self.askImageArray.count>0) {
        
        UIImageView *addImageView = [[UIImageView alloc]init];
        
        [addImageView setImage:[UIImage imageNamed:@"userIcon"]];
        addImageView.userInteractionEnabled = YES;
        //添加点击手势
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)];
        [addImageView addGestureRecognizer:tapGesture];
        [self.view addSubview:addImageView];
        NSInteger count = self.askImageArray.count;
        
        [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(20+110*count);
            make.top.mas_equalTo(self.askTextView.mas_bottom).mas_offset(10);
            make.height.width.mas_equalTo(100);
            
        }];
        [self.askImageArray addObject:addImageView];
        
    }else if (self.askImageArray.count>2&&self.askImageArray.count<6){
        
        UIImageView *addImageView = [[UIImageView alloc]init];
        
        [addImageView setImage:[UIImage imageNamed:@"userIcon"]];
        addImageView.userInteractionEnabled = YES;
        //添加点击手势
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)];
        [addImageView addGestureRecognizer:tapGesture];
        [self.view addSubview:addImageView];
        NSInteger count = self.askImageArray.count;
        
        [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(20+110*(count-3));
            make.top.mas_equalTo(self.askTextView.mas_bottom).mas_offset(120);
            make.height.width.mas_equalTo(100);
            
        }];
        [self.askImageArray addObject:addImageView];
    }else{
        
    }
    
}
- (void)addImage{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;//编辑模式  但是编辑框是正方形的
    
#// 设置可用的媒体类型、默认只包含kUTTypeImage
    imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"从相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            //设置照片来源
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //        // 使用前置还是后置摄像头
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}
#pragma mark - =======UIImagePickerControllerDelegate=========

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    self.askImageArray[0] = image;
    UIImageView *imgView = [self.askImageArray lastObject];
    [imgView setImage:image];
    [self setAddImageView];
    //    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //    [self calulateImageFileSize:image];
    //当选择的类型是图片
    
}
// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)nextStep{
    if ([[UIApplication sharedApplication].keyWindow viewWithTag:999]) {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:999] removeFromSuperview];
    }
    //初始化全屏view
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor colorWithHexString:@"#DCDDE3"];
    //设置view的tag
    view.tag = 999;
    UIView *backView = [[UIView alloc]init];
    [backView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //        backView.alpha = 0;
    //添加点击手势
    UIGestureRecognizer *hiddenNextStepView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenNextStepView)];
    [backView addGestureRecognizer:hiddenNextStepView];
    [view addSubview:backView];
    
    self.nextStepView = [[QAAskNextStepView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 550)];
    [self.nextStepView.cancelBtn addTarget:self action:@selector(hiddenNextStepView) forControlEvents:UIControlEventTouchUpInside];
    [self.nextStepView.commitBtn addTarget:self action:@selector(commitAsk) forControlEvents:UIControlEventTouchUpInside];
    self.nextStepView.userInteractionEnabled = YES;
    self.nextStepView.alpha = 1;
    [view addSubview:self.nextStepView];
    
    //显示全屏view
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT - 530, SCREEN_WIDTH, 550);
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self->_nextStepView.frame = frame;
        [backView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 530)];
    } completion:nil];
    
    
    
}
- (void)hiddenNextStepView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [window viewWithTag:999];
    [UIView animateWithDuration:0.4f animations:^{
        //        CGRect frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 500);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void)commitAsk{
    NSString *title = self.titleTextField.text;
    NSString *content = self.askTextView.text;
    QAAskIntegralPickerView *integralPickerView =  self.nextStepView.integralPickView;
    NSString *reward = integralPickerView.integralNum;
    NSString *disappearTime = self.nextStepView.time;
    self.model = [[QAAskModel alloc]init];
    [self.model commitAsk:title content:content kind:self.kind reward:reward disappearTime:disappearTime imageArray:self.askImageArray];
    
}
-(BOOL)navigationShouldPopOnBackButton{
    if (1) {
        // 在这里创建UIAlertController等方法
        [self saveAskContent];
        return NO;
    }
    return YES;
}
- (void)saveAskContent{
    if ([[UIApplication sharedApplication].keyWindow viewWithTag:997]) {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:997] removeFromSuperview];
    }
    //初始化全屏view
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor colorWithHexString:@"#DCDDE3"];
    //设置view的tag
    view.tag = 997;
    QAAskExitView *exitView = [[QAAskExitView alloc]initWithFrame:CGRectMake(60,200, SCREEN_WIDTH - 120, SCREEN_HEIGHT - 400)];
    [exitView.saveAndExitBtn addTarget:self action:@selector(saveAndExit) forControlEvents:UIControlEventTouchUpInside];
    [exitView.continueEditBtn addTarget:self action:@selector(continueEdit) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:exitView];
   
    //显示全屏view
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
//    CGRect frame = CGRectMake(0, SCREEN_HEIGHT - 530, SCREEN_WIDTH, 550);
//    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
//
//        [backView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 530)];
//    } completion:nil];
    
    
}
- (void)continueEdit{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [window viewWithTag:997];
    [view removeFromSuperview];
    
//    [UIView animateWithDuration:0.4f animations:^{
//        //        CGRect frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 500);
//    } completion:^(BOOL finished) {
//        [view removeFromSuperview];
//    }];
}
- (void)saveAndExit{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [window viewWithTag:997];
    [view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
