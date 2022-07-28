//
//  YYZGetIdVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 杨远舟 on 2020/12/5.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Masonry.h>
#import "YYZGetIdVC.h"
#import "ByWordViewController.h"
#import "ByPasswordViewController.h"
//#import "YYZSendVC.h"
#import "YYZpopView.h"
#import "掌上重邮-Swift.h"        // 将Swift中的类暴露给OC


@interface YYZGetIdVC () <UITextFieldDelegate>

@property (nonatomic, strong) FindPasswordView *findPasswordView;
@property (nonatomic, strong) YYZpopView *popView;
@property (nonatomic, strong) UIView *backView;


@end

@implementation YYZGetIdVC


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}
-(void) clickLeftButton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [NSUserDefaults.standardUserDefaults setBool:0 forKey:@"isLogin"];
    //设置导航栏
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"ㄑ忘记密码" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftButton)];
    [leftButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:21.0], NSFontAttributeName,
    [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]], NSForegroundColorAttributeName,nil]forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem =leftButton;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]]];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
    [self setBtn];
    [self setText];
    [self setImage];
    [self setLable];
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.36;
    [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender){
        [self->_backView removeFromSuperview];
        [self->_popView removeFromSuperview];
    }]];
    
    YYZpopView *popView = [[YYZpopView alloc]initWithFrame:CGRectMake(60, 267, 255, 329)];
    popView.layer.cornerRadius = 8;
    popView.layer.masksToBounds = YES;
    self.popView = popView;
    

}
-(void) backToLogin{
    LoginViewController *loginVc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVc animated:YES];
}
-(void) setImage{
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 195, 18, 21)];
    UIImage *image = [UIImage imageNamed:@"账号"];
    imageV.image = image;
    [self.view addSubview:imageV];
}
//下划线
- (void) setText{
    UITextField *testF = [[UITextField alloc]init];
    self.testF = testF;
    testF.placeholder = @"请输入学号";
    testF.keyboardType = UIKeyboardTypeNumberPad;
    testF.font = [UIFont fontWithName:@"Arial" size:18.0];
    testF.frame = CGRectMake(55,182, 180, 50) ;
    testF.delegate = self;
    [self.view addSubview:testF];
}
-(void) setLable{
    UILabel *lableLine = [[UILabel alloc]init];
    lableLine.frame = CGRectMake(30, 230, 310, 1);
    lableLine.backgroundColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:88/255.0 alpha:0.1];
    [self.view addSubview:lableLine];
}
-(void) setBtn{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(48, 310, 280, 52);
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:25.0];
    btn.backgroundColor = [UIColor colorWithRed:69/255.0 green:73/255.0 blue:219/255.0 alpha:1.0];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont fontWithName:@"Arial" size:20.0];
    [btn addTarget:self action:@selector(jumpTOchangeword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).mas_offset(SCREEN_HEIGHT * 0.3867 + TOTAL_TOP_HEIGHT);
            make.left.mas_equalTo(self.view).mas_offset(SCREEN_WIDTH * 0.128);
            make.width.mas_equalTo(SCREEN_WIDTH * 0.7467);
            make.height.mas_equalTo(SCREEN_WIDTH * 0.7467 * 52/280);
    }];
}

-(void)jumpTOchangeword{
    //判断学号格式是否正确
    if(self.testF.text.length != 10){
        [NewQAHud showHudWith:@" 请输入正确格式的学号  " AddView:self.view];
        return;
    }
    
    [HttpTool.shareTool
     request:Mine_POST_ifOriginPassword_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:@{@"stu_num":self.testF.text}
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        //如果是默认密码，弹出提示框
        if([object[@"status"] isEqualToNumber:[NSNumber numberWithInt:10000]]){
            self->_popView.alpha = 1.0;
            [self.view addSubview:self->_backView];
            [self.view addSubview:self.popView];
            [self->_popView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.view);
                //make.top.equalTo(self.view).offset = 267;
                make.centerY.equalTo(self.view);
                make.width.mas_offset(255);
                make.height.mas_offset(329);
            }];
            [self.popView showPop];
            [self.popView.backBtn addTarget:self action:@selector(backToLogin) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else{
            
            FindPasswordView *findPasswordView= [[FindPasswordView alloc] initWithFrame:self.view.bounds];
            findPasswordView.id2 = self.testF.text;
            self.findPasswordView = findPasswordView;
            [self.view addSubview:findPasswordView];
            
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"——————————错误信息如下————————%@",error);
        [NewQAHud showHudWith:@" 请求失败,请检查网络  " AddView:self.view];
    }];
    
//    [[HttpClient defaultClient]requestWithPath :Mine_POST_ifOriginPassword_API method:HttpRequestPost parameters:@{@"stu_num":self.testF.text} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        //如果是默认密码，弹出提示框
//        if([responseObject[@"status"] isEqualToNumber:[NSNumber numberWithInt:10000]]){
//            self->_popView.alpha = 1.0;
//            [self.view addSubview:self->_backView];
//            [self.view addSubview:self.popView];
//            [self->_popView mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.centerX.equalTo(self.view);
//                //make.top.equalTo(self.view).offset = 267;
//                make.centerY.equalTo(self.view);
//                make.width.mas_offset(255);
//                make.height.mas_offset(329);
//            }];
//            [self.popView showPop];
//            [self.popView.backBtn addTarget:self action:@selector(backToLogin) forControlEvents:UIControlEventTouchUpInside];
//            
//        }
//        else{
//            
//            FindPasswordView *findPasswordView= [[FindPasswordView alloc] initWithFrame:self.view.bounds];
//            findPasswordView.id2 = self.testF.text;
//            self.findPasswordView = findPasswordView;
//            [self.view addSubview:findPasswordView];
//            
//        }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"——————————错误信息如下————————%@",error);
//            [NewQAHud showHudWith:@" 请求失败,请检查网络  " AddView:self.view];
//        }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.testF) {
        if (string.length == 0) return YES;
       NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
        [newtxt replaceCharactersInRange:range withString:string];
        if (newtxt.length > 10) return NO;
    }
    return YES;
}


- (void)addViewTo:(UIView *)view {
    [view addSubview:self.view];
}


- (void)dealloc
{
    [self.findPasswordView removeFromSuperview];
}

@end
