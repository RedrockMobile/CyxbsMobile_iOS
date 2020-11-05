//
//  ByPasswordViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 杨远舟 on 2020/10/31.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ByPasswordViewController.h"
#import "Masonry.h"
#define kRateX [UIScreen mainScreen].bounds.size.width/375   //以iPhoneX为基准
#define kRateY [UIScreen mainScreen].bounds.size.height/812  //以iPhoneX为基准

@interface ByPasswordViewController ()

@property(nonatomic, weak)UITextView *tf;
@property(nonatomic, weak) UIButton *saveBtn;
@property(nonatomic, weak)UILabel *placeHolder;
@property(nonatomic, weak) UIButton *btn2;

@end

@implementation ByPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:88/255.0 alpha:1.0];
    self.navigationController.navigationBar.topItem.title = @"找回密码";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self setLable];
    [self setTextView];
    [self setBtn];
    [self setBtnCode];
    
}
-(void) setLable{
    //uilable
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(20,25,240,21);
    label1.numberOfLines = 0;
    [self.view addSubview:label1];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"你的保密邮箱是, 请点击获取验证码" attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 15], NSForegroundColorAttributeName: [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]}];
    label1.attributedText = string;
    label1.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    label1.alpha = 0.64;
    

    UILabel *label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(20,53,213,22);
    label3.numberOfLines = 0;
    [self.view addSubview:label3];
    label3.text = @"257****3041@qq.com";
    label3.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
}
-(void) dismissKeyBoard{
    [self.tf resignFirstResponder];
}

-(void) setTextView{
    UITextView *tf = [[UITextView alloc]initWithFrame:(CGRectMake(20,107,339,45))];
    tf.layer.cornerRadius = 10;//设置边框圆角
    tf.layer.masksToBounds = YES;
    tf.textContainerInset = UIEdgeInsetsMake(15, 10, 10, 10);//设置边界间距
    tf.backgroundColor = [UIColor colorWithRed:232/255.0 green:240/255.0 blue:252/255.0 alpha:1.0];
    [self.view addSubview:tf];
      self.tf=tf;
      
      UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
         [topView setBarStyle:UIBarStyleDefault];
         UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
         UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
         NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];

         [topView setItems:buttonsArray];
         [tf setInputAccessoryView:topView];
      
      UILabel *placeHolderLabel = [[UILabel alloc] init];
      placeHolderLabel.text = @"请输入验证码";
      placeHolderLabel.textColor = [UIColor colorWithRed:157/255.0 green:168/255.0 blue:188/255.0 alpha:1.0];
      placeHolderLabel.numberOfLines = 0;
      [placeHolderLabel sizeToFit];
      [tf addSubview:placeHolderLabel];
      // same font
      tf.font = [UIFont systemFontOfSize:16.f];
      placeHolderLabel.font = [UIFont systemFontOfSize:16.f];
      [tf setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}

-(void) setBtn{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(48*kRateX, 310*kRateY, 280*kRateX, 52*kRateY);
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:25.0];
    btn.backgroundColor = [UIColor colorWithRed:69/255.0 green:73/255.0 blue:219/255.0 alpha:1.0];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont fontWithName:@"Arial" size:18.0];
    [btn addTarget:self action:@selector(jumpTOset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void) setBtnCode{
    UIButton *btn2 =[UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(265,118,80,21);
    [btn2 setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor colorWithRed:75/255.0 green:69/255.0 blue:229/255.0 alpha:1.0] forState:UIControlStateNormal];
    //[btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn2 addTarget:self action:@selector(getCode)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}
-(void) jumpTOset{
    printf("跳转至修改密码页面\n");
}
-(void) getCode{
    printf("获取验证码\n");
    [_btn2 setTitle:@"正在发送" forState:UIControlStateNormal];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewControlTOsetr].
    // Pass the selected object to the new view controller.
}
*/

@end
