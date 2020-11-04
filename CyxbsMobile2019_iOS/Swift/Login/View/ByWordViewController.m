//
//  ByWordViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 杨远舟 on 2020/10/30.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ByWordViewController.h"
#import "Masonry.h"
#define kRateX [UIScreen mainScreen].bounds.size.width/375   //以iPhoneX为基准
#define kRateY [UIScreen mainScreen].bounds.size.height/812  //以iPhoneX为基准

@interface ByWordViewController ()
@property(nonatomic, weak)UITextView *tf;
@property(nonatomic, weak) UIButton *saveBtn;
@property(nonatomic, weak)UILabel *placeHolder;

@end

@implementation ByWordViewController

-(void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
        backButton.title = @"找回密码";
        [self.navigationItem setBackBarButtonItem:backButton];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:88/255.0 alpha:1.0];
    self.navigationController.navigationBar.topItem.title = @"找回密码";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self setLable];
    [self setTextView];
    [self setBtn];
    
}
-(void) setLable{
    //uilable
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(20,20,120,21);
    label1.numberOfLines = 0;
    [self.view addSubview:label1];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"你的密保问题是：" attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 15], NSForegroundColorAttributeName: [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]}];
    label1.attributedText = string;
    label1.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    label1.alpha = 0.64;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(20,85,120,21);
    label2.numberOfLines = 0;
    [self.view addSubview:label2];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"你的问题答案是：" attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 15], NSForegroundColorAttributeName: [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]}];
    label2.attributedText = string2;
    label2.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    label2.alpha = 0.64;

    UILabel *label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(20,45,213,22);
    label3.numberOfLines = 0;
    [self.view addSubview:label3];
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@"啦啦啦啦啦啦啦啦啦啦啦啦啦" attributes:@{NSFontAttributeName: [UIFont fontWithName:@".PingFang SC" size: 16], NSForegroundColorAttributeName: [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]}];
    label3.attributedText = string3;
    label3.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    label3.alpha = 1.0;
}
-(void) dismissKeyBoard{
    [self.tf resignFirstResponder];
}

-(void) setTextView{
    UITextView *tf = [[UITextView alloc]initWithFrame:(CGRectMake(20,218-100,339,100))];
    tf.layer.cornerRadius = 13;//设置边框圆角
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
      placeHolderLabel.text = @"请输入密保问题的答案 (由2-16位字符组成)";
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
    btn.frame = CGRectMake(48*kRateX, (407-110)*kRateY, 280*kRateX, 52*kRateY);
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

-(void) jumpTOset{
    printf("跳转至修改密码页面\n");
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
